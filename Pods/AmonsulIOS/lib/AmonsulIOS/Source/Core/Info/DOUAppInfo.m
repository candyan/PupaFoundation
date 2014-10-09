//
//  AppInfo.m
//  amonsul
//
//  Created by tan fish on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DOUAppInfo.h"
#import "DOUStatConstant.h"

static DOUAmonsulNetworkStatus __curNetworkStatus = DOUAmonsulNotReachable;

@implementation DOUAppInfo

+ (void)setCurrentNetworkStatus:(DOUAmonsulNetworkStatus)networkStatus
{
  __curNetworkStatus = networkStatus;
}

//
// App 的名字
//
+ (NSString *)getAppDisplayName
{
  NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
  if (infoDictionary != nil) {
    return [infoDictionary objectForKey:@"CFBundleDisplayName"];
  }
  return @"";
}

//
// App 的版本
//
+ (NSString *)getAppVersion
{
  NSString *ret = nil;
  NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
  if (infoDictionary != nil) {
    ret = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
  }
  return ret;
}

//
// 应用程序的 Iderntifier
//
+ (NSString *)getPackageName
{
  NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
  if (infoDictionary != nil) {
    return [infoDictionary objectForKey:@"CFBundleIdentifier"];
  }
  return @"";
}

//
// 当前的联网方式
//
+ (NSString *)getNet
{
  if (__curNetworkStatus == DOUAmonsulReachableViaWiFi) {
    return kAppNetworkWifi;
  } else if (__curNetworkStatus == DOUAmonsulReachableViaWWAN) {
    return kAppNetwork3G;
  }
  return kAppNetworkUnKnown;
}

//
// SDK的版本
//
+ (NSString *)getSDkVersion
{
  return DOU_STAT_SDK_VERSION;
}

//
// AppInfo 的 Dictionary
//
+ (NSMutableDictionary *)toMutableDic
{
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  //    [dic setValue:[DOUAppInfo getPackageName] forKey:kJSON_KEY_PACKAGE]; // app package
  [dic setValue:[DOUAppInfo getNet] forKey:kJSON_KEY_NET]; // app net
  [dic setValue:[DOUAppInfo getAppVersion] forKey:kJSON_KEY_VERSIONCODE];  // app version
  [dic setValue:[DOUAppInfo getAppDisplayName] forKey:kJSON_KEY_APPNAME]; // app name
  [dic setValue:[DOUAppInfo getSDkVersion] forKey:kJSON_KEY_SDKVERSION]; // sdk version
  
  return dic;
}

@end
