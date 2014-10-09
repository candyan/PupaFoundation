//
//  NSData+DOUMappedFile.h
//  DOUAudioStreamer
//
//  Created by Chongyu Zhu on 11/04/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (DOUMappedFile)

+ (instancetype)dataWithMappedContentsOfFile:(NSString *)path;
+ (instancetype)dataWithMappedContentsOfURL:(NSURL *)url;

+ (instancetype)modifiableDataWithMappedContentsOfFile:(NSString *)path;
+ (instancetype)modifiableDataWithMappedContentsOfURL:(NSURL *)url;

- (void)synchronizeMappedFile;

@end
