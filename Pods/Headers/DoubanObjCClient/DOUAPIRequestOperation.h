//
//  DOUAPIRequest.h
//  DoubanObjCClient
//
//  Created by Jianjun Wu on 5/8/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPRequestOperation;

@interface DOUAPIRequestOperation : NSObject

- (id) initWithAFHTTPRequestOperation:(AFHTTPRequestOperation *)requestOperation;

- (NSURLRequest *)request;

- (NSHTTPURLResponse *)response;

- (NSData *)responseData;

- (NSString *)responseString;

@end
