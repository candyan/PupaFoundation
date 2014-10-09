//
//  DOUUserManager.m
//  DOUUserManager
//
//  Created by Jianjun Wu on 3/26/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "DOUAccountManager.h"
#import "DOUUserManagerUtil.h"
#import "SSKeychain.h"

NSString *const kDOUAMAccountListDidChangeNotification = @"com.douban.account_manager.acccount_list_did_changed";
NSString *const kDOUAMCurrentAccountDidChangeNotification = @"com.douban.account_manager.current_account_did_changed";
NSString *const kDOUCurrentAccountDidLogoutNotification = @"com.douban.common.account.current_account_did_logout";

NSString *const kDOUAMNotificationInfoKeyAccount = @"account";

NSString *const kDOUAccountManagerSharedAccountAccessGroup = @"com.douban.DOUSharedAccount";
NSString *const kDOUAccountManagerInfoKey = @"com.douban.common.account_manager.info";
NSString *const kDOUAccountManagerInfoKeyAccounts = @"accounts";
NSString *const kDOUAccountManagerInfoKeyCurAccountUUID = @"current_account_uuid";

NSString *const kDOUAccountManagerUserDefaultsKeyInstallFlag = @"com.douban.account_manager.installed";

static DOUAccountManager *instance = nil;

@interface DOUAccountManager ()
@property (nonatomic, strong) NSMutableDictionary *accountManagerDicInfo;
@property (nonatomic, strong) NSString *appDocPath;
@property (nonatomic, strong) NSString *appTmpPath;
@end

@implementation DOUAccountManager {
  id <DOUBasicAccount> _currentAccount;
}

- (id)init
{
  if ( (self = [super init]) ) {
    [self _moveAccountDataFromUserDefaultsToKeychain];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kDOUAccountManagerUserDefaultsKeyInstallFlag] == nil) {
      // 第一次运行，清空 keychain 中当前应用的所有帐号信息。
      [self _persistAccoutInfoDic:nil];

      [defaults setObject:@(YES) forKey:kDOUAccountManagerUserDefaultsKeyInstallFlag];
      [defaults synchronize];
    }
  }
  return self;
}

#pragma mark - Current account management method
- (id <DOUBasicAccount> )currentActiveAccount
{
  if (_currentAccount) {
    return _currentAccount;
  }
  NSString *currentUUID = [self.accountManagerDicInfo objectForKey:kDOUAccountManagerInfoKeyCurAccountUUID];
  if (currentUUID == nil || currentUUID.length < 1) {
    return nil;
  }
  _currentAccount = [self _accountByUUID:currentUUID];
  return _currentAccount;
}

- (BOOL)setCurrentAccountByUUID:(NSString *)accountUUID
{
  if (accountUUID == nil || accountUUID.length < 1) {
    return NO;
  }
  id <DOUBasicAccount> account = [self _accountByUUID:accountUUID];
  if (account) {
    _currentAccount = account;
    [self _setCurrentAccountUUID:accountUUID];
    return YES;
  }
  else {
    return NO;
  }
}

- (BOOL)addCurrentAccount:(DOUBasicAccount *)account
{
  BOOL addFlag = [self addAccount:account];
  BOOL setFlag = [self setCurrentAccountByUUID:[account userUUID]];
  return addFlag && setFlag;
}

- (void)logoutCurrentAccount
{
  [self logoutCurrentAccountAndSwitchNextAccount:YES];
}

- (void)logoutCurrentAccountAndSwitchNextAccount:(BOOL)flag
{
  id <DOUBasicAccount> curAccount = [self currentActiveAccount];
  if ([self _removeAccountInfo:curAccount]) {
    _currentAccount = nil;
    [self _setCurrentAccountUUID:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDOUCurrentAccountDidLogoutNotification
                                                        object:nil];
    if (flag) {
      NSArray *accountsArr = [self allAccounts];
      if ([accountsArr count] > 0) {
        id <DOUBasicAccount> nextAccount = [accountsArr objectAtIndex:0];
        [self setCurrentAccountByUUID:nextAccount.userUUID];
      }
    }
  }
}

- (void)setCurrentAccount:(id <DOUBasicAccount> )account
{
  if ([self isExistAccount:account]) {
    [self updateAccount:account];
  }
  else {
    [self addAccount:account];
  }
  [self setCurrentAccountByUUID:account.userUUID];
}

#pragma mark - Account CRUD methods
- (BOOL)addAccount:(id <DOUBasicAccount> )account
{
  if ([account isValidAccount] == NO) {
    return NO;
  }
  NSArray *accountsArr = [self allAccounts];
  if ([self isExistAccount:account] == NO) {
    NSMutableArray *mutableAccounts = accountsArr
    ? [NSMutableArray arrayWithArray:accountsArr] : [NSMutableArray array];
    
    [mutableAccounts addObject:account];
    [self _saveAccouts:mutableAccounts];
    if (self.currentActiveAccount == nil) {
      [self setCurrentAccountByUUID:account.userUUID];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kDOUAMAccountListDidChangeNotification object:nil];
    return YES;
  }
  else {
    return NO;
  }
}

- (BOOL)deleteAccount:(id <DOUBasicAccount> )account
{
  if ([account isValidAccount] == NO) {
    return NO;
  }
  
  if ([account isEqual:[self currentActiveAccount]]) {
    [self logoutCurrentAccount];
    return YES;
  }
  else {
    return [self _removeAccountInfo:account];
  }
}

- (BOOL)updateAccount:(id <DOUBasicAccount> )account
{
  if ([account isValidAccount] == NO) {
    return NO;
  }
  return [self _updateAccountInfoInAccountList:account];
}

- (NSArray *)allAccounts
{
  NSArray *accountArr = [self.accountManagerDicInfo objectForKey:kDOUAccountManagerInfoKeyAccounts];
  return accountArr ? accountArr : @[];
}

- (void)removeAllAccounts
{
  self.accountManagerDicInfo = nil;
  [self _persistAccoutInfoDic:nil];
  
  if (_currentAccount != nil) {
    _currentAccount = nil;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:kDOUCurrentAccountDidLogoutNotification object:nil];
    [center postNotificationName:kDOUAMAccountListDidChangeNotification object:nil];
  }
}

- (BOOL)isExistAccount:(id <DOUBasicAccount> )account
{
  return [self.allAccounts indexOfObject:account] != NSNotFound;
}

- (NSDictionary *)sharedAccounts
{
  return [self _filterUninstalledApplicationAccounts:[self _loadAccountsFromKeychain:YES]];
}

#pragma mark - Account related paths
- (NSString *)pathForAccount:(id <DOUBasicAccount> )account baseDir:(NSString *)basePath
{
  if (account == nil || account.userUUID == nil || [account.userUUID length] < 1) {
    NSLog(@"account info is invalid");
    return nil;
  }
  NSString *path = [basePath stringByAppendingPathComponent:account.userUUID];
  BOOL existed = [[NSFileManager defaultManager] fileExistsAtPath:path];
  if (existed == NO) {
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
  }
  return path;
}

- (NSString *)documentBaseDirForAccount:(id <DOUBasicAccount> )account
{
  return [self pathForAccount:account baseDir:self.appDocPath];
}

- (NSString *)tmpFileBaseDirForAccount:(id <DOUBasicAccount> )account
{
  return [self pathForAccount:account baseDir:self.appTmpPath];
}

#pragma mark - Account lagacy migration method
- (BOOL)migrateAccountLagacyDataWithBlock:(id <DOUBasicAccount> (^)(void))migrationBlock
{
  id <DOUBasicAccount> account = migrationBlock();
  if (account) {
    return [self addAccount:account];
  }
  else {
    return NO;
  }
}

- (BOOL)migrateMultipleAccountsOfLagacyDataWithBlock:(NSArray * (^)(NSString **currentAccountUUID))migrationBlock
{
  NSString *currentUUID = nil;
  NSArray *accountArr = migrationBlock(&currentUUID);
  if (accountArr && accountArr.count > 0) {
    if (currentUUID.length > 0) {
      [self _setCurrentAccountUUID:currentUUID];
    }
    return [self _saveAccouts:accountArr];
  }
  else {
    return NO;
  }
}

#pragma property method
- (NSMutableDictionary *)accountManagerDicInfo
{
  if (_accountManagerDicInfo == nil) {
    _accountManagerDicInfo = [self _fetchAccountManagerDicInfo];
  }
  return _accountManagerDicInfo;
}

#pragma mark - util methods
- (NSString *)appDocPath
{
  if (_appDocPath == nil) {
    _appDocPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _appDocPath = [_appDocPath stringByAppendingPathComponent:@"user_home"];
  }
  return _appDocPath;
}

- (NSString *)appTmpPath
{
  if (_appTmpPath == nil) {
    _appTmpPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
    _appTmpPath = [_appTmpPath stringByAppendingPathComponent:@"user_home"];
  }
  return _appTmpPath;
}

- (BOOL)_checkIfAccountManagerDicInfoValid:(id)dicInfo
{
  return [dicInfo isKindOfClass:[NSDictionary class]]
  && [dicInfo objectForKey:kDOUAccountManagerInfoKeyAccounts];
}

- (NSString *)_currentActiveAccountUUID
{
  NSString *currentUUID = [self.accountManagerDicInfo objectForKey:kDOUAccountManagerInfoKeyCurAccountUUID];
  return currentUUID;
}

- (void)_setCurrentAccountUUID:(NSString *)currentUUID
{
  if (currentUUID != nil || currentUUID.length > 0) {
    NSString *preUUID = [self.accountManagerDicInfo objectForKey:kDOUAccountManagerInfoKeyCurAccountUUID];
    if ([currentUUID isEqualToString:preUUID] == NO) {
      [self.accountManagerDicInfo setObject:currentUUID
                                     forKey:kDOUAccountManagerInfoKeyCurAccountUUID];
      [[NSNotificationCenter defaultCenter] postNotificationName:kDOUAMCurrentAccountDidChangeNotification
                                                          object:nil];
    }
  }
  else {
    [self.accountManagerDicInfo removeObjectForKey:kDOUAccountManagerInfoKeyCurAccountUUID];
  }
  [self _persistAccoutInfoDic:self.accountManagerDicInfo];
}

- (BOOL)_saveAccouts:(NSArray *)accounts
{
  if (accounts == nil) {
    [self _persistAccoutInfoDic:nil];
  }
  else {
    @try {
      for (id <DOUBasicAccount> account in accounts) {
        if ([account isValidAccount] == NO) {
          return NO;
        }
      }
    }
    @catch (NSException *exception)
    {
      return NO;
    }
    [self.accountManagerDicInfo setObject:[NSMutableArray arrayWithArray:accounts]
                                   forKey:kDOUAccountManagerInfoKeyAccounts];
    [self _persistAccoutInfoDic:self.accountManagerDicInfo];
  }
}

- (BOOL)_removeAccountInfo:(id <DOUBasicAccount> )account
{
  NSArray *accountsArr = [self allAccounts];
  if (accountsArr == nil || [[self allAccounts] indexOfObject:account] == NSNotFound) {
    return NO;
  }
  else {
    NSMutableArray *mutableAccounts = [NSMutableArray arrayWithArray:accountsArr];
    [mutableAccounts removeObject:account];
    [self _saveAccouts:mutableAccounts];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDOUAMAccountListDidChangeNotification
                                                        object:nil];
    return YES;
  }
}

- (NSMutableDictionary *)_fetchAccountManagerDicInfo
{
  NSMutableDictionary *mutableAccountInfoDic = [self _loadAccountsFromKeychain:NO];
  BOOL isValid = [self _checkIfAccountManagerDicInfoValid:mutableAccountInfoDic];
  if (!isValid) {
    [self _saveAccountsToKeychain:nil shared:NO];
  }
  return mutableAccountInfoDic;
}

- (void)_persistAccoutInfoDic:(NSMutableDictionary *)infoDict
{
  [self _saveAccountsToKeychain:infoDict shared:NO];

  [self _saveSharedAccountFromInfoDict:infoDict];
}

- (void)_saveSharedAccountFromInfoDict:(NSDictionary *)infoDict
{
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
  NSBundle *appBundle = [NSBundle bundleForClass:[self class]];
  [userInfo setObject:[appBundle bundleIdentifier]
               forKey:kDOUSharedAccountUserInfoKeyAppID];
  [userInfo setObject:NSLocalizedString([appBundle infoDictionary][@"CFBundleDisplayName"], nil)
               forKey:kDOUSharedAccountUserInfoKeyAppName];
  NSString *urlScheme = [self _AppURLScheme];
  if (urlScheme) {
    [userInfo setObject:urlScheme forKey:kDOUSharedAccountUserInfoKeyAppURLScheme];
  }

  NSMutableArray *sharedAccounts = [NSMutableArray array];
  for (id<DOUBasicAccount> account in [infoDict objectForKey:kDOUAccountManagerInfoKeyAccounts]) {
    if ([account isValidAccount]
        && [account conformsToProtocol:@protocol(DOUSharedAccount)]) {
      DOUCommonAccount *sa = [(id<DOUSharedAccount>)account sharedAccount];
      if (sa == nil) {
        continue;
      }

      if ([sa class] != [DOUCommonAccount class]) {
        NSLog(@"[DOUUserManager] WARNING: -[DOUSharedAccount sharedAccount] should return `DOUCommonAccount` instance.");
        continue;
      }

      if (sa.oAuthToken == nil || sa.userName == nil) {
        NSLog(@"[DOUUserManager] WARNING: `userName` and `oAuthToken` of shared account should not be nil.");
        continue;
      }

      if (sa.userInfo) {
        NSLog(@"[DOUUserManager] WARNING: `userInfo` property of shared account will be overwirted.");
      }

      sa.userInfo = userInfo;
      [sharedAccounts addObject:sa];
    }
  }

  NSMutableDictionary *accountsOfAllApps = [self _loadAccountsFromKeychain:YES];
  NSString *appId = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
  [accountsOfAllApps removeObjectForKey:appId];
  accountsOfAllApps = [self _filterUninstalledApplicationAccounts:accountsOfAllApps];
  if ([sharedAccounts count] > 0) {
    [accountsOfAllApps setObject:sharedAccounts forKey:appId];
  }
  [self _saveAccountsToKeychain:accountsOfAllApps shared:YES];
}

- (BOOL)_updateAccountInfoInAccountList:(id <DOUBasicAccount> )account
{
  NSArray *accountsArr = [self allAccounts];
  NSUInteger index = [accountsArr indexOfObject:account];
  if (accountsArr == nil || index == NSNotFound) {
    return NO;
  }
  else {
    if ([_currentAccount isEqual:account]) {
      _currentAccount = account;
    }
    NSMutableArray *mutableAccounts = [NSMutableArray arrayWithArray:accountsArr];
    [mutableAccounts replaceObjectAtIndex:index withObject:account];
    [self _saveAccouts:mutableAccounts];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDOUAMAccountListDidChangeNotification
                                                        object:nil];
    return YES;
  }
}

- (id <DOUBasicAccount> )_accountByUUID:(NSString *)accountUUID
{
  NSArray *accountArr = [self allAccounts];
  for (id <DOUBasicAccount> accout in accountArr) {
    if ([accout.userUUID isEqualToString:accountUUID]) {
      return accout;
    }
  }
  return nil;
}

- (NSString *) _getBundleSeedID {
  NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                         (__bridge id)(kSecClassGenericPassword), kSecClass,
                         @"bundleSeedID", kSecAttrAccount,
                         @"", kSecAttrService,
                         (id)kCFBooleanTrue, kSecReturnAttributes,
                         nil];
  CFDictionaryRef result = nil;
  OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
  if (status == errSecItemNotFound)
    status = SecItemAdd((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
  if (status != errSecSuccess)
    return nil;
  NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge id)(kSecAttrAccessGroup)];
  NSArray *components = [accessGroup componentsSeparatedByString:@"."];
  NSString *bundleSeedID = [[components objectEnumerator] nextObject];
  CFRelease(result);
  return bundleSeedID;
}

- (NSMutableDictionary *)_loadAccountsFromKeychain:(BOOL)shared
{
  SSKeychainQuery *query = [self _keychainQueryForShared:shared];

  NSError *error = nil;
  if (![query fetch:&error]) {
    NSLog(@"Failed to query accounts data from keychain, shared: %d error: %@", shared, error);
    return [NSMutableDictionary dictionary];
  }

  NSData *accountsDataOfAllApps = query.passwordData;
  NSMutableDictionary *accounts = nil;
  @try {
    accounts = [NSKeyedUnarchiver unarchiveObjectWithData:accountsDataOfAllApps];
  }
  @catch (NSException *exception) {
    [self _saveAccountsToKeychain:nil shared:shared];
  }
  return accounts ?: [NSMutableDictionary dictionary];
}

- (void)_saveAccountsToKeychain:(NSMutableDictionary *)accounts shared:(BOOL)shared
{
  SSKeychainQuery *query = [self _keychainQueryForShared:shared];

  NSError *error = nil;
  if (accounts == nil) {
    [query deleteItem:&error];
  } else {
    if (![accounts isKindOfClass:[NSMutableDictionary class]]) {
      accounts = [accounts mutableCopy];
    }
    query.passwordData = [NSKeyedArchiver archivedDataWithRootObject:accounts];
    [query save:&error];
  }

  if (error) {
    NSLog(@"Failed to save accounts data to keychain, shared: %d error: %@", shared, error);
  }
}

- (SSKeychainQuery *)_keychainQueryForShared:(BOOL)shared
{
  SSKeychainQuery *query = [[SSKeychainQuery alloc] init];
  query.account = kDOUAccountManagerInfoKey;
  if (shared) {
    query.service = @"com.douban.DOUUserManager";
    query.accessGroup = [NSString stringWithFormat:@"%@.%@",
                         [self _getBundleSeedID],
                         kDOUAccountManagerSharedAccountAccessGroup];
  } else {
    query.service = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
  }
  return query;
}

- (void)_moveAccountDataFromUserDefaultsToKeychain
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSData *accountInfoData = [defaults objectForKey:kDOUAccountManagerInfoKey];
  if (accountInfoData) {
    @try {
      [self _persistAccoutInfoDic:[NSKeyedUnarchiver unarchiveObjectWithData:accountInfoData]];
    }
    @catch (NSException *exception) {
    }
    [defaults removeObjectForKey:kDOUAccountManagerInfoKey];
    [defaults synchronize];
  }
}

- (NSString *)_AppURLScheme
{
  NSString *URLScheme = nil;

  NSArray *urlTypes = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
  for (NSDictionary *item in urlTypes) {
    if ([[item objectForKey:@"CFBundleURLName"] isEqualToString:@"DOUAccountManager"]) {
      URLScheme = [[item objectForKey:@"CFBundleURLSchemes"] firstObject];
      break;
    }
  }

  return URLScheme;
}

- (NSMutableDictionary *)_filterUninstalledApplicationAccounts:(NSMutableDictionary *)accountsOfAllApps
{
  NSMutableDictionary *sharedAccounts = [NSMutableDictionary dictionary];
  [accountsOfAllApps enumerateKeysAndObjectsUsingBlock:^(NSString *appId, NSArray *accounts, BOOL *stop) {
    NSString *urlScheme = [[[accounts firstObject] userInfo] objectForKey:kDOUSharedAccountUserInfoKeyAppURLScheme];
    NSURL *url = urlScheme ? [[NSURL alloc] initWithScheme:urlScheme host:@"" path:@"/"] : nil;
    if (url == nil || [[UIApplication sharedApplication] canOpenURL:url]) {
      [sharedAccounts setObject:accounts forKey:appId];
    }
  }];
  return sharedAccounts;
}

#pragma mark -  singleton methods
+ (id)sharedInstance
{
  static dispatch_once_t onceToken = 0L;
  dispatch_once(&onceToken, ^{
    instance = [[super allocWithZone:NULL] init];
  });
  return instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
  return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

@end
