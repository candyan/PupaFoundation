//
//  DeviceInfo.h
//  amonsul
//
//  Created by tan fish on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DOUSharedUDID.h"
#import <CoreTelephony/CTTelephonyNetWorkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreGraphics/CoreGraphics.h>


@interface DOUDeviceInfo : NSObject


+ (NSString *)getDEviceOSPlatform;   //平台 OS

+ (NSString *)getDeviceOS;   // 设备操作系统

+ (NSString *)getCountry;   // 国家设置

+ (NSString *)getLanguage;  // 语言设置

+ (NSString *)getDeviceModel; // 设备名字

+ (NSString *)getOSVersion;  // 操作系统版本

+ (NSString *)getIdentityForVender;

+ (NSString *)getTimeZone;  //时区设置

+ (NSString *)getCarrier; //运营商

+ (NSString *)getResolution;  // 分辨率

+ (NSDictionary *)infoDic;

@end
