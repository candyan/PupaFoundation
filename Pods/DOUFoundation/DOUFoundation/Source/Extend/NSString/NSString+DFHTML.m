//
//  NSString+DTHTML.m
//  DOUFoundation
//
//  Created by Candyan on 4/16/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "NSString+DFHTML.h"

@implementation NSString (DFHTML)

NSString * const kURLRegExString = @"(https?://[a-zA-Z0-9](?:[a-zA-Z0-9]|[\\-\\._~:/\\?#@!\\$&'\\(\\)\\*\\+,;=]|(?:%[0-9a-fA-F][0-9a-fA-F])){3,})";

- (NSArray *)arrayOfLinkRangeString
{
  NSError *error = NULL;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kURLRegExString
                                                                         options:NSRegularExpressionCaseInsensitive error:&error];

  NSMutableArray *linkRangeArray = [NSMutableArray array];
  [regex enumerateMatchesInString:self
                          options:0
                            range:NSMakeRange(0, [self length])
                       usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                         
    [linkRangeArray addObject:NSStringFromRange(result.range)];
  }];
  return linkRangeArray;
}

@end
