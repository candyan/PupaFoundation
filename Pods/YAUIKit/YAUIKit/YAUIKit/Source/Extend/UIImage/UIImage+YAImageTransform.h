//
//  UIImage+YAImageTransform.h
//  YAUIKit
//
//  Created by Candyan on 6/14/13.
//  Copyright (c) 2013 Candyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YAImageTransform)

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScale:(CGFloat)scale;

@end
