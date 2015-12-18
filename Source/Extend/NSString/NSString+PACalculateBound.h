//
//  NSString+PACalculateBound.h
//  PupaDemo
//
//  Created by liuyan on 12/18/15.
//  Copyright © 2015 Douban.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PACalculateBound)

- (CGRect)boundingRectWithConstraints:(CGSize)size
                           attributes:(NSDictionary *)attributes
               limitedToNumberOfLines:(NSUInteger)lines;

@end
