//
//  NSDate+DFFormat.h
//  DOUFoundation
//
//  Created by liu yan on 4/11/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DFFormat)

- (NSString *)stringWithDateFormatString:(NSString *)formateString;

+ (NSDate *)dateWithString:(NSString *)string
           formatterString:(NSString *)formatterString;

@end
