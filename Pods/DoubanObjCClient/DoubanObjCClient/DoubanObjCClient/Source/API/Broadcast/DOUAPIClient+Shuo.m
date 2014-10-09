//
//  DOUAPIClient+Event.m
//  DoubanObjCClient
//
//  Created by GUO Lin on 12/23/12.
//  Copyright (c) 2012 Douban Inc. All rights reserved.
//

#import "DOUAPIClient+Shuo.h"
#import "DOUOAuthClient.h"
#import "DOUAppDescription.h"

@implementation DOUAPIClient (Shuo)

- (void)postShuoStatusesWithText:(NSString *)text
                       imageData:(NSData *)imageData
                     attachments:(NSString *)attachments
                      objectKind:(NSString *)objectKind
                     actionProps:(NSString *)actionProps
                         success:(void (^)())successBlock
                         failure:(DOUAPIRequestFailErrorBlock)failureBlock {
  
  NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
  [paramters setObject:[DOUAppDescription currentAppDescription].appKey forKey:@"source"];
  if (!text) {
    text = @"";
  }
  text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  [paramters setObject:text forKey:@"text"];
  if (imageData) {
    [paramters setObject:imageData forKey:@"image"];
  }
  
  if (attachments) {
    [paramters setObject:attachments forKey:@"attachments"];
  }
  
  if (actionProps) {
    [paramters setObject:actionProps forKey:@"action_props"];
  }
  
  [paramters setObject:@"rec" forKey:@"target"];
  [paramters setObject:@"0" forKey:@"action"];
  
  if (objectKind) {
    [paramters setObject:objectKind forKey:@"object_kind"];
  }

  [self postPath:@"shuo/v2/statuses/" parameters:paramters success:^(NSString *resultStr) {
    if (successBlock) {
      successBlock();
    }
  } failure:^(DOUError *error) {
    if (failureBlock) {
      failureBlock(error);
    }
  }];
}

@end
