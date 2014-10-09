//
//  DOUThreadSpecificData.m
//  DOUFoundation
//
//  Created by Chongyu Zhu on 21/05/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "DOUThreadSpecificData.h"
#include <pthread.h>

@interface DOUThreadSpecificData () {
@private
  pthread_key_t _tsdKey;
}
@end

@implementation DOUThreadSpecificData

+ (instancetype)sharedData
{
  static DOUThreadSpecificData *sharedData = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedData = [[DOUThreadSpecificData alloc] init];
  });

  return sharedData;
}

static void destruct_tsd(void *data)
{
  if (data == NULL) {
    return;
  }

  CFRelease((CFTypeRef)data);
}

- (id)init
{
  self = [super init];
  if (self) {
    pthread_key_create(&_tsdKey, destruct_tsd);
  }

  return self;
}

- (void)dealloc
{
  pthread_key_delete(_tsdKey);
}

- (NSMutableDictionary *)_tsd
{
  void *data = pthread_getspecific(_tsdKey);
  if (data == NULL) {
    CFMutableDictionaryRef dict = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                                            0,
                                                            &kCFTypeDictionaryKeyCallBacks,
                                                            &kCFTypeDictionaryValueCallBacks);
    data = (void *)dict;
    pthread_setspecific(_tsdKey, data);
  }

  return (__bridge NSMutableDictionary *)data;
}

- (id)objectForKey:(id)aKey
{
  return [[self _tsd] objectForKey:aKey];
}

- (void)setObject:(id)anObject forKey:(id <NSCopying>)aKey
{
  [[self _tsd] setObject:anObject forKey:aKey];
}

- (id)objectForKeyedSubscript:(id)key
{
  return [[self _tsd] objectForKeyedSubscript:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
  [[self _tsd] setObject:obj forKeyedSubscript:key];
}

@end
