//
//  PropertyAutoCodingObject.m
//  DoubanRadioCore
//
//  Created by Jianjun Wu on 2/16/12.
//  Copyright (c) 2012 jianjun. All rights reserved.
//

#import "DOUUMAutoCodingObject.h"
#import <objc/runtime.h>

@implementation DOUUMAutoCodingObject

- (void)setObjectValueForIVar:(Ivar)ivar forObject:(id)obj withCoder:(NSCoder *)coder{
  
  NSString *ivarNameStr = [NSString stringWithCString:ivar_getName(ivar) encoding:NSASCIIStringEncoding];
  id value = [coder decodeObjectForKey:ivarNameStr];
  if (value == nil) {
    return;
  }
  object_setIvar(self, ivar, value);
}

- (id)initWithCoder:(NSCoder *)coder {
  
  self = [super init];
  if( self != nil )
  {
    Class clazz = [self class];
    while (clazz) {
      if (clazz == [NSObject class]) {
        break;
      }
      u_int count;
      Ivar* ivars = class_copyIvarList(clazz, &count);
      for (int i = 0; i < count ; i++) {
        [self setObjectValueForIVar:ivars[i] forObject:self withCoder:coder];
      }
      free(ivars);
      clazz = [clazz superclass];
    }
  }
  
  return self;
}

- (id)getObjectValueFromIVar:(Ivar)ivar {
  
  id value = object_getIvar(self, ivar);
  return value;
}

- (void)encodeWithCoder:(NSCoder *)coder {
  
  Class clazz = [self class];
  while (clazz) {
    if (clazz == [NSObject class]) {
      break;
    }
    u_int count;
    Ivar* ivars = class_copyIvarList(clazz, &count);
    for (int i = 0; i < count ; i++)
    {
      NSString *ivarNameStr = [NSString stringWithCString:ivar_getName(ivars[i]) encoding:NSASCIIStringEncoding];
      
      [coder encodeObject:[self getObjectValueFromIVar:ivars[i]]
                   forKey:ivarNameStr];
      
    }
    free(ivars);
    clazz = [clazz superclass];
  }
}

+ (NSData *)archiveObject:(id<NSCoding>)obj {
  return [NSKeyedArchiver archivedDataWithRootObject:obj];
}

+ (id)unarchiveObjectFromData:(NSData *)data {
  return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
