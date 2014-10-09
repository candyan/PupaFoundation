//
//  MobileStat.m
//  amonDemo
//
//  Created by tan fish on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DOUMobileStat.h"
#import "DOUMobileStatImp.h"
#import "DOUMobileStatImp+Event.h"
#import "DOUStatConstant.h"
#import "NSString+DOUStat.h"
#import "NSString+DOUDigest.h"

NSString *const kDOUInfoPlistChannelPublishKey = @"DOUPublishChannel";

@implementation DOUMobileStat

#pragma mark - Start with App Key

+ (void)startWithAppkey:(NSString *)appKey
                appName:(NSString *)appName
                userUID:(NSNumber *)userUID
              channelId:(NSString *)cid
{
  NSParameterAssert(userUID == nil || [userUID isKindOfClass:[NSNumber class]]);
  @try {
    [[DOUMobileStatImp sharedInstance] startWithAppkey:appKey
                                               appName:appName
                                               userUID:userUID
                                             channelId:cid];
  } @catch (NSException *exception) {
    DERRORLOG(@"ex: %@", exception);
    
    NSAssert(NO, @"exception happends");
  }
}

+ (void)startWithAppkey:(NSString *)appKey
                appName:(NSString *)appName
                userUID:(NSNumber *)userUID
{
  NSString *channelName = [[[NSBundle mainBundle] infoDictionary] objectForKey:kDOUInfoPlistChannelPublishKey];
  if (channelName == nil
      || [channelName isKindOfClass:[NSString class]] == NO
      || channelName.length == 0) {
    channelName = kAppDefaultChannel;
  }
  [self startWithAppkey:appKey
                appName:appName
                 userUID:userUID
              channelId:channelName];
}

#pragma mark - User related methods
+ (void)bindUserUID:(NSNumber *)uuid token:(NSString *)token
{
  NSParameterAssert(uuid == nil || [uuid isKindOfClass:[NSNumber class]]);
  @try {
    [[DOUMobileStatImp sharedInstance] setUserUID:uuid];
    [[DOUMobileStatImp sharedInstance] setMd5Token:[token md5]];
  } @catch (NSException *exception) {
    DERRORLOG(@"ex: %@", exception);
    
    NSAssert(NO, @"exception happends");
  }
}

/*
 *  取消绑定用户
 */
+ (void)unBindUser
{
  @try {
    [[DOUMobileStatImp sharedInstance] setUserUID:nil];
    [[DOUMobileStatImp sharedInstance] setMd5Token:nil];
  } @catch (NSException *exception) {
    DERRORLOG(@"ex: %@", exception);
    
    NSAssert(NO, @"exception happends");
  }
}

+ (void)setLocation:(CLLocation *)location
{
  [[DOUMobileStatImp sharedInstance] setCurrentLocation:location];
}

#pragma mark - Event reporting related methods
//
// 统计页面事件
// eventid 事件名
//
+ (void)event:(NSString *)eventId
{
  [DOUMobileStat event:eventId label:nil acc:1];
}

//
// 统计页面事件
// eventid 事件名  label 标识
//
+ (void)event:(NSString *)eventId label:(NSString *)label
{
  [DOUMobileStat event:eventId label:label acc:1];
}

//
// 统计页面事件
// eventid 事件名   acc  次数
//
+ (void)event:(NSString *)eventId acc:(NSInteger)accumulation
{
  [DOUMobileStat event:eventId label:nil acc:accumulation];
}

//
// 统计页面事件
// eventid 事件名  label 标识   acc  次数
//
+ (void)event:(NSString *)eventId label:(NSString *)label acc:(NSInteger)accumulation
{
  @try {
    DOUMobileStatImp *stat = [DOUMobileStatImp sharedInstance];
    [stat event:eventId label:label acc:accumulation];
  } @catch (NSException *exception) {
    DERRORLOG(@"ex: %@", exception);
    
    NSAssert(NO, @"exception happends");
  }
}

//
// 对于时长事件的 启动事件
//

+ (void)beginEvent:(NSString *)eventId
{
  [DOUMobileStat beginEvent:eventId label:nil];
}

//
// 对于时长事件的 结束事件  eventId 必须和 启动事件中的参数一致
//

+ (void)endEvent:(NSString *)eventId
{
  [DOUMobileStat endEvent:eventId label:nil];
}

//
// 对于时长事件的 启动事件  带label
//
+ (void)beginEvent:(NSString *)eventId label:(NSString *)label
{
  @try {
    DOUMobileStatImp *stat = [DOUMobileStatImp sharedInstance];
    [stat beginEvent:eventId label:label];
  } @catch (NSException *exception) {
    DERRORLOG(@"ex: %@", exception);
    
    NSAssert(NO, @"exception happends");
  }
}

//
// 对于时长事件的 结束事件  eventId 必须和 启动事件中的参数一致  带label
//
+ (void)endEvent:(NSString *)eventId label:(NSString *)label
{
  @try {
    DOUMobileStatImp *stat = [DOUMobileStatImp sharedInstance];
    [stat endEvent:eventId label:label];
  } @catch (NSException *exception) {
    DERRORLOG(@"ex: %@", exception);
    
    NSAssert(NO, @"exception happends");
  }
}

@end
