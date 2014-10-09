//
//  DOUAPIClient+Loc.h
//  DoubanObjCClient
//
//  Created by GUO Lin on 9/13/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "DOUAPIClient.h"

@class DOULoc;
@class DOULocArray;
@interface DOUAPIClient (Loc)

- (void)getAllLocsWithStart:(NSInteger)start
                      count:(NSInteger)count
                    success:(void (^)(DOULocArray *locArray))successBlock
                    failure:(DOUAPIRequestFailErrorBlock)failureBlock;

- (void)searchLocsWithKey:(NSString *)key
                    start:(NSInteger)start
                    count:(NSInteger)count
                  success:(void (^)(DOULocArray *locArray))successBlock
                  failure:(DOUAPIRequestFailErrorBlock)failureBlock;

- (void)getLocWithLatitude:(double)latitude
                 longitude:(double)longitude
                   success:(void (^)(DOULoc *loc))successBlock
                   failure:(DOUAPIRequestFailErrorBlock)failureBlock;

@end
