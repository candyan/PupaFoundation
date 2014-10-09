//
//  DOUPushRegisterClient.m
//  DoubanObjCClient
//
//  Created by liuyan on 14-1-8.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import "DOUPushRegisterClient.h"
#import "DOUAPIClient+Private.h"
#import "DOUAppDescription.h"
#import "DOUError.h"

@implementation DOUPushRegisterClient

#pragma mark - Instance

+ (DOUPushRegisterClient *)sharedClient
{
  static DOUPushRegisterClient *gSharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gSharedClient = [[DOUPushRegisterClient alloc] initWithBaseURL:kDoubanArteryBaseURL];
  });
  return gSharedClient;
}

#pragma mark - API

- (void)apnsRegisterDevice:(NSData *)deviceToken
                    userID:(NSString *)userID
                   success:(DOUAPIRequestSuccessBlock)success
                   failure:(DOUAPIRequestFailErrorBlock)failureBlock
{
  NSAssert(deviceToken != nil, @"Device Token should not be nil.");

  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

  NSString *deviceTokenStr = [self _vaildDeviceTokenStringWithTokenData:deviceToken];

  [parameters setObject:deviceTokenStr forKey:@"device_token"];
  [parameters setObject:[DOUAppDescription currentAppDescription].appKey forKey:@"appkey"];

  if (userID) [parameters setObject:userID forKey:@"user_id"];

  NSString *appVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleVersion"];
  [parameters setObject:appVersion forKey:@"app_version"];

  NSString *ck = [[NSString stringWithFormat:@"%@%@", deviceTokenStr, @"^d%_ban.i_os#!*)!@!@+$"] sha1];
  [parameters setObject:ck forKey:@"ck"];

  [self postPath:@"register_ios_apns"
      parameters:parameters
  successRequest:^(NSString *resultStr, DOUAPIRequestOperation *requstOperation)
   {
     if (success) success();
   } failure:failureBlock];
}

- (NSString *)_vaildDeviceTokenStringWithTokenData:(NSData *)data
{
  NSString *tokenString = [NSString stringWithFormat:@"%@", data];
  NSString *vaildTokenString = [tokenString substringWithRange:NSMakeRange(1, [tokenString length] - 2)];
  NSArray *words = [vaildTokenString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  return [words componentsJoinedByString:@""];
}

@end
