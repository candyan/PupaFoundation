//
//  NSDictionary+MultipleItems.m
//  DOUFoundation
//
//  Created by Tony Li on 8/30/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "NSDictionary+MultipleItems.h"

@implementation NSDictionary (MultipleItems)

- (id)itemForKey:(id)aKey {
  id obj = [self objectForKey:aKey];
  if ([obj isKindOfClass:[NSArray class]]) {
    return [obj count] > 0 ? [obj objectAtIndex:0] : nil;
  } else {
    return obj;
  }
}

- (NSArray *)allItemsForKey:(id)aKey {
  id obj = [self objectForKey:aKey];
  return [obj isKindOfClass:[NSArray class]] ? obj : (obj ? [NSArray arrayWithObject:obj] : nil);
}

@end
