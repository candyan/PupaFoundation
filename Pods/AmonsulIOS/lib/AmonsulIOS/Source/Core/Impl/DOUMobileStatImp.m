//
//  DouMobileStatImp.m
//  AMousulIOS
//
//  Created by wise on 13-3-1.
//  Copyright (c) 2013年 Douban. All rights reserved.
//

#import "DOUMobileStatImp.h"
#import "DOUAppInfo.h"
#import "DOUDeviceInfo.h"
#import "DOUStatEvent.h"
#import "AmonsulConnection.h"
#import "DOUStatConstant.h"
#import "NSDictionary+DOUJSON.h"
#import "NSArray+DOUJSON.h"
#import "DOUMobileStatImp+Event.h"
#import "DOUMobileStatImp+ServiceAvailable.h"
#import "DOUMobileStatUtils.h"
#import "DOUStatConfig.h"
#import "NSString+DOUStat.h"
#import "DOUMobileStatEventStorage.h"
#import "DOUMobileStatImp+Network.h"

NSString *const kDOUStatPreKeyNormalEventLastUploadTime = @"com.douban.stat.normal_events_upload_time";
NSString *const kDOUStatPreKeyFlagAppFirstLaunch = @"com.douban.stat.first_launch";

@interface DOUMobileStatImp ()
@property (nonatomic, assign) BOOL started;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation DOUMobileStatImp

+ (id)sharedInstance
{
  static DOUMobileStatImp *instance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[DOUMobileStatImp alloc] init];
  });
  return instance;
}

#pragma mark - init and dealloc

- (id)init
{
  self = [super init];
  if (self) {
    _networkQueue = [[NSOperationQueue alloc] init];
    [_networkQueue setMaxConcurrentOperationCount:1];
    [self initNotifications];
    [self initReachability];
  }
  return self;
}

- (void)initNotifications
{
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  // 注册通知
  
  [center addObserver:self
             selector:@selector(appDidFinishLaunching:)
                 name:UIApplicationDidFinishLaunchingNotification
               object:nil];
  
  [center addObserver:self
             selector:@selector(appWillEnterForeground:)
                 name:UIApplicationWillEnterForegroundNotification
               object:nil];
  
  [center addObserver:self
             selector:@selector(appDidEnterBackground:)
                 name:UIApplicationDidEnterBackgroundNotification
               object:nil];
  
  [center addObserver:self
             selector:@selector(appWillTerminated:)
                 name:UIApplicationWillTerminateNotification
               object:nil];
  
  
  [center addObserver:self
             selector:@selector(reachabilityChanged:)
                 name:kDOUAmonsulReachabilityChangedNotification
               object:nil];
}

- (void)initReachability
{
  self.internetReachability = [DouReachability reachabilityForInternetConnection];
  [self.internetReachability startNotifier];
  
  self.wifiReachability = [DouReachability reachabilityForLocalWiFi];
  [self.wifiReachability startNotifier];
  
  [DOUAppInfo setCurrentNetworkStatus:[self statusByWifiAndInternetReachability]];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - start

- (void)startWithAppkey:(NSString *)appKey
                appName:(NSString *)appName
                userUID:(NSNumber *)userUID
              channelId:(NSString *)cid
{
  if (appKey == nil || appName == nil) {
    DERRORLOG(@"App key or name should not be nil");
  } else {
    self.apikey = appKey;
    self.channel = cid;
    self.started = YES;
    self.appname = appName;
    self.userUID = userUID;
    [self sendRequestServiceAvailable];
  }
}

#pragma mark - util

- (DOUAmonsulNetworkStatus)statusByWifiAndInternetReachability
{
  if (self.wifiReachability.currentReachabilityStatus != DOUAmonsulNotReachable) {
    return DOUAmonsulReachableViaWiFi;
  } else {
    if (self.internetReachability.currentReachabilityStatus == DOUAmonsulNotReachable) {
      return DOUAmonsulNotReachable;
    } else {
      return DOUAmonsulReachableViaWWAN;
    }
  }
}

/*
 如果两个提醒并存那么默认的顺序是
 did finish launching -> did become active
 
 will enter forground -> did become active
 will resign active -> did enter background
 
 */

#pragma mark - notification handlers
- (void)appDidFinishLaunching:(NSNotification *)launchNotifications
{
  if (self.started == NO) {
    DERRORLOG(@"!!!!!!!!!!! Error: Should start DOUMobileStat first !!!!!!!!");
    return;
  }
  [self logFirstLaunchEventIfNeededWithLaunchNotification:launchNotifications];
  
  [self uploadAllEvents];
  [self logLaunchEventWithLaunchNotification:launchNotifications];
}

/*
 * 发送结束terminal事件，一般在程序关闭
 */
- (void)appWillTerminated:(NSNotification *)notification
{
  [self event:kStatEventTerminal
        label:nil
          acc:1
       isSync:YES];
  
  [self clearOldNormalEventsIfNeeded];
  [self clearOldImportantEventsIfNeeded];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

//
//  发送launch事件 一般在启动的时候 后者后台到前台是调用
//  wifi下上传所有事件：重要事件和普通事件
//  3g下：对于普通事件，上次上传时间为一天前，则上传这次的事件
//
- (void)appWillEnterForeground:(NSNotification *)notification
{
  if (self.started == NO) {
    DERRORLOG(@"!!!!!!!!!!! Error: Should start DOUMobileStat first !!!!!!!!");
    return;
  }
  
  [self uploadAllEventsIfNeeded];
  [self event:kStatEventLaunch label:kStatEventLaunchLabelEnterForeground acc:1];
}

/*
 * 进入后台调用
 */
- (void)appDidEnterBackground:(NSNotification *)notification
{
  [self event:kStatEventTerminal
        label:kStatEventLaunchLabelEnterBackground
          acc:1
       isSync:YES];
  
  [self clearOldNormalEventsIfNeeded];
  [self clearOldImportantEventsIfNeeded];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  [DOUMobileStatUtils startBackgroundTask];
  [self uploadAllEvents];
}


#pragma mark - service configuration and status
- (void)setupUploaderTimer
{
  DOUStatConfig *config = [DOUStatConfig localConfig];
  NSInteger seconds = config.intervalSeconds;
  if (seconds <= 0) {
    [self.timer invalidate];
    self.timer = nil;
  } else {
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:MAX(seconds, 30.0f)
                                                  target:self
                                                selector:@selector(setupUploaderTimerFired:)
                                                userInfo:nil
                                                 repeats:YES];
  }
}

- (void)setupUploaderTimerFired:(NSTimer *)timer
{
  [self uploadAllEvents];
}

/*
 * 保存配置选项
 * 配置项的存储。目前只配置服务可用不可用（可以扩展）
 */
- (void)saveServiceAvailable:(BOOL)available intervalSeconds:(NSInteger)seconds
{
  DOUStatConfig *config = [DOUStatConfig localConfig];
  if (config) {
    config.serviceAvailable = available;
    config.intervalSeconds = seconds;
    [config synchronize];
  }
  [self setupUploaderTimer];
}

#pragma mark - util
- (void)logFirstLaunchEventIfNeededWithLaunchNotification:(NSNotification *)launchNotification
{
  NSString *label = [self labelForLaunchNotification:launchNotification];
  NSNumber *firstLaunchFlag = [[NSUserDefaults standardUserDefaults] objectForKey:kDOUStatPreKeyFlagAppFirstLaunch];
  if (firstLaunchFlag == nil) {
    [self event:kStatEventFirstLaunch label:label acc:1];
    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:kDOUStatPreKeyFlagAppFirstLaunch];
  }
}

- (void)logLaunchEventWithLaunchNotification:(NSNotification *)launchNotification
{
  NSString *label = [self labelForLaunchNotification:launchNotification];
  [self event:kStatEventLaunch label:label acc:1];
}

- (NSString *)labelForLaunchNotification:(NSNotification *)launchNotification
{
  NSURL *launchURL = [launchNotification.userInfo objectForKey:UIApplicationLaunchOptionsURLKey];
  NSString *query = [launchURL query];
  NSString *sourceApp = [launchNotification.userInfo objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
  NSDictionary *remoteInfo = [launchNotification.userInfo objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
  NSDictionary *localInfo = [launchNotification.userInfo objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
  
  NSMutableString *label = [NSMutableString string];
  if (query && query.length > 0) {
    [label appendFormat:@"query=%@|", query];
  }
  if (sourceApp && sourceApp.length > 9) {
    [label appendFormat:@"source=%@|", sourceApp];
  }
  if (remoteInfo) {
    [label appendString:@"notification=remote|"];
  }
  if (localInfo) {
    [label appendString:@"notification=local|"];
  }
  return label;
}

#pragma mark - Notification
- (void)reachabilityChanged:(NSNotification *)notification
{
  DOUAmonsulNetworkStatus networkStatue = [self statusByWifiAndInternetReachability];
  [DOUAppInfo setCurrentNetworkStatus:networkStatue];
  
  if (networkStatue != DOUAmonsulNotReachable) {
    [self uploadAllEventsIfNeeded];
  }
}

@end
