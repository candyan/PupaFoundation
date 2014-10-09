//
//  NSString+DOUStat.m
//  AmonsulIOS
//
//  Created by wise on 13-3-7.
//  Copyright (c) 2013年 Douban. All rights reserved.
//

#import "NSString+DOUStat.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (DOUStat)

- (NSDictionary *)urlQueryStringToDicInDOUStat
{
  if ([self length] < 1) {
    return nil;
  }
  
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:7];
  
  NSArray *params = [self componentsSeparatedByString:@"&"];
  NSArray *keyAndValue = nil;
  for (NSString *oneParam in params) {
    keyAndValue = [oneParam componentsSeparatedByString:@"="];
    if ([keyAndValue count] == 2) {
      [dic setObject:[(NSString *)[keyAndValue objectAtIndex:1] URLDecodedInDOUStat]
              forKey:[keyAndValue objectAtIndex:0]];
    }
  }
  
  return dic;
}

- (NSString *)URLEncodedInDOUStat
{
  CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
                                                                  NULL,
                                                                  (CFStringRef)self,
                                                                  NULL,
                                                                  (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                  kCFStringEncodingUTF8);
  return (__bridge_transfer NSString *)urlString;
}

- (NSString *)URLDecodedInDOUStat
{
  CFStringRef urlString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                                  NULL,
                                                                                  (CFStringRef)self,
                                                                                  CFSTR(""),
                                                                                  kCFStringEncodingUTF8);
  
  return (__bridge_transfer NSString *)urlString;
}

@end
