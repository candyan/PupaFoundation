//
//  PropertyAutoCodingObject.h
//  DoubanRadioCore
//
//  Created by Jianjun Wu on 2/16/12.
//  Copyright (c) 2012 jianjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUFoundationBase.h"

/**
   Support NSCoding by objc runtime feature.
   This Class is used to help archiving with NSCoding. See the deatil of usage in unit test.
 */
@interface DOUAutoCodingObject : NSObject <NSCoding>

@end

DOU_EXTERN void DOUAutoCodingDecode(NSCoder *coder, id obj);
DOU_EXTERN void DOUAutoCodingEncode(NSCoder *coder, id obj);

/**
 Use this macro to enable auto-coding without extending DOUAutoCodingObject.
 */
#define DOU_AUTO_CODING_IMPL(clazz)\
@interface clazz(__DOUAutoCoding)<NSCoding> \
@end \
@implementation clazz(__DOUAutoCoding) \
- (id)initWithCoder:(NSCoder *)coder { \
if ( (self = [super init]) ) { \
DOUAutoCodingDecode(coder, self); \
} \
return self; \
} \
- (void)encodeWithCoder:(NSCoder *)coder { \
DOUAutoCodingEncode(coder, self);\
} \
@end \
