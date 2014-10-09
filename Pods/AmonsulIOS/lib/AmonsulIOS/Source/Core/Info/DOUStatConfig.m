//
//  DOUStatConfig.m
//  AMousulIOS
//
//  Created by wise on 13-2-25.
//  Copyright (c) 2013年 Douban. All rights reserved.
//

#import "DOUStatConfig.h"

static NSString *const kIsServiceAvailablekey = @"com.douban.mobileStat.isServiceAvailable";
static NSString *const kAmonSulServiceUploadInterval = @"com.douban.mobileStat.upload_interval";
static DOUStatConfig *sharedInstance = nil;

@implementation DOUStatConfig

+ (DOUStatConfig *)localConfig
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (id)init
{
  self = [super init];
  if (self) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *isServiceAvailable = [defaults objectForKey:kIsServiceAvailablekey];
    if (isServiceAvailable) {
      self.serviceAvailable = [isServiceAvailable boolValue];
    } else {
      self.serviceAvailable = YES;
    }
    NSNumber *interval = [defaults objectForKey:kAmonSulServiceUploadInterval];
    if (interval) {
      self.intervalSeconds = interval.integerValue;
    }
  }
  return self;
}

- (void)synchronize
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:self.serviceAvailable forKey:kIsServiceAvailablekey];
  [defaults setInteger:self.intervalSeconds forKey:kAmonSulServiceUploadInterval];
  [defaults synchronize];
}

@end
