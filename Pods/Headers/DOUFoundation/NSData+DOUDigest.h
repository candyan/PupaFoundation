//
//  NSData+DOUDigest.h
//  DOUFoundation
//
//  Created by Chongyu Zhu on 10/04/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (DOUDigest)

- (NSString *)md5;
- (NSString *)sha1;
- (NSString *)sha256;
- (NSString *)sha512;

@end
