//
//  NSAttributedString+PACalculateBound.h
//  PupaDemo
//
//  Created by liuyan on 12/18/15.
//  Copyright © 2015 Douban.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (PACalculateBound)

- (CGRect)boundingRectWithConstraints:(CGSize)size limitedToNumberOfLines:(NSUInteger)lines;

@end
