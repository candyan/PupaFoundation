//
//  DOUEventLogger.m
//  AmonsulIOS
//
//  Created by Candyan on 4/15/13.
//  Copyright (c) 2013 Douban. All rights reserved.
//

#import "DOUEventLogger.h"
#import "MobClick.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "NSDictionary+DOUJSON.h"

typedef NS_OPTIONS(NSUInteger, DOUThirdPartyTrackingService) {
  kDOUThirdPartyTrackingServicesNone           = 0,
  kDOUThirdPartyTrackingServiceUmeng           = 1 << 0,
  kDOUThirdPartyTrackingServiceGoogleAnalytics = 1 << 1
};

static DOUThirdPartyTrackingService gTrackingServices = kDOUThirdPartyTrackingServicesNone;

static NSString * const kGACategoryDefault  = @"default";

static NSString * const kGAParameterKeyUserUID = @"userid";

NS_INLINE NSMutableDictionary *ga_timing_dict()
{
  static NSMutableDictionary *sTimingDictionary = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sTimingDictionary = [NSMutableDictionary dictionary];
  });
  return sTimingDictionary;
}

@implementation DOUEventLogger

+ (void)startWithAppKey:(NSString *)appKey
                appName:(NSString *)appName
                userUID:(NSNumber *)userUID
            umengAppKey:(NSString *)umengAppKey
   umengAppStoreChannel:(NSString *)channelName
           reportPolicy:(DOUStatStrategy)strategy
{
  [self startWithAppKey:appKey
                appName:appName
                userUID:userUID
            umengAppKey:umengAppKey
           GATrackingId:nil
                channel:channelName
           reportPolicy:strategy];
}

+ (void)startWithAppKey:(NSString *)appKey
                appName:(NSString *)appName
                userUID:(NSNumber *)userUID
            umengAppKey:(NSString *)umengAppKey
           GATrackingId:(NSString *)trackingId
                channel:(NSString *)channelName
           reportPolicy:(DOUStatStrategy)strategy
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [DOUMobileStat startWithAppkey:appKey
                           appName:appName
                           userUID:userUID];

    NSString *channelInfo = [[[NSBundle mainBundle] infoDictionary] objectForKey:kDOUInfoPlistChannelPublishKey];
    NSString *channel = channelInfo.length < 1 ? channelName : channelInfo;

    if (umengAppKey) {
      gTrackingServices |= kDOUThirdPartyTrackingServiceUmeng;

      ReportPolicy umengReportPolicy;
      switch (strategy) {
        case kDOUStatStrategyRealTime: {
          umengReportPolicy = REALTIME;
          break;
        }

        case kDOUStatStrategyDefault: {
          umengReportPolicy = BATCH;
          break;
        }

        case kDOUStatStrategyLaunchAndWifi: {
          umengReportPolicy = SENDWIFIONLY;
          break;
        }

        default:
          break;
      }

      [MobClick startWithAppkey:umengAppKey reportPolicy:umengReportPolicy channelId:channel];
    }

    if (trackingId) {
      gTrackingServices |= kDOUThirdPartyTrackingServiceGoogleAnalytics;

      [[GAI sharedInstance] trackerWithTrackingId:trackingId];
      [[[GAI sharedInstance] defaultTracker] set:kGAParameterKeyUserUID value:[userUID stringValue]];
      [[[GAI sharedInstance] defaultTracker] set:kGAIReferrer value:channel];
    }
  });
}

+ (void)setUserUID:(NSNumber *)userUID token:(NSString *)token
{
  [DOUMobileStat bindUserUID:userUID token:token];

  if (gTrackingServices & kDOUThirdPartyTrackingServiceGoogleAnalytics) {
    [[[GAI sharedInstance] defaultTracker] set:kGAParameterKeyUserUID value:[userUID stringValue]];
  }
}

+ (void)unbindUser
{
  [DOUMobileStat unBindUser];

  if (gTrackingServices & kDOUThirdPartyTrackingServiceGoogleAnalytics) {
    [[[GAI sharedInstance] defaultTracker] set:kGAParameterKeyUserUID value:nil];
  }
}

+ (void)setLocation:(CLLocation *)location
{
  [DOUMobileStat setLocation:location];

  if (gTrackingServices & kDOUThirdPartyTrackingServiceUmeng) {
    [MobClick setLocation:location];
  }

  if (gTrackingServices & kDOUThirdPartyTrackingServiceGoogleAnalytics) {
    [[[GAI sharedInstance] defaultTracker] set:@"longitude" value:[NSString stringWithFormat:@"%f", location.coordinate.longitude]];
    [[[GAI sharedInstance] defaultTracker] set:@"latitude" value:[NSString stringWithFormat:@"%f", location.coordinate.latitude]];
    [[[GAI sharedInstance] defaultTracker] set:@"haccuracy" value:[NSString stringWithFormat:@"%f", location.horizontalAccuracy]];
  }
}

+ (void)event:(NSString *)eventId
{
  [self event:eventId label:nil];
}

+ (void)event:(NSString *)eventId label:(NSString *)label
{
  [DOUMobileStat event:eventId label:label];

  if (gTrackingServices & kDOUThirdPartyTrackingServiceUmeng) {
    [MobClick event:eventId label:label];
  }

  if (gTrackingServices & kDOUThirdPartyTrackingServiceGoogleAnalytics) {
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createEventWithCategory:kGACategoryDefault
                                                                           action:eventId
                                                                            label:label
                                                                            value:nil];
    [[[GAI sharedInstance] defaultTracker] send:[builder build]];
  }
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributesDic
{
  NSString *jsonStr = [attributesDic toJsonStringInDOUStat];
  [DOUMobileStat event:eventId label:jsonStr];

  if (gTrackingServices & kDOUThirdPartyTrackingServiceUmeng) {
    [MobClick event:eventId attributes:attributesDic];
  }

  if (gTrackingServices & kDOUThirdPartyTrackingServiceGoogleAnalytics) {
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createEventWithCategory:kGACategoryDefault
                                                                           action:eventId
                                                                            label:nil
                                                                            value:nil];
    [builder setAll:attributesDic];
    [[[GAI sharedInstance] defaultTracker] send:[builder build]];
  }
}

+ (void)beginEvent:(NSString *)eventName
{
  [self beginEvent:eventName label:nil];
}

+ (void)endEvent:(NSString *)eventName
{
  [self endEvent:eventName label:nil];
}

+ (void)beginEvent:(NSString *)eventName label:(NSString *)label
{
  [DOUMobileStat beginEvent:eventName label:label];

  if (gTrackingServices & kDOUThirdPartyTrackingServiceUmeng) {
    [MobClick beginEvent:eventName label:label];
  }

  if (gTrackingServices & kDOUThirdPartyTrackingServiceGoogleAnalytics) {
    [self _addGATimingFieldsWithEvent:eventName label:label attributes:nil];
  }
}

+ (void)endEvent:(NSString *)eventName label:(NSString *)label
{
  [DOUMobileStat endEvent:eventName label:label];

  if (gTrackingServices & kDOUThirdPartyTrackingServiceUmeng) {
    [MobClick endEvent:eventName label:label];
  }

  if (gTrackingServices & kDOUThirdPartyTrackingServiceGoogleAnalytics) {
    [[[GAI sharedInstance] defaultTracker] send:[self _popGATimingFieldsWithEvent:eventName label:label attributes:nil]];
  }
}

+ (void)beginEvent:(NSString *)eventName attributes:(NSDictionary *)attributesDic
{
  NSString *jsonStr = [attributesDic toJsonStringInDOUStat];
  [DOUMobileStat beginEvent:eventName label:jsonStr];

  if (gTrackingServices & kDOUThirdPartyTrackingServiceUmeng) {
    [MobClick beginEvent:eventName primarykey:eventName attributes:attributesDic];
  }

  if (gTrackingServices & kDOUThirdPartyTrackingServiceGoogleAnalytics) {
    [self _addGATimingFieldsWithEvent:eventName label:nil attributes:attributesDic];
  }
}

+ (void)endEvent:(NSString *)eventName attributes:(NSDictionary *)attributesDic
{
  NSString *jsonStr = [attributesDic toJsonStringInDOUStat];
  [DOUMobileStat endEvent:eventName label:jsonStr];

  if (gTrackingServices & kDOUThirdPartyTrackingServiceUmeng) {
    [MobClick endEvent:eventName primarykey:eventName];
  }

  if (gTrackingServices & kDOUThirdPartyTrackingServiceGoogleAnalytics) {
    [[[GAI sharedInstance] defaultTracker] send:[self _popGATimingFieldsWithEvent:eventName label:nil attributes:attributesDic]];
  }
}

+ (void)_addGATimingFieldsWithEvent:(NSString *)event label:(NSString *)label attributes:(NSDictionary *)attributes
{
  NSMutableDictionary *dict = ga_timing_dict();
  @synchronized(dict)
  {
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createTimingWithCategory:kGACategoryDefault
                                                                          interval:@(CFAbsoluteTimeGetCurrent() * 1000)
                                                                              name:event
                                                                             label:label];
    [builder setAll:attributes];
    [dict setObject:builder forKey:event];
  }
}

+ (NSDictionary *)_popGATimingFieldsWithEvent:(NSString *)event label:(NSString *)label attributes:(NSDictionary *)attributes
{
  NSDictionary *fields = nil;
  NSMutableDictionary *dict = ga_timing_dict();
  @synchronized(dict)
  {
    GAIDictionaryBuilder *builder = [dict objectForKey:event];
    if (builder) {
      double interval = CFAbsoluteTimeGetCurrent() * 1000 - [[builder get:kGAITimingValue] doubleValue];
      [builder set:[@(interval) stringValue] forKey:kGAITimingValue];
      [builder set:label forKey:kGAIEventLabel];
      [builder setAll:attributes];
      fields = [builder build];

      [dict removeObjectForKey:event];
    }
  }
  return fields;
}

@end
