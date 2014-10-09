//
//  DOUAccountManager.h
//  DOUAccountManager
//
//  Created by Jianjun Wu on 3/26/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUBasicAccount.h"

extern NSString *const kDOUAMAccountListDidChangeNotification;
extern NSString *const kDOUAMCurrentAccountDidChangeNotification;
extern NSString *const kDOUCurrentAccountDidLogoutNotification;

extern NSString *const kDOUAMNotificationInfoKeyAccount;

@interface DOUAccountManager : NSObject

+ (id)sharedInstance;

#pragma mark - Current account management method
- (id<DOUBasicAccount>)currentActiveAccount;
- (void)setCurrentAccount:(id<DOUBasicAccount>)account;
- (BOOL)setCurrentAccountByUUID:(NSString *)accountUUID;
- (BOOL)addCurrentAccount:(DOUBasicAccount * )account;
- (void)logoutCurrentAccount;
- (void)logoutCurrentAccountAndSwitchNextAccount:(BOOL)flag;

#pragma mark - Account CRUD methods
- (BOOL)addAccount:(id<DOUBasicAccount>)account;
- (BOOL)deleteAccount:(id<DOUBasicAccount>)account;
- (BOOL)updateAccount:(id<DOUBasicAccount>)account;
- (NSArray *)allAccounts;
- (void)removeAllAccounts;
- (BOOL)isExistAccount:(id<DOUBasicAccount>)account;

#pragma mark - Shared Accounts

/**
 * 获得设备中的共享帐号。
 *
 * 返回的 NSDictionary 中键为帐号所属应用的 ID，值为该应用共享的帐号数组，数组元素为
 * DOUCommonAccount 对象。
 */
- (NSDictionary *)sharedAccounts;

#pragma mark - Account related paths
- (NSString *)documentBaseDirForAccount:(id<DOUBasicAccount>)account;
- (NSString *)tmpFileBaseDirForAccount:(id<DOUBasicAccount>)account;

#pragma mark - Account lagacy migration method
- (BOOL)migrateAccountLagacyDataWithBlock:(id<DOUBasicAccount> (^)(void))migrationBlock;
- (BOOL)migrateMultipleAccountsOfLagacyDataWithBlock:(NSArray * (^)(NSString ** currentAccountUUID))migrationBlock;

@end
