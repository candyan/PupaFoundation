//
//  NSDate+DFFormat.m
//  DOUFoundation
//
//  Created by Candyan on 4/11/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "NSDate+DFFormat.h"

@implementation NSDate (PAFormat)

- (NSString *)stringWithDateFormatString:(NSString *)formateString
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

  NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];
  [formatter setLocale:locale];
  [formatter setTimeZone:[NSTimeZone localTimeZone]];
  
  [formatter setDateFormat:formateString];
  return [formatter stringFromDate:self];
}

+ (NSDate *)dateWithString:(NSString *)string
           formatterString:(NSString *)formatterString
{
  NSDateFormatter * formatter = [[NSDateFormatter alloc] init];

  NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];
  [formatter setLocale:locale];
  [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];

  [formatter setDateFormat:formatterString];
  return [formatter dateFromString:string];
}

@end
