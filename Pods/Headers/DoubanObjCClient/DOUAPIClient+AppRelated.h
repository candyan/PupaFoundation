//
//  DOUAPIClient+AppRelated.h
//  DoubanObjCClient
//
//  Created by liu yan on 2/17/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "DOUAPIClient.h"

@class DOUMobileAppArray;

@interface DOUAPIClient (AppRelated)

- (void) getRelatedAppsForAppID:(NSString *)appID
                        success:(void(^)(NSArray *mobileAppArray))successBlock
                        failure:(DOUAPIRequestFailErrorBlock)failureBlock;

@end
