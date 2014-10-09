//
//  NSDate+DFUtil.m
//  DOUFoundation
//
//  Created by alex zou on 13-5-15.
//  Copyright (c) 2013年 Douban Inc. All rights reserved.
//

#import "NSDate+DFUtil.h"

@implementation NSDate (PATimeInterval)

+ (BOOL)isSameDay:(NSDate *)firstDate andDate:(NSDate *)secondDate
{
  return [NSDate daysBetweenDate:firstDate andDate:secondDate] == 0 ? YES : NO;
}

+ (NSInteger)daysBetweenDate:(NSDate *)firstDate andDate:(NSDate *)secondDate
{
  if (firstDate == nil || secondDate == nil) {
    return NSIntegerMax;
  }
  NSCalendar *currentCalendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [currentCalendar components:NSDayCalendarUnit
                                                    fromDate:firstDate
                                                      toDate:secondDate
                                                     options:0];
  NSInteger days = [components day];
  return days;
}

@end
