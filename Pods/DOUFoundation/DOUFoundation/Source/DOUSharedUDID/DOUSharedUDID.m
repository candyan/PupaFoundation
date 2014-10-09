//
//  DOUSharedUDID.m
//  DOUFoundation
//
//  Created by Candyan on 7/21/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "DOUSharedUDID.h"

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>

static NSString *const kDOUSharedUDIDKeychainAccessGroup = @"com.douban.DOUSharedUDID";

static NSString *const kDOUSharedUDIDKey = @"DOUSharedUDID";

static NSString *const kDOUSharedUDIDForApps = @"com.douban.apps.DOUSharedUDID";

@implementation DOUSharedUDID

#pragma mark - Share UDID for each App
+ (NSString *)sharedUDID
{
  static NSString *sharedUDIDForApp = nil;
  
  if (sharedUDIDForApp) {
    return sharedUDIDForApp;
  }
  static NSLock *gKeychainLock = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gKeychainLock = [[NSLock alloc] init];
  });
  
  [gKeychainLock lock];
  if (sharedUDIDForApp == nil) {
    sharedUDIDForApp = [self _sharedUDIDFromKeychain];
  }
  if (sharedUDIDForApp == nil) {
    sharedUDIDForApp = [self _generateFreshDOUSharedUDID];
    NSString *keychainAccessGroup = [self _sharedKeychainAccessGroup];
    [self _storeDOUSharedUDID:sharedUDIDForApp toKeychainAccessGroup:keychainAccessGroup];
  }
  [gKeychainLock unlock];
  
  return sharedUDIDForApp;
}

+ (NSString *)_sharedUDIDFromKeychain
{
  NSMutableDictionary *query = [self _commonQueryDictionary];
  [query setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
  [query setObject:[self _appBundleID] forKey:(__bridge id<NSCopying>)(kSecAttrService)];
  [query setObject:kDOUSharedUDIDKey forKey:(__bridge id<NSCopying>)(kSecAttrAccount)];
  CFTypeRef dataTypeRef = NULL;
  OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query,
                                        (CFTypeRef *)&dataTypeRef);
  NSString *udid = nil;
  if (status == 0) {
    udid = [[NSString alloc] initWithData:(__bridge NSData *)(dataTypeRef)
                                 encoding:NSUTF8StringEncoding];
    CFRelease(dataTypeRef);
  }
  return udid;
}

+ (void)_storeDOUSharedUDID:(NSString *)sharedUDID toKeychainAccessGroup:(NSString *)accessGroup
{
  NSMutableDictionary *spec = [self _commonQueryDictionary];
  [spec setObject:kDOUSharedUDIDKey forKey:(__bridge id)kSecAttrAccount];
  [spec setObject:[self _appBundleID] forKey:(__bridge id)kSecAttrService];
  NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:spec];
  [data setObject:[sharedUDID dataUsingEncoding:NSUTF8StringEncoding]
           forKey:(__bridge id)kSecValueData];
  OSStatus status = SecItemAdd((__bridge CFDictionaryRef)data, NULL);
  NSAssert(status == errSecSuccess, @"failed to store douban shared udid to keychain");
}

#pragma mark - Share UDID for Apps with same bundle seed ID
+ (NSString *)sharedUDIDForDoubanApplications
{
  static NSString *sharedUDIDForDoubanApps = nil;
  if (sharedUDIDForDoubanApps) {
    return sharedUDIDForDoubanApps;
  }
  static NSLock *gKeychainLock = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gKeychainLock = [[NSLock alloc] init];
  });
  
  [gKeychainLock lock];
  if (!sharedUDIDForDoubanApps) {
    sharedUDIDForDoubanApps = [self _sharedUDIDForAppsFromKeychain];
  }
  if (!sharedUDIDForDoubanApps) {
    sharedUDIDForDoubanApps = [self _generateFreshDOUSharedUDID];
    [self _saveSharedUDIDForAppsToKeychain:sharedUDIDForDoubanApps];
  }
  [gKeychainLock unlock];
  
  return sharedUDIDForDoubanApps;
}

+ (BOOL)_saveSharedUDIDForAppsToKeychain:(NSString *)sharedUDID
{
  NSMutableDictionary *query = [self _commonQueryDictionary];
  [query setObject:kDOUSharedUDIDForApps forKey:(__bridge id)kSecAttrAccount];
  
  NSData *stringData = [sharedUDID dataUsingEncoding:NSUTF8StringEncoding];
  [query setObject:stringData forKey:(__bridge id)(kSecValueData)];
  OSStatus status = SecItemAdd((__bridge CFDictionaryRef)(query), NULL);
  NSAssert(status == errSecSuccess, @"failed to store douban shared udid to keychain");
  return status == errSecSuccess;
}

+ (NSString *)_sharedUDIDForAppsFromKeychain
{
  NSMutableDictionary *query = [self _commonQueryDictionary];
  [query setObject:kDOUSharedUDIDForApps forKey:(__bridge id<NSCopying>)(kSecAttrAccount)];
  [query setObject:(id)kCFBooleanTrue forKey:(__bridge id<NSCopying>)(kSecReturnData)];
  CFDataRef stringData = NULL;
  OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&stringData);
  if (status) {
    return nil;
  }
  NSString *string = [[NSString alloc] initWithData:(__bridge id)stringData encoding:NSUTF8StringEncoding];
  CFRelease(stringData);
  return string;
}

#pragma mark - identifierForVendor

+ (NSString *)identifierForVendor
{
  UIDevice *currentDevice = [UIDevice currentDevice];
  if ([currentDevice respondsToSelector:@selector(identifierForVendor)]) {
    return [[currentDevice identifierForVendor] UUIDString];
  }
  return nil;
}

#pragma mark - util methods

+ (NSMutableDictionary *)_commonQueryDictionary
{
  NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                (__bridge id)kSecClassGenericPassword, kSecClass,
                                nil];
#if TARGET_IPHONE_SIMULATOR
#else
  [query setObject:[DOUSharedUDID _sharedKeychainAccessGroup]
            forKey:(__bridge id)kSecAttrAccessGroup];
#endif
  [query setObject:@"group" forKey:(__bridge id)kSecAttrType];
  return query;
}

+ (NSString *)_sharedKeychainAccessGroup
{
  // KeyChain Access Group look like BundlePrefixID.com.company.xxxx.
  // But in Entitlements, $(AppIdentifierPrefix) is include '.'.
  // So AccessGroup look like $(AppIdentifierPrefix)com.company.xxxx in Entitlements.
  // If you don't want to use $(AppIdentifierPrefix), you can use BundlePrefixID.com.company.xxxx also.
  return [NSString stringWithFormat:@"%@.%@", [self _getBundleSeedID], kDOUSharedUDIDKeychainAccessGroup];
}

+ (NSString *)_appBundleID
{
  return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)_getBundleSeedID
{
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
  NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey : (__bridge id)(kSecAttrAccessGroup)];
  NSArray *components = [accessGroup componentsSeparatedByString:@"."];
  NSString *bundleSeedID = [[components objectEnumerator] nextObject];
  CFRelease(result);
  return bundleSeedID;
}

#pragma mark - Genrate UDID

+ (NSString *)_generateFreshDOUSharedUDID
{
  NSString *_openUDID = nil;
  
  // August 2011: One day, this may no longer be allowed in iOS. When that is, just comment this line out.
  // March 25th 2012: this day has come, let's remove this "outlawed" call...
#if TARGET_OS_IPHONE
  //    if([UIDevice instancesRespondToSelector:@selector(uniqueIdentifier)]){
  //        _openUDID = [[UIDevice currentDevice] uniqueIdentifier];
  //    }
#endif
  // Next we generate a UUID.
  // UUIDs (Universally Unique Identifiers), also known as GUIDs (Globally Unique Identifiers) or IIDs
  // (Interface Identifiers), are 128-bit values guaranteed to be unique. A UUID is made unique over
  // both space and time by combining a value unique to the computer on which it was generated—usually the
  // Ethernet hardware address—and a value representing the number of 100-nanosecond intervals since
  // October 15, 1582 at 00:00:00.
  // We then hash this UUID with md5 to get 32 bytes, and then add 4 extra random bytes
  // Collision is possible of course, but unlikely and suitable for most industry needs (e.g. aggregate tracking)
  //
  if (_openUDID == nil) {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    const char *cStr = CFStringGetCStringPtr(cfstring, CFStringGetFastestEncoding(cfstring));
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    CFRelease(cfstring);
    cStr = NULL;
    CFRelease(uuid);
    
    _openUDID = [NSString stringWithFormat:
                 @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08x",
                 result[0], result[1], result[2], result[3],
                 result[4], result[5], result[6], result[7],
                 result[8], result[9], result[10], result[11],
                 result[12], result[13], result[14], result[15],
                 (NSUInteger)(arc4random() % NSUIntegerMax)];
  }
  
  // Call to other developers in the Open Source community:
  //
  // feel free to suggest better or alternative "UDID" generation code above.
  // NOTE that the goal is NOT to find a better hash method, but rather, find a decentralized (i.e. not web-based)
  // 160 bits / 20 bytes random string generator with the fewest possible collisions.
  //
  
  return _openUDID;
}

@end
