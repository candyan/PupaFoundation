//
//  NSDictionary+MultipleItems.h
//  DOUFoundation
//
//  Created by Tony Li on 8/30/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MultipleItems)

/**
 * Return the first item of array for the specificed key.
 *
 * -[NSDictionary objectForKey:] will return an object or an array depending on
 * how the NSDictionary is created.
 */
- (id)itemForKey:(id)aKey;

/**
 * Return a NSArray object which contains all the items for specificed key.
 *
 * -[NSDictionary objectForKey:] will return an object or an array depending on
 * how the NSDictionary is created.
 */
- (NSArray *)allItemsForKey:(id)aKey;

@end
