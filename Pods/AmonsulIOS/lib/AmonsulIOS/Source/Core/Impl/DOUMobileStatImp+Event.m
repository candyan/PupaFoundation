//
//  DOUMobileStat+Networking.m
//  AMousulIOS
//
//  Created by wise on 12-12-25.
//  Copyright (c) 2012年 Douban. All rights reserved.
//

#import "DOUMobileStatImp+Event.h"

#import "DOUAppInfo.h"
#import "DOUDeviceInfo.h"
#import "DOUStatEvent.h"
#import "DOUMobileStatUtils.h"
#import "AmonsulConnection.h"
#import "DOUStatConstant.h"
#import "NSDictionary+DOUJSON.h"
#import "NSArray+DOUJSON.h"
#import "DOUMobileStatImp+Network.h"
#import "DOUMobileStatEventStorage.h"
#import "DOUStatConfig.h"

static const NSTimeInterval kDOUStateDefaultUploadMinInterval = 60 * 60;

@implementation DOUMobileStatImp (Event)

- (void)event:(NSString *)eventId label:(NSString *)label acc:(NSInteger)accumulation
{
  [self event:eventId label:label acc:accumulation isSync:NO];
}

- (void)event:(NSString *)eventId
        label:(NSString *)label
          acc:(NSInteger)accumulation
       isSync:(BOOL)isSync
{
  NSParameterAssert(self.apikey != nil);
  NSParameterAssert(label == nil || label.length < 500);
  if (self.apikey == nil) {
    DERRORLOG(@"App api key should not be nil");
    return;
  }
  DOUStatEvent *event = [self _createEvent];
  [event setName:eventId];
  if (label != nil) {
    [event setLabel:label];
  }
  [event setCount:accumulation];
  [self logEvent:event syncWrite:isSync];
}

- (void)beginEvent:(NSString *)eventId label:(NSString *)label
{
  if (self.apikey == nil) {
    DERRORLOG(@"App api key should not be nil");
    return;
  }
  DOUStatEvent *evt = [self _createEvent];
  [evt setName:eventId];
  if (label != nil) {
    [evt setLabel:label];
  }
  [evt setAction:kStatEventBeginEvent];
  [self logEvent:evt syncWrite:NO];
}

- (void)endEvent:(NSString *)eventId label:(NSString *)label
{
  if (self.apikey == nil) {
    DERRORLOG(@"App api key should not be nil");
    return;
  }
  DOUStatEvent *evt = [self _createEvent];
  [evt setName:eventId];
  if (label != nil) {
    [evt setLabel:label];
  }
  [evt setAction:kStatEventEndEvent];
  [self logEvent:evt syncWrite:NO];
}

- (DOUStatEvent *)_createEvent
{
  DOUStatEvent *evt = [[DOUStatEvent alloc] init];
  [evt setNet:[DOUAppInfo getNet]];
  CLLocationDegrees longitude = self.currentLocation.coordinate.longitude;
  CLLocationDegrees latitude = self.currentLocation.coordinate.latitude;
  if (self.currentLocation
      && longitude >= -180.0 && longitude <= 180.0
      && latitude >= -90.0 && latitude <= 90.0) {
    evt.longitude = @(self.currentLocation.coordinate.longitude);
    evt.latitude = @(self.currentLocation.coordinate.latitude);
  }
  return evt;
}

- (void)uploadAllEvents
{
  [self uploadAllImportantEvents];
  [self uploadAllNormalEvents];
}

// 在 1.4.2以及以前的版本中，存放event分为important和normal两类
// 1.4.2 的下个版本先保留读取的方法，后续把读取的也可以删除
- (void)uploadAllImportantEvents
{
  if (self.internetReachability.currentReachabilityStatus == DOUAmonsulNotReachable) {
    return;
  }
  NSArray *importantLogs = [[DOUMobileStatEventStorage sharedInstance] sortedPathsOfImportantLogFilesByTimeIncrease];
  for (NSString *logPath in importantLogs) {
    @try {
      [self sendEventsInFile:logPath
                     inQueue:self.networkQueue
                     succeed:^{
                       self.lastUploadTime = [NSDate date];
                     }
       
                     failure:NULL];
    } @catch (NSException *exception) {
      DERRORLOG(@"ex : %@", exception);
      
      NSAssert(NO, @"exception happends");
    }
  }
}

- (void)uploadAllNormalEvents
{
  if (self.internetReachability.currentReachabilityStatus == DOUAmonsulNotReachable) {
    return;
  }
  NSArray *normalLogs = [[DOUMobileStatEventStorage sharedInstance] sortedPathsOfNormalLogFilesByTimeIncrease];
  for (NSString *logPath in normalLogs) {
    @try {
      [self sendEventsInFile:logPath
                     inQueue:self.networkQueue
                     succeed:^{
                       self.lastUploadTime = [NSDate date];
                       [[NSUserDefaults standardUserDefaults] setObject:self.lastUploadTime forKey:kDOUStatPreKeyNormalEventLastUploadTime];
                     }
       
                     failure:NULL];
    } @catch (NSException *exception) {
      DERRORLOG(@"ex : %@", exception);
      
      NSAssert(NO, @"exception happends");
    }
  }
}

- (void)uploadAllEventsIfNeeded
{
  DOUStatConfig *config = [DOUStatConfig localConfig];
  NSInteger seconds = config.intervalSeconds;
  if (seconds <= 0) {
    seconds = kDOUStateDefaultUploadMinInterval;
  }
  if (self.lastUploadTime == nil
      || ABS([self.lastUploadTime timeIntervalSinceNow]) > seconds) {
    [self uploadAllEvents];
  }
}

- (void)clearOldNormalEventsIfNeeded
{
  NSInteger deletedNum = [[DOUMobileStatEventStorage sharedInstance] clearOldNormalLogFiles];
  if (deletedNum > 0) {
    [self event:kStatEventFileDelete
          label:[NSString stringWithFormat:@"n_%d", deletedNum]
            acc:1];
  }
}

- (void)clearOldImportantEventsIfNeeded
{
  NSInteger deletedNum = [[DOUMobileStatEventStorage sharedInstance] clearOldImportLogFiles];
  if (deletedNum > 0) {
    [self event:kStatEventFileDelete
          label:[NSString stringWithFormat:@"i_%d", deletedNum]
            acc:1];
  }
}

#pragma mark -
- (void)logEvent:(DOUStatEvent *)event syncWrite:(BOOL)isSyncWrite
{
  if (isSyncWrite) {
    [[DOUMobileStatEventStorage sharedInstance] writelEventToDisk:event];
  } else {
    [[DOUMobileStatEventStorage sharedInstance] asyncWritelEventToDisk:event];
  }
}

- (NSMutableDictionary *)event2Dictionary:(DOUStatEvent *)event
{
  NSDictionary *eventDic = [event toMutableDictionary];
  return [self events2Dictionary:@[eventDic]];
}

- (NSMutableDictionary *)events2Dictionary:(NSArray *)eventDicArr
{
  if (eventDicArr == nil || [eventDicArr count] < 1) {
    return nil;
  }
  
  NSMutableDictionary *appInfo = [DOUAppInfo toMutableDic];
  if (self.channel != nil) {
    [appInfo setValue:self.channel forKey:kJSON_KEY_CHANNEL];
  }
  
  if (self.userUID != nil) {
    [appInfo setValue:self.userUID.stringValue forKey:kJSON_KEY_USERID];
  }
  
  NSMutableDictionary *uploadDic = [[NSMutableDictionary alloc] init];
  [uploadDic setValue:appInfo forKey:kJSON_KEY_APPINFO];
  [uploadDic setValue:[DOUDeviceInfo infoDic] forKey:kJSON_KEY_DEVICEINFO];
  
  [uploadDic setValue:eventDicArr forKey:kJSON_KEY_EVENTSINFO];
  
  NSMutableArray *arr = [[NSMutableArray alloc] init];
  [arr addObject:uploadDic];
  NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
  [ret setValue:arr forKey:KJSON_KEY_LOGS];
  return ret;
}

@end
