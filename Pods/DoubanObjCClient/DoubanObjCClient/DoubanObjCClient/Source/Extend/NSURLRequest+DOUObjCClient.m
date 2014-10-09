//
//  NSURLRequest+Douban.m
//  DoubanAPIClient
//
//  Created by Candyan on 12/10/12.
//  Copyright (c) 2012 Douban. All rights reserved.
//

#import "NSURLRequest+DOUObjCClient.h"
#import "DOUAPIConstant.h"

@implementation NSURLRequest (DOUObjCClient)

+(NSURLRequest *)requestWithRedirectURL:(NSURL *)redirectURL
                                 apiKey:(NSString *)apiKey
                                  token:(NSString *)token {
  NSString *requestPath = [NSString stringWithFormat:@"%@%@?url=%@&apikey=%@", kDoubanSiteBaseURL, @"accounts/auth2_redir", [self encodingStringUsingURLEscape:redirectURL.absoluteString], apiKey];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestPath]];
  [request setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
  [request setHTTPShouldHandleCookies:YES];
  return request;
}

+ (NSString *) encodingStringUsingURLEscape:(NSString *)string
{
  return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", kCFStringEncodingUTF8);
}

@end
