//
//  NSMutableDictionary+MultipleItems.h
//  DOUFoundation
//
//  Created by Tony Li on 8/30/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (MultipleItems)

/**
 * Add an item to the array for the specificed key.
 */
- (void)addItem:(id)item forKey:(id<NSCopying>)aKey;

@end
