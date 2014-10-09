//
//  MobileStat.h
//  amonDemo
//
//  Created by tan fish on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString *const kDOUInfoPlistChannelPublishKey;

@interface DOUMobileStat : NSObject

+ (void)startWithAppkey:(NSString *)appKey
                appName:(NSString *)appName
                userUID:(NSNumber *)userUID;

+ (void)bindUserUID:(NSNumber *)uuid token:(NSString *)token;
+ (void)unBindUser;
+ (void)setLocation:(CLLocation *)location;

/*
 * eventId : Event id
 * label : Event's label, can be nil
 * accumulation : count of the event
 */
+ (void)event:(NSString *)eventId label:(NSString *)label acc:(NSInteger)accumulation;
+ (void)event:(NSString *)eventId acc:(NSInteger)accumulation;
+ (void)event:(NSString *)eventId label:(NSString *)label;
+ (void)event:(NSString *)eventId;

+ (void)beginEvent:(NSString *)eventId;
+ (void)endEvent:(NSString *)eventId;

+ (void)beginEvent:(NSString *)eventId label:(NSString *)label;
+ (void)endEvent:(NSString *)eventId label:(NSString *)label;

@end
