//
//  DOUStatConfig.h
//  AMousulIOS
//
//  Created by wise on 13-2-25.
//  Copyright (c) 2013年 Douban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOUStatConfig : NSObject {
}

@property (nonatomic, assign) BOOL serviceAvailable;

@property (nonatomic, assign) NSInteger intervalSeconds;

+ (DOUStatConfig *)localConfig;
- (void)synchronize;
@end
