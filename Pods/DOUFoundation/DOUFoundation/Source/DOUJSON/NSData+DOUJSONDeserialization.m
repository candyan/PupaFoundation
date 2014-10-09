//
//  NSData+DOUJSONDeserialization.m
//  DOUFoundation
//
//  Created by Chongyu Zhu on 2/10/14.
//  Copyright (c) 2014 Douban Inc. All rights reserved.
//

#import "NSData+DOUJSONDeserialization.h"

@implementation NSData (DOUJSONDeserialization)

- (id)objectFromJSONData
{
  return [NSJSONSerialization JSONObjectWithData:self options:0 error:NULL];
}

- (id)mutableObjectFromJSONData
{
  return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:NULL];
}

@end
