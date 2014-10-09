//
//  DOUAutoCodingObject
//
//  Created by Jianjun Wu on 2/16/12.
//  Copyright (c) 2012 jianjun. All rights reserved.
//

#import "DOUAutoCodingObject.h"
#import <objc/runtime.h>

@implementation DOUAutoCodingObject

- (id)initWithCoder:(NSCoder *)coder
{
  self = [super init];
  if (self != nil) {
    DOUAutoCodingDecode(coder, self);
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
  DOUAutoCodingEncode(coder, self);
}

@end

void DOUAutoCodingDecode(NSCoder *coder, id obj) {
  Class clazz = [obj class];
  while (clazz) {
    if (clazz == [NSObject class]) {
      break;
    }
    u_int count;
    Ivar *ivars = class_copyIvarList(clazz, &count);
    for (int i = 0; i < count; i++) {
      Ivar ivar = ivars[i];
      NSString *ivarNameStr = [NSString stringWithCString:ivar_getName(ivar) encoding:NSASCIIStringEncoding];
      id value = [coder decodeObjectForKey:ivarNameStr];
      if (value) {
        object_setIvar(obj, ivar, value);
      }
    }
    free(ivars);
    clazz = [clazz superclass];
  }
}

void DOUAutoCodingEncode(NSCoder *coder, id obj) {
  Class clazz = [obj class];
  while (clazz) {
    if (clazz == [NSObject class]) {
      break;
    }
    u_int count;
    Ivar *ivars = class_copyIvarList(clazz, &count);
    for (int i = 0; i < count; i++) {
      NSString *ivarNameStr = [NSString stringWithCString:ivar_getName(ivars[i]) encoding:NSASCIIStringEncoding];
      [coder encodeObject:object_getIvar(obj, ivars[i])
                   forKey:ivarNameStr];
    }
    free(ivars);
    clazz = [clazz superclass];
  }
}
