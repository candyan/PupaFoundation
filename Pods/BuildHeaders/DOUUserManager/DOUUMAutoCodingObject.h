//
//  PropertyAutoCodingObject.h
//  DoubanRadioCore
//
//  Created by Jianjun Wu on 2/16/12.
//  Copyright (c) 2012 jianjun. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * support object variable
 */
@interface DOUUMAutoCodingObject : NSObject <NSCoding>

+ (NSData *)archiveObject:(id<NSCoding>)obj;
+ (id)unarchiveObjectFromData:(NSData *)data;

@end
