//
//  NSMutableDictionary+MultipleItems.m
//  DOUFoundation
//
//  Created by Tony Li on 8/30/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "NSMutableDictionary+MultipleItems.h"

@implementation NSMutableDictionary (MultipleItems)

- (void)addItem:(id)item forKey:(id<NSCopying>)aKey {
  id obj = [self objectForKey:aKey];
  NSMutableArray *array = nil;
  if ([obj isKindOfClass:[NSArray class]]) {
    array = [NSMutableArray arrayWithArray:obj];
  } else {
    array = obj ? [NSMutableArray arrayWithObject:obj] : [NSMutableArray array];
  }
  [array addObject:item];
  [self setObject:[array copy] forKey:aKey];
}

@end
