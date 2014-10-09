//
//  NSURLRequest+Douban.h
//  DoubanAPIClient
//
//  Created by liu yan on 12/10/12.
//  Copyright (c) 2012 Douban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (DOUObjCClient)

+(NSURLRequest *) requestWithRedirectURL:(NSURL *)redirectURL
                                  apiKey:(NSString *)apiKey
                                   token:(NSString *)token DEPRECATED_ATTRIBUTE;

@end
