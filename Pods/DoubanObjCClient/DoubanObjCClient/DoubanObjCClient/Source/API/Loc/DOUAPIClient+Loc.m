//
//  DOUAPIClient+Loc.m
//  DoubanObjCClient
//
//  Created by GUO Lin on 9/13/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "DOUAPIClient+Loc.h"

#import "DOULoc.h"
#import "DOULocArray.h"


@implementation DOUAPIClient (Loc)


- (void)getAllLocsWithStart:(NSInteger)start
                      count:(NSInteger)count
                    success:(void (^)(DOULocArray *locArray))successBlock
                    failure:(DOUAPIRequestFailErrorBlock)failureBlock
{
  NSString *finalPath = @"v2/loc/list";
  
  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
  [dic setValue:[NSNumber numberWithInteger:start] forKey:@"start"];
  [dic setValue:[NSNumber numberWithInteger:count] forKey:@"count"];
  
  [self getPath:finalPath parameters:dic success:^(NSString *string) {

    DOULocArray *array = [DOULocArray objectWithString:string];
    if (successBlock) {
      successBlock(array);
    }
    
  } failure:^(DOUError *error) {
    if (failureBlock) {
      failureBlock(error);
    }
  }];
}

- (void)searchLocsWithKey:(NSString *)key
                    start:(NSInteger)start
                    count:(NSInteger)count
                  success:(void (^)(DOULocArray *locArray))successBlock
                  failure:(DOUAPIRequestFailErrorBlock)failureBlock
{
  
  NSString *finalPath = @"v2/loc/search";
  
  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
  if (key) {
    [dic setValue:key forKey:@"q"];
  }

  [dic setValue:[NSNumber numberWithInteger:start] forKey:@"start"];
  [dic setValue:[NSNumber numberWithInteger:count] forKey:@"count"];
  
  [self getPath:finalPath parameters:dic success:^(NSString *string) {
    
    DOULocArray *array = [DOULocArray objectWithString:string];
    if (successBlock) {
      successBlock(array);
    }
    
  } failure:^(DOUError *error) {
    if (failureBlock) {
      failureBlock(error);
    }
  }];

}

- (void)getLocWithLatitude:(double)latitude
                 longitude:(double)longitude
                   success:(void (^)(DOULoc *loc))successBlock
                   failure:(DOUAPIRequestFailErrorBlock)failureBlock
{
  NSString *finalPath = [NSString stringWithFormat:@"v2/loc/geo?lng=%f&lat=%f", longitude, latitude];
  
  [self getPath:finalPath parameters:nil success:^(NSString *string) {
    DOULoc *loc = [DOULoc objectWithString:string];
    if (successBlock) {
      successBlock(loc);
    }
  } failure:^(DOUError *error) {
    if (failureBlock) {
      failureBlock(error);
    }
  
  }];
}


@end
