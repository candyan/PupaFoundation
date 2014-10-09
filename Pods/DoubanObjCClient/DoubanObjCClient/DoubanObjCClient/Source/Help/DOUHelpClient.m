//
//  DOUHelpClient.m
//  DoubanObjCClient
//
//  Created by Candyan on 1/17/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "DOUHelpClient.h"
#import "AFHTTPClient.h"

@implementation DOUHelpClient

static DOUHelpClient *myInstance = nil;

+ (id)sharedInstance {
  @synchronized(self) {
    if (myInstance == nil) {
      myInstance = [[DOUHelpClient alloc] initWithBaseURL:@"http://help.douban.com/"];
    }
  }
  return myInstance;
}

#pragma mark -  api
-(void)postFeedbackWithUserID:(NSString *)userID
                      content:(NSString *)content
                        qtype:(NSString *)qtype
              baseInformation:(NSString *)baseInformation
                      success:(void (^)(BOOL success))successBlock
                      failure:(DOUAPIRequestFailErrorBlock)failureBlock {
  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  if (userID) {
    [parameters setObject:userID forKey:@"user"];
  }
  [parameters setObject:content forKey:@"content"];
  [parameters setObject:qtype forKey:@"qtype"];
  [parameters setObject:baseInformation forKey:@"version"];
  
  [self postPath:@"help/api/questions"
      parameters:parameters
  successRequest:^(NSString *resultStr, DOUAPIRequestOperation *requstOperation) {
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:requstOperation.responseData
                                                    options:kNilOptions
                                                      error:&error];
    NSMutableDictionary *dic = nil;
    if (error == nil) {
      dic = [NSMutableDictionary dictionaryWithDictionary:jsonObject];
    }
    
    NSString *result = [dic objectForKey:@"result"];
    if (result) {
      if ([result isEqualToString:@"success"]) {
        successBlock(YES);
      } else {
        successBlock(NO);
      }
    }
  } failure:^(DOUError *error) {
    if (failureBlock) {
      failureBlock(error);
    }
  }];
}

@end
