//
//  StatEvent.h
//  amonDemo
//
//  Created by tan fish on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


@interface DOUStatEvent : NSObject

@property (nonatomic, copy) NSString *name;  // 事件名称
@property (nonatomic, copy) NSString *date;   // 触发时间
@property (nonatomic, copy) NSString *page;  //对应页面
@property (nonatomic, copy) NSString *action;  //动作
@property (nonatomic, copy) NSString *net;  //联网方式
@property (nonatomic, copy) NSString *label; //标签

@property (nonatomic, copy) NSNumber *longitude;
@property (nonatomic, copy) NSNumber *latitude;

@property (nonatomic, assign) NSInteger count; // 触发次数
@property (nonatomic, copy) NSString *appversion; //记录事件时，App的版本号

- (id)initWithName:(NSString *)name label:(NSString *)label acc:(NSInteger)count;

- (NSMutableDictionary *)toMutableDictionary;
@end
