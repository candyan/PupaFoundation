//
//  NSString+DOUJSONDeserialization.h
//  DOUFoundation
//
//  Created by Chongyu Zhu on 2/10/14.
//  Copyright (c) 2014 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DOUJSONDeserialization)

- (id)objectFromJSONString;
- (id)mutableObjectFromJSONString;

@end
