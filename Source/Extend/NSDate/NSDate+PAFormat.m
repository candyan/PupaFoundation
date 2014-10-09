//
//  NSDate+PAFormat.m
//  PupaFoundation
//
//  Created by Candyan on 4/11/13.
//  Copyright (c) 2013 Candyan. All rights reserved.
//

#import "NSDate+PAFormat.h"

@implementation NSDate (PAFormat)

- (NSString *)stringWithFormat:(NSString *)formatString
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

  NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];
  [formatter setLocale:locale];
  [formatter setTimeZone:[NSTimeZone localTimeZone]];
  
  [formatter setDateFormat:formatString];
  return [formatter stringFromDate:self];
}

+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)formatString
{
  NSDateFormatter * formatter = [[NSDateFormatter alloc] init];

  NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];
  [formatter setLocale:locale];
  [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];

  [formatter setDateFormat:formatString];
  return [formatter dateFromString:string];
}

@end
