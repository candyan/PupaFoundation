//
//  DOUNetworkReachability.h
//  DoubanFMCoreCommon
//
//  Created by alex zou on 13-4-2.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

extern NSString *const kDOUNetworkReachabilityStatusDidChangeNotification;

@interface DOUNetworkReachability : NSObject

- (id)initWithStaringNotifier:(BOOL)start;

- (void)startNotifier;

+ (DOUNetworkReachability *)sharedReachability;
- (NetworkStatus)currentStatus;
@end
