//
//  DOUAppDescription.m
//  DoubanObjCClient
//
//  Created by Candyan on 12/28/12.
//  Copyright (c) 2012 Douban Inc. All rights reserved.
//

#import "DOUAppDescription.h"

static DOUAppDescription * myInstance = nil;

@implementation DOUAppDescription
@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize appRedirectURL = _appRedirectURL;

+ (DOUAppDescription *)currentAppDescription {
  return myInstance;
}

- (id)initWithAppKey:(NSString *)appKey
           appSecret:(NSString *)appSecret
      appRedirectURL:(NSString *)appRedirectURL {
  self = [super init];
  if (self) {
    _appKey = appKey;
    _appSecret = appSecret;
    _appRedirectURL = appRedirectURL;
  }
  return self;
}

+(void)setAppDescriptionWithAppKey:(NSString *)appkey
                         appSecret:(NSString *)appSecret
                    appRedirectURL:(NSString *)appRedirectURL {
  @synchronized(self) {
    if (myInstance) {
      myInstance.appKey = appkey;
      myInstance.appSecret = appSecret;
      myInstance.appRedirectURL = appRedirectURL;
    } else {
      myInstance = [[DOUAppDescription alloc] initWithAppKey:appkey appSecret:appSecret appRedirectURL:appRedirectURL];
    }
  }
}

@end
