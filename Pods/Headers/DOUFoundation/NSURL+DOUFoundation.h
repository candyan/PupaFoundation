//
//  NSURL+DOUFoundation.h
//  DOUFoundation
//
//  Created by Tony Li on 8/29/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (DOUFoundation)

/**
 * Returns a one-to-many multiple items NSDictionary.
 * @see `NSDictionary (MultipleItems)` category
 */
- (NSDictionary *)queryDictionary;

@end
