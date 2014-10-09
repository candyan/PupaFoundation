//
//  DoubanAPIClient+UserAPI.h
//  DoubanAPIClient
//
//  Created by liu yan on 9/3/12.
//  Copyright (c) 2012 Douban. All rights reserved.
//

#import "DOUAPIClient.h"
#import "DOUAPIConstant.h"

@class DOUUser;
@class DOUUserArray;
@interface DOUAPIClient (User)

- (void)getUser:(NSString *)userName
        success:(void (^)(DOUUser *user))successBlock
        failure:(DOUAPIRequestFailErrorBlock)failureBlock;

- (void)searchUsers:(NSString *)keyWord
              start:(NSInteger)start
              count:(NSInteger)count
            success:(void (^)(DOUUserArray *userArray))successBlock
            failure:(DOUAPIRequestFailErrorBlock)failureBlock;

@end
