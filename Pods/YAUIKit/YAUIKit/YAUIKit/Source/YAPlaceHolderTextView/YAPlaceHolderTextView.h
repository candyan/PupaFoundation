//
//  YAPlaceHolderTextView.h
//  YAUIKit
//
//  Created by Candyan on 4/9/13.
//  Copyright (c) 2013 Candyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YAPlaceHolderTextView : UITextView {
  UILabel *_placeHolderLabel;
}

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

@end
