//
//  DOUEventLogger.h
//  AmonsulIOS
//
//  Created by liu yan on 4/15/13.
//  Copyright (c) 2013 Douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUMobileStat.h"

typedef enum {
  kDOUStatStrategyDefault = 0,
  kDOUStatStrategyRealTime = 1,
  kDOUStatStrategyLaunchAndWifi = 2
} DOUStatStrategy;

@interface DOUEventLogger : NSObject

+ (void)startWithAppKey:(NSString *)appKey
                appName:(NSString *)appName
                userUID:(NSNumber *)userUID
            umengAppKey:(NSString *)umengAppKey
   umengAppStoreChannel:(NSString *)channelName
           reportPolicy:(DOUStatStrategy)strategy;

+ (void)startWithAppKey:(NSString *)appKey
                appName:(NSString *)appName
                userUID:(NSNumber *)userUID
            umengAppKey:(NSString *)umengAppKey
           GATrackingId:(NSString *)trackingId
                channel:(NSString *)channelName
           reportPolicy:(DOUStatStrategy)strategy;

+ (void)setUserUID:(NSNumber *)userUID token:(NSString *)token;
+ (void)unbindUser;

+ (void)setLocation:(CLLocation *)location;

+ (void)event:(NSString *)eventId;
+ (void)event:(NSString *)eventId label:(NSString *)label;
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributesDic;

+ (void)beginEvent:(NSString *)eventName;
+ (void)endEvent:(NSString *)eventName;

+ (void)beginEvent:(NSString *)eventName label:(NSString *)label;
+ (void)endEvent:(NSString *)eventName label:(NSString *)label;

+ (void)beginEvent:(NSString *)eventName attributes:(NSDictionary *)attributesDic;
+ (void)endEvent:(NSString *)eventName attributes:(NSDictionary *)attributesDic;

@end
