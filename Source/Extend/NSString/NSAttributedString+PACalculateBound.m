//
//  NSAttributedString+PACalculateBound.m
//  PupaDemo
//
//  Created by liuyan on 12/18/15.
//  Copyright © 2015 Douban.Inc. All rights reserved.
//

#import "NSAttributedString+PACalculateBound.h"

@implementation NSAttributedString (PACalculateBound)

- (CGRect)boundingRectWithConstraints:(CGSize)size limitedToNumberOfLines:(NSUInteger)lines
{
    NSDictionary *attributes = [self attributesAtIndex:0 effectiveRange:NULL];
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
                              context:NULL];
}

@end
