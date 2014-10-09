//
//  OAuthManager.m
//  DoubanObjCClient
//
//  Created by Candyan on 1/19/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "DOUOAuthManager.h"
#import "DOUOAuth.h"

static DOUOAuthManager *managerInstance = nil;

@implementation DOUOAuthManager

@synthesize currentOAuth = _currentOAuth;

+(DOUOAuthManager *)sharedInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    managerInstance = [[DOUOAuthManager alloc] init];
  });
  return managerInstance;
}

- (DOUOAuth *)currentOAuth
{
  return _currentOAuth;
}

- (void)setCurrentOAuth:(DOUOAuth *)currentOAuth
{
  _currentOAuth = currentOAuth;
}

#pragma mark - 
- (void)removeAllMigratedOAuths
{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults removeObjectForKey:@"user.default.currentOAuthUserID"];
  [userDefaults removeObjectForKey:@"user.default.multOAuthDict"];
  [userDefaults synchronize];
}

- (NSArray *)oauthArrayForMigration
{
  NSDictionary *allOAuthDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"user.default.multOAuthDict"];
  NSMutableArray *allOAuthArray = [NSMutableArray array];
  for (NSDictionary *dictionary in [allOAuthDictionary allValues]) {
    [allOAuthArray addObject:[DOUOAuth objectWithDictionary:dictionary]];
  }
  return allOAuthArray;
}


@end
