//
//  NSDictionary+DOUJSONSerialization.m
//  DOUFoundation
//
//  Created by Chongyu Zhu on 2/10/14.
//  Copyright (c) 2014 Douban Inc. All rights reserved.
//

#import "NSDictionary+DOUJSONSerialization.h"

@implementation NSDictionary (PAJSONSerialization)

- (NSData *)JSONData
{
  return [NSJSONSerialization dataWithJSONObject:self options:0 error:NULL];
}

- (NSString *)JSONString
{
  NSData *data = [self JSONData];
  if (data == nil) {
    return nil;
  }

  return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
