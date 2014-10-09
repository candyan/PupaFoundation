//
//  NSData+DOUAsyncWrite.h
//  AsyncWriteTest
//
//  Created by Chongyu Zhu on 27/06/2013.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (DOUAsyncWrite)

- (void)writeAsynchronousToFile:(NSString *)path
                     atomically:(BOOL)useAuxiliaryFile
                completionBlock:(void (^)(BOOL succeeded))block;

@end
