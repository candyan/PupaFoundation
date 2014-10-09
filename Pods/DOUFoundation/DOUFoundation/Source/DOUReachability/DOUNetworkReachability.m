//
//  DOUNetworkReachability.m
//  DoubanFMCoreCommon
//
//  Created by alex zou on 13-4-2.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//

#import "DOUNetworkReachability.h"
#import "Reachability.h"

NSString *const kDOUNetworkReachabilityStatusDidChangeNotification = @"com.douban.foundation.rechability.status";

@interface DOUNetworkReachability ()
@property (nonatomic, strong) Reachability *internetReachability;
@property (nonatomic, strong) Reachability *wifiReachability;
@end

@implementation DOUNetworkReachability {
  NetworkStatus _currentStatus;
  BOOL _notifierStarted;
}

+ (DOUNetworkReachability *)sharedReachability
{
  static DOUNetworkReachability *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[DOUNetworkReachability alloc] init];
  });
  return sharedInstance;
}

- (id)init
{
  return [self initWithStaringNotifier:YES];
}

- (id)initWithStaringNotifier:(BOOL)start
{
  if ( (self = [super init]) ) {
    _internetReachability = [Reachability reachabilityForInternetConnection];
    _wifiReachability = [Reachability reachabilityForLocalWiFi];
    _currentStatus = [self _networkStatusFromReachability];

    if (start) {
      [self startNotifier];
    }
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startNotifier
{
  if (_notifierStarted) {
    return;
  }

  _notifierStarted = YES;

  [_internetReachability startNotifier];
  [_wifiReachability startNotifier];

  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  [center addObserver:self
             selector:@selector(wifiReachabilityChanged:)
                 name:kReachabilityChangedNotification
               object:_wifiReachability];
  [center addObserver:self
             selector:@selector(internetReachabilityChanged:)
                 name:kReachabilityChangedNotification
               object:_internetReachability];
}

- (NetworkStatus)currentStatus
{
  return _currentStatus;
}

- (void)wifiReachabilityChanged:(NSNotification *)notification
{
  [self _notifyIfNetworkStatusDidChange];
}

- (void)internetReachabilityChanged:(NSNotification *)notification
{
  [self _notifyIfNetworkStatusDidChange];
}

- (void)_notifyIfNetworkStatusDidChange
{
  NetworkStatus newStatus = [self _networkStatusFromReachability];
  if (newStatus != _currentStatus) {
    _currentStatus = newStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:kDOUNetworkReachabilityStatusDidChangeNotification
                                                        object:self];
    
  }
}

- (NetworkStatus)_networkStatusFromReachability
{
  if (self.wifiReachability.currentReachabilityStatus == ReachableViaWiFi) {
    return ReachableViaWiFi;
  } else if (self.internetReachability.currentReachabilityStatus == ReachableViaWWAN) {
    return ReachableViaWWAN;
  } else {
    return NotReachable;
  }
}

@end
