//
//  DOUHelpClient.h
//  DoubanObjCClient
//
//  Created by liu yan on 1/17/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "DOUAPIClient.h"

/**
 DoubanHelpClient class declares an object that call douban help api over http or https.
 */
@interface DOUHelpClient : DOUAPIClient

///---------------------------------------------
/// @name Creating and Initializing Douban Help API Clients
///---------------------------------------------

/**
 Creates and initializes an `DOUHelpClient` object with base url: http://help.douban.com/
 
 @return The newly-initialized Douban help API client
 */
+(DOUHelpClient *) sharedInstance;

///---------------------------------------------
/// @name Feed back API
///---------------------------------------------

/**
 Post a feedback to help server.
 
 @param userID is user's douban id  who post feedback.if userID is nil, it's a anonymous.
 @param content is the feedback content.
 @param qtype determine that which app the feedback belong to.
 @param baseInformation include some system information.eg: system version / app version / network / device version and so on.
 
 @discussion the qtype support keys —— '11':'小组 for Android', '12':'小组 for iPhone', '13':'广播 for Android', '14':'广播 for iPhone','21':'阅读 for Android', '22':'阅读 for iPhone', '23':'阅读 for iPad', '24':'笔记 for iPhone', '31':'FM for Android', '32':'FM for iPhone', '33':'FM for iPad', '34':'FM for WindowsPhone', '35':'FM for Symbian'
 
 */
-(void) postFeedbackWithUserID:(NSString *)userID
                       content:(NSString *)content
                         qtype:(NSString *)qtype
               baseInformation:(NSString *)baseInformation
                       success:(void (^)(BOOL success))successBlock
                       failure:(DOUAPIRequestFailErrorBlock)failureBlock;

@end
