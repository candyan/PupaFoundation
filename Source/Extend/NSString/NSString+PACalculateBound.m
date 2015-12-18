//
//  NSString+PACalculateBound.m
//  PupaDemo
//
//  Created by liuyan on 12/18/15.
//  Copyright © 2015 Douban.Inc. All rights reserved.
//

#import "NSString+PACalculateBound.h"

@implementation NSString (PACalculateBound)

- (CGRect)boundingRectWithConstraints:(CGSize)size
                           attributes:(NSDictionary *)attributes
               limitedToNumberOfLines:(NSUInteger)lines
{
    UIFont *font = attributes[NSFontAttributeName];
    if (lines != 0 && font != nil) {
        size.height = lines * font.lineHeight;

        NSMutableParagraphStyle *ps = attributes[NSParagraphStyleAttributeName];
        if (ps != nil) {
            size.height += lines * ps.lineSpacing;
        }
    }
    return [self boundingRectWithSize:size
                              options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin |
                                       NSStringDrawingUsesFontLeading)
                           attributes:attributes
                              context:NULL];
}

@end
