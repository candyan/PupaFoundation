//
//  DoubanAPIClient+UserAPI.m
//  DoubanAPIClient
//
//  Created by Candyan on 9/3/12.
//  Copyright (c) 2012 Douban. All rights reserved.
//

#import "DOUAPIClient+User.h"
#import "DOUAPIConstant.h"

#import "DOUUser.h"
#import "DOUError.h"
#import "DOUUserArray.h"

@implementation DOUAPIClient (UserAPI)

-(void)getUser:(NSString *)userName
       success:(void (^)(DOUUser *user))successBlock
       failure:(DOUAPIRequestFailErrorBlock)failureBlock {
  if (userName == nil) {
    userName = @"~me";
  }

  NSString *finalPath = [NSString stringWithFormat:@"v2/user/%@", userName];
  [self getPath:finalPath parameters:nil success:^(NSString *string) {
  
    DOUUser *user = [DOUUser objectWithString:string];
    if (successBlock) {
      successBlock(user);
    }
  } failure:^(DOUError *error) {
    if (failureBlock) {
      failureBlock(error);
    }
  }];
}

- (void)searchUsers:(NSString *)keyWord
              start:(NSInteger)start
              count:(NSInteger)count
            success:(void (^)(DOUUserArray *userArray))successBlock
            failure:(DOUAPIRequestFailErrorBlock)failureBlock {
  NSMutableDictionary *paramters = [NSMutableDictionary dictionary];

  [paramters setObject:keyWord forKey:@"q"];
  [paramters setObject:[NSString stringWithFormat:@"%d", start] forKey:@"start"];
  [paramters setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];

  [self getPath:@"v2/user" parameters:paramters success:^(NSString *resultStr) {
    
    DOUUserArray *userArray = [DOUUserArray objectWithString:resultStr];
    if (successBlock) {
      successBlock(userArray);
    }
      
  } failure:^(DOUError *error) {
    if (failureBlock) {
      failureBlock(error);
    }
  }];
}

@end
