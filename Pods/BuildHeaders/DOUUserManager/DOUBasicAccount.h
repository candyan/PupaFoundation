//
//  DOUBasicAccount.h
//  DOUUserManager
//
//  Created by Jianjun Wu on 3/26/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DOUUMAutoCodingObject.h"

@protocol DOUBasicAccount <NSObject, NSCoding>
- (NSString *)userUUID;
- (BOOL)isValidAccount;
@end

@interface DOUBasicAccount : DOUUMAutoCodingObject <DOUBasicAccount>
@property (nonatomic, copy, readonly) NSString * userUUID; // 用户的UUID
- (id)initWithUserUUID:(NSString *)userUUID;
@end

@interface DOUCommonAccount : DOUBasicAccount

@property (nonatomic, copy, readwrite) NSString * userName;
@property (nonatomic, copy, readwrite) NSString * oAuthToken;
@property (nonatomic, strong, readwrite) id<NSCoding> userInfo;

@end

/**
 * DOUBasicAccount 实现者可以通过实现此协议来与设备中 App ID prefix 一致的应用共享帐号。
 */
@protocol DOUSharedAccount <NSObject>

/**
 * 返回 App 间共享帐号的信息。
 *
 * 注意：返回的对象必须为 `DOUCommonAccount` 类型，不可以为它的子类。同时，`userInfo` 属性
 * 将会设置为包含下列键的 `NSDictionary` 对象：
 *
 * - `kDOUSharedAccountUserInfoKeyAppID`
 * - `kDOUSharedAccountUserInfoKeyAppName`
 * - `kDOUSharedAccountUserInfoKeyAppURLScheme`
 *
 */
- (DOUCommonAccount *)sharedAccount;

@end

/// 共享帐号所属 App 的 Application ID。
extern NSString * const kDOUSharedAccountUserInfoKeyAppID;

/// 共享帐号所属 App 的名称。
extern NSString * const kDOUSharedAccountUserInfoKeyAppName;

/// 共享帐号所属 App 的 URL scheme。
extern NSString * const kDOUSharedAccountUserInfoKeyAppURLScheme;
