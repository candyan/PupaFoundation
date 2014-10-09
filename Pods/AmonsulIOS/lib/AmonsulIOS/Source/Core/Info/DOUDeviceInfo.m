//
//  DeviceInfo.m
//  amonsul
//
//  Created by tan fish on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DOUDeviceInfo.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "NSDictionary+DOUJSON.h"
#import "DOUStatConstant.h"

@implementation DOUDeviceInfo

+ (NSString *)getSysInfoByName:(char *)typeSpecifier
{
  size_t size;
  sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
  
  char *answer = malloc(size);
  sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
  
  NSString *results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
  
  free(answer);
  return results;
}

//
// 获得 平台  iPhone iPad  iPod  3G 4G 5
//
+ (NSString *)getDEviceOSPlatform
{
  // 直接用 UIDevice 获得的 platform 不进行识别
  return [self getSysInfoByName:"hw.machine"];
}

//
// 获得平台 固定Os
//
+ (NSString *)getDeviceOS
{
  return kDevicePlatform;
}

//
// 获得当前设置国家
//
+ (NSString *)getCountry
{
  NSString *country = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
  NSString *ret = [NSString stringWithString:country ? country:@"unknown"];
  return ret;
}

//
// 获得当前设置语言
//
+ (NSString *)getLanguage
{
  NSString *ret = [NSString stringWithString:[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]];
  return ret;
}

//
// 手机运营商
//
+ (NSString *)getCarrier
{
  CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc]init];
  
  CTCarrier *carrier = [netInfo subscriberCellularProvider];
  
  NSString *cellularProviderName = [carrier carrierName];
  
  if (cellularProviderName == nil) {
    return @"";
  }
  
  return cellularProviderName;
}

//
// 获得设备
//

+ (NSString *)getDeviceModel
{
  return [[UIDevice currentDevice] model];
}

//
// 获得OS 版本号
//

+ (NSString *)getOSVersion
{
  return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)getIdentityForVender
{
  if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
  }
  return nil;
}

//
// 系统时区设置
//
+ (NSString *)getTimeZone
{
  return [[NSTimeZone systemTimeZone] name];
}

//
// 分辨率
//
+ (NSString *)getResolution
{
  CGRect rect_screen = [[UIScreen mainScreen] bounds];
  CGSize size_screen = rect_screen.size;
  CGFloat scale_screen = [UIScreen mainScreen].scale;
  int w = (int)size_screen.width * scale_screen;
  int h = (int)size_screen.height * scale_screen;
  
  return [NSString stringWithFormat:@"%d x %d", w, h];
}

+ (NSDictionary *)infoDic
{
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  [dic setValue:[self getCountry] forKey:kJSON_KEY_COUNTRY];
  [dic setValue:[self getCarrier] forKey:kJSON_KEY_CARRIER]; // app carrier
  [dic setValue:[self getResolution] forKey:kJSON_KEY_RESOLUTION];
  [dic setValue:[self getTimeZone] forKey:kJSON_KEY_TIMEZONE];
  [dic setValue:[self getLanguage] forKey:kJSON_KEY_LANGUAGE];
  [dic setValue:[self getDeviceOS] forKey:kJSON_KEY_OS];
  [dic setValue:[self getDEviceOSPlatform] forKey:kJSON_KEY_DEVICE];
  [dic setValue:[self getOSVersion] forKey:kJSON_KEY_OSVERSION];
  [dic setValue:[DOUSharedUDID sharedUDIDForDoubanApplications] forKey:kJSON_KEY_DEVICEID];
  [dic setValue:[DOUSharedUDID sharedUDID] forKey:kJSON_KEY_UDID_FOR_APP];
  
  NSString *identifyForVender = [DOUDeviceInfo getIdentityForVender];
  if (identifyForVender) {
    [dic setValue:identifyForVender forKey:kJSON_KEY_IDENTIFY_FOR_VENDOR];
  }
  return dic;
}

@end
