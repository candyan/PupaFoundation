//
//  StatEvent.m
//  amonDemo
//
//  Created by tan fish on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "DOUStatEvent.h"
#import "NSDictionary+DOUJSON.h"
#import "NSArray+DOUJSON.h"
#import "DOUAppInfo.h"
#import "DOUStatConstant.h"

@implementation DOUStatEvent

- (id)init
{
  self = [super init];
  if (self) {
    self.date = [self timestampInSecondByDate:[NSDate date]];
  }
  return self;
}

- (id)initWithName:(NSString *)name label:(NSString *)label acc:(NSInteger)count
{
  self = [super init];
  if (self) {
    self.name = name;
    if (label != nil && ![label isEqualToString:@""]) {
      self.label = label;
    }
    self.count = count;
    self.date = [self timestampInSecondByDate:[NSDate date]];
  }
  return self;
}

//
// 将事件NSDictionary 化
//

- (NSMutableDictionary *)toMutableDictionary
{
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  [dic setValue:self.name forKey:kJSON_KEY_EVENTNAME];
  [dic setValue:self.date forKey:kJSON_KEY_EVENTTIME];
  [dic setValue:self.page forKey:kJSON_KEY_EVENTPAGE];
  self.appversion = [DOUAppInfo getAppVersion];
  [dic setValue:self.appversion forKey:kJSON_KEY_EVENTVERSION];
  if (self.count >= 1) {
    [dic setValue:[NSString stringWithFormat:@"%d", self.count] forKey:kJSON_KEY_EVENTCOUNT];
  }
  if (self.action != nil) {
    [dic setValue:self.action forKey:kJSON_KEY_EVENTACTION];
  }
  if (self.label != nil) {
    [dic setValue:self.label forKey:kJSON_KEY_EVENTLABEL];
  }
  if (self.net) {
    [dic setValue:self.net forKey:kJSON_KEY_NET];
  }
  if (self.latitude) {
    [dic setValue:[NSString stringWithFormat:@"%.4f", self.latitude.doubleValue]
           forKey:kJSON_KEY_LAT];
  }
  if (self.longitude) {
    [dic setValue:[NSString stringWithFormat:@"%.4f", self.longitude.doubleValue]
           forKey:kJSON_KEY_LNG];
  }
  return dic;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ : %@", self.name, self.date];
}

#pragma mark - private method
- (NSString *)timestampInSecondByDate:(NSDate *)date
{
  NSTimeInterval timeIntervalSince1970 = [date timeIntervalSince1970];
  return [NSString stringWithFormat:@"%.6f", timeIntervalSince1970];
}

@end
