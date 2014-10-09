//
//  NSString+DFDate.m
//  DOUFoundation
//
//  Created by Candyan on 4/8/13.
//
//

#import "NSString+DFDate.h"
#import "NSDate+DFFormat.h"

@implementation NSString (DFDate)

+ (NSString *)nowDateStringWithDateFormatString:(NSString *)dateFormateString
{
  return [NSString dateStringWithDayIntervalSinceNow:0
                                   dateFormateString:dateFormateString];
}

+ (NSString *)dateStringWithDayIntervalSinceNow:(NSInteger)days
                              dateFormateString:(NSString *)dateFormateString
{
  NSDate *date = ((days == 0)
                  ? [NSDate date]
                  : [NSDate dateWithTimeIntervalSinceNow:days * 24 * 60 * 60]);
  return [date stringWithDateFormatString:dateFormateString];
}

+ (NSString*)formattedMinuteSecondForDuration:(NSTimeInterval)duration
{
  NSInteger minutes = floor(duration / 60);
  NSInteger seconds = round(duration - minutes * 60);
  return [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
}

@end
