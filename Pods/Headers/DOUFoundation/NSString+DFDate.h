//
//  NSString+DFDate.h
//  DOUFoundation
//
//  Created by liu yan on 4/8/13.
//
//

#import <Foundation/Foundation.h>

@interface NSString (DFDate)

///----------------------------
/// Create Date String
///----------------------------
+ (NSString *)nowDateStringWithDateFormatString:(NSString *)dateFormateString;
+ (NSString *)dateStringWithDayIntervalSinceNow:(NSInteger)days dateFormateString:(NSString *)dateFormateString;
+ (NSString *)formattedMinuteSecondForDuration:(NSTimeInterval)duration;

@end
