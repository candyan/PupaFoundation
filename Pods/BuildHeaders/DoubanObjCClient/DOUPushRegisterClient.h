//
//  DOUPushRegisterClient.h
//  DoubanObjCClient
//
//  Created by liuyan on 14-1-8.
//  Copyright (c) 2014年 Douban Inc. All rights reserved.
//

#import "DOUAPIClient.h"

@interface DOUPushRegisterClient : DOUAPIClient

+ (DOUPushRegisterClient *)sharedClient;

/**
 Register Device to artery's server to push notification.

 @param deviceToken A NSData Value This is a token that identifies the device to APS. not be nil.
 @param userID A NSString Value This is the current douban user identifier who use this device now.
 */
- (void)apnsRegisterDevice:(NSData *)deviceToken
                    userID:(NSString *)userID
                   success:(DOUAPIRequestSuccessBlock)success
                   failure:(DOUAPIRequestFailErrorBlock)failureBlock;

@end
