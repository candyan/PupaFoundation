//
//  DOUThreadSpecificData.h
//  DOUFoundation
//
//  Created by Chongyu Zhu on 21/05/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOUThreadSpecificData : NSObject

+ (instancetype)sharedData;

- (id)objectForKey:(id)aKey;
- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey;

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

@end
