//
//  DOUMobileStatImp+Network.h
//  AmonsulIOS
//
//  Created by Jianjun Wu on 3/10/13.
//  Copyright (c) 2013 Douban. All rights reserved.
//

#import "DOUMobileStatImp.h"

@interface DOUMobileStatImp (Network)

- (void)syncSendEventRequest:(DOUStatEvent *)event;

- (void)sendEventRequest:(DOUStatEvent *)event
                 inQueue:(NSOperationQueue *)quque;

- (void)sendEventsInFile:(NSString *)filePath
                 inQueue:(NSOperationQueue *)quque
                 succeed:(void (^)())succeedBlock
                 failure:(void (^)())failureBlock;


- (NSString *)generateRequestUrl;

@end
