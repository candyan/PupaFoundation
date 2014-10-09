//
//  NSMutableDictionary+Client.m
//  DoubanObjCClient
//
//  Created by Candyan on 1/10/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "NSMutableDictionary+DOUObjCClient.h"

@implementation NSMutableDictionary (DOUObjCClient)

- (void) setParamterStart:(NSInteger)start count:(NSInteger)count {
  [self setObject:[NSNumber numberWithInteger:start] forKey:@"start"];
  [self setObject:[NSNumber numberWithInteger:count] forKey:@"count"];
}

@end
