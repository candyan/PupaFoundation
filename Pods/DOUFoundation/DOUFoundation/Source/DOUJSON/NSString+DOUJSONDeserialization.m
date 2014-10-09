//
//  NSString+DOUJSONDeserialization.m
//  DOUFoundation
//
//  Created by Chongyu Zhu on 2/10/14.
//  Copyright (c) 2014 Douban Inc. All rights reserved.
//

#import "NSString+DOUJSONDeserialization.h"
#import "NSData+DOUJSONDeserialization.h"

@implementation NSString (PAJSONDeserialization)

- (id)objectFromJSONString
{
  return [[self dataUsingEncoding:NSUTF8StringEncoding] objectFromJSONData];
}

- (id)mutableObjectFromJSONString
{
  return [[self dataUsingEncoding:NSUTF8StringEncoding] mutableObjectFromJSONData];
}

@end
