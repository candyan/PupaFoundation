//
//  NSString+DOUDigest.m
//  DOUFoundation
//
//  Created by Chongyu Zhu on 10/04/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "NSString+DOUDigest.h"
#import "NSData+DOUDigest.h"

@implementation NSString (PADigest)

- (NSString *)md5
{
  return [[self dataUsingEncoding:NSUTF8StringEncoding] md5];
}

- (NSString *)sha1
{
  return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1];
}

- (NSString *)sha256
{
  return [[self dataUsingEncoding:NSUTF8StringEncoding] sha256];
}

- (NSString *)sha512
{
  return [[self dataUsingEncoding:NSUTF8StringEncoding] sha512];
}

@end
