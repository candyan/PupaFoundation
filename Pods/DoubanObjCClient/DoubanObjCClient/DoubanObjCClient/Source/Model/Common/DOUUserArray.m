//
//  DOUUserArray.m
//  DoubanObjCClient
//
//  Created by Candyan on 1/10/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "DOUUserArray.h"
#import "DOUUser.h"

@implementation DOUUserArray

+(Class)objectClass {
  return [DOUUser class];
}

+(NSString *)objectName {
  return @"users";
}

@end
