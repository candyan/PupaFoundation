//
//  NSData+DOUAsyncWrite.m
//  AsyncWriteTest
//
//  Created by Chongyu Zhu on 27/06/2013.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "NSData+DOUAsyncWrite.h"
#include "async_file_write.h"

@implementation NSData (DOUAsyncWrite)

- (void)writeAsynchronousToFile:(NSString *)path
                     atomically:(BOOL)useAuxiliaryFile
                completionBlock:(void (^)(BOOL succeeded))block
{
  NSAssert(path != nil, nil);
  NSAssert(block != NULL, nil);

  block = [block copy];

  NSString *outputPath = path;
  if (useAuxiliaryFile) {
    outputPath = [NSString stringWithFormat:@"%@~", path];
  }

  [[NSFileManager defaultManager] removeItemAtPath:outputPath
                                             error:NULL];
  [[NSFileManager defaultManager] createFileAtPath:outputPath
                                          contents:nil
                                        attributes:nil];

  int fd = open([outputPath UTF8String], O_WRONLY | O_CREAT);
  if (fd == -1) {
    dispatch_async(dispatch_get_main_queue(), ^{
      block(NO);
    });
    return;
  }

  CFDataRef data = CFBridgingRetain(self);
  ftruncate(fd, CFDataGetLength(data));

  async_file_write_setup(fd);
  async_file_write(fd,
                   CFDataGetBytePtr(data),
                   CFDataGetLength(data),
                   dispatch_get_main_queue(),
                   ^(int succeeded, int err) {
                     close(fd);
                     CFBridgingRelease(data);

                     if (useAuxiliaryFile) {
                       [[NSFileManager defaultManager] removeItemAtPath:path
                                                                  error:NULL];
                       [[NSFileManager defaultManager] moveItemAtPath:outputPath
                                                               toPath:path
                                                                error:NULL];
                     }

                     block((BOOL)succeeded);
                   });
}

@end
