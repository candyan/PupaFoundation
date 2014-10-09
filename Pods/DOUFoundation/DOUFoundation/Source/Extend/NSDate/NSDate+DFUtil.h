//
//  NSDate+DFUtil.h
//  DOUFoundation
//
//  Created by alex zou on 13-5-15.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (PATimeInterval)

+ (BOOL)isSameDay:(NSDate *)firstDate andDate:(NSDate *)secondDate;
+ (NSInteger)daysBetweenDate:(NSDate *)firstDate andDate:(NSDate *)secondDate;

@end
