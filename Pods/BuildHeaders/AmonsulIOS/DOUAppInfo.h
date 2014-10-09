//
//  AppInfo.h
//  amonsul
//
//  Created by tan fish on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "DouReachability.h"


@interface DOUAppInfo : NSObject

+ (void)setCurrentNetworkStatus:(DOUAmonsulNetworkStatus)networkStatus;

+ (NSString *)getAppDisplayName;   // 程序名

+ (NSString *)getAppVersion;  // 应用版本

+ (NSString *)getPackageName;  //包名

+ (NSString *)getNet;  // 联网方式

+ (NSString *)getSDkVersion;  // 对应Amonsul sdk 版本

+ (NSMutableDictionary *)toMutableDic;

@end
