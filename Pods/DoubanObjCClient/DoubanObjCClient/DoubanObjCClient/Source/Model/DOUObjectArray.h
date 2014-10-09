//
//  DOUObjectArray.h
//  DoubanApiClient
//
//  Created by Lin GUO on 4/25/12.
//  Copyright (c) 2012 Douban Inc. All rights reserved.
//

#import "DOUObject.h"

@interface DOUObjectArray : DOUObject

@property (nonatomic, readonly) NSInteger count;
@property (nonatomic, readonly) NSInteger start;
@property (nonatomic, readonly) NSInteger total;

@property (nonatomic, readonly) NSArray  *objectArray;

+ (Class)objectClass;
+ (NSString *)objectName;

@end

@interface DOUObjectArray (Deprecated)

+ (id)arrayWithObjectArray:(NSArray *)objArray DEPRECATED_ATTRIBUTE;

@end
