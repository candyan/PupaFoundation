//
//  DOUAPIRequest.m
//  DoubanObjCClient
//
//  Created by Jianjun Wu on 5/8/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "DOUAPIRequestOperation.h"
#import "AFHTTPRequestOperation.h"

@interface DOUAPIRequestOperation ()

@end

@implementation DOUAPIRequestOperation {
  AFHTTPRequestOperation *_requestOperation;
}

#pragma mark - init
- (id)initWithAFHTTPRequestOperation:(AFHTTPRequestOperation *)requestOperation {
  self = [self init];
  if (self) {
    _requestOperation = requestOperation;
  }
  return self;
}

/*
 发送请求时最终的URL
 */
- (NSURLRequest *)request {
  return _requestOperation.request;
}

- (NSHTTPURLResponse *)response {
  return _requestOperation.response;
}

- (NSData *)responseData {
  return _requestOperation.responseData;
}

- (NSString *)responseString
{
  return _requestOperation.responseString;
}

@end
