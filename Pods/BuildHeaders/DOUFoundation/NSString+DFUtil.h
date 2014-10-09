//
//  NSString+DOUUtil.h
//  DOUFoundation
//
//  Created by Jianjun Wu on 6/4/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DFUtil)

- (NSString *)stringByTrimingWhitespace;
- (NSString *)stringByTrimingWhitespaceAndNewline;

- (NSString *)stringByReplacingCharactersInSet:(NSCharacterSet *)set
                                    withString:(NSString *)replacement;

@end
