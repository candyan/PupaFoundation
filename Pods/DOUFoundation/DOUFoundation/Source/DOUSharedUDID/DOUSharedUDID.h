//
//  DOUSharedUDID.h
//  DOUFoundation
//
//  Created by Candyan on 7/21/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOUSharedUDID : NSObject

/**
 @return : Shared UDID is unique for each App.
 */
+ (NSString *)sharedUDID;

/**
 @return : Shared UDID is unique for Apps with same bundle seed ID.
 */
+ (NSString *)sharedUDIDForDoubanApplications;

+ (NSString *)identifierForVendor;

@end
