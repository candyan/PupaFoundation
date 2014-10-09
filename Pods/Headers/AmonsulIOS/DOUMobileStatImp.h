//
//  DouMobileStatImp.h
//  AMousulIOS
//
//  Created by wise on 13-3-1.
//  Copyright (c) 2013年 Douban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUMobileStat.h"
#import "DouReachability.h"
#import "AmonsulConnection.h"
@class DOUStatEvent;

extern NSString *const kDOUStatPreKeyNormalEventLastUploadTime;
extern NSString *const kDOUStatPreKeyFlagAppFirstLaunch;

@interface DOUMobileStatImp : NSObject

@property (nonatomic, retain) DouReachability *internetReachability;
@property (nonatomic, retain) DouReachability *wifiReachability;

@property (nonatomic, copy) NSString *apikey;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSNumber *userUID;
@property (nonatomic, copy) CLLocation *currentLocation;
@property (nonatomic, copy) NSString *appname;
@property (nonatomic, copy) NSString *md5Token;
@property (nonatomic, strong) NSDate *lastUploadTime;
@property (nonatomic, strong, readonly) NSOperationQueue *networkQueue;

+ (id)sharedInstance;

- (void)startWithAppkey:(NSString *)appKey
                appName:(NSString *)appName
                userUID:(NSNumber *)userUID
              channelId:(NSString *)cid;
- (DOUAmonsulNetworkStatus)statusByWifiAndInternetReachability;

- (void)saveServiceAvailable:(BOOL)available intervalSeconds:(NSInteger)seconds;


@end
