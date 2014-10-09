//
//  NSDictionary+JSON.m
//  AMousulIOS
//
//  Created by wise on 12-12-25.
//  Copyright (c) 2012年 Douban. All rights reserved.
//

#import "NSDictionary+DOUJSON.h"
#import "DOUMobileStatUtils.h"

@implementation NSDictionary (DOUJSON)


- (NSString *)generateJSONStringByJSONSerialization
{
  NSError *error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                     options:0
                                                       error:&error];
  
  if (!jsonData) {
    NSLog(@"Got an error: %@", error);
    return nil;
  } else {
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  }
}

- (NSString *)generateJSONStringForIOS4
{
  return [DOUMobileStatUtils jsonStringWithObject:self];
}

- (NSString *)toJsonStringInDOUStat
{
  id JSONSerializationClass = NSClassFromString(@"NSJSONSerialization");
  if (JSONSerializationClass) {
    return [self generateJSONStringByJSONSerialization];
  } else {
    return [self generateJSONStringForIOS4];
  }
}

@end
