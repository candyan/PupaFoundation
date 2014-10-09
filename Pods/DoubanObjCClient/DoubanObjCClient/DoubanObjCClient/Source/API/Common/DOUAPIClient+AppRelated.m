//
//  DOUAPIClient+AppRelated.m
//  DoubanObjCClient
//
//  Created by Candyan on 2/17/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "DOUAPIClient+AppRelated.h"
#import "DOUMobileApp.h"

@implementation DOUAPIClient (AppRelated)

- (void)getRelatedAppsForAppID:(NSString *)appID
                      success:(void (^)(NSArray *))successBlock
                      failure:(DOUAPIRequestFailErrorBlock)failureBlock {
  NSString *finalPath = [NSString stringWithFormat:@"app/%@/related", appID];
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setValue:@"20" forKey:@"max-results"];
  
  [self getPath:finalPath parameters:params success:^(NSString *resultStr) {
    NSMutableArray *mobileAppArray = [NSMutableArray array];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[resultStr dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:kNilOptions
                                                      error:nil];
    NSDictionary *mobileAppsDictionary = [NSDictionary dictionaryWithDictionary:jsonObject];
    
    for (NSDictionary *mobileAppDictionary in [mobileAppsDictionary objectForKey:@"entry"]) {
      DOUMobileApp *mobileApp = [DOUMobileApp objectWithDictionary:mobileAppDictionary];
      [mobileAppArray addObject:mobileApp];
    }
    
    if (successBlock) {
      successBlock(mobileAppArray);
    }
  } failure:^(DOUError *error) {
    if (failureBlock) {
      failureBlock(error);
    }
  }];
}

@end
