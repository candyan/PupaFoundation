//
//  DOUAPIClient+Shuo.h
//  DoubanObjCClient
//
//  Created by GUO Lin on 12/23/12.
//  Copyright (c) 2012 Douban Inc. All rights reserved.
//

#import "DOUAPIClient.h"
#import "DOUAPIConstant.h"

@interface DOUAPIClient (Shuo)

- (void)postShuoStatusesWithText:(NSString *)text
                       imageData:(NSData *)imageData
                     attachments:(NSString *)attachments
                      objectKind:(NSString *)objectKind
                     actionProps:(NSString *)actionProps
                         success:(void(^)())successBlock
                         failure:(DOUAPIRequestFailErrorBlock)failureBlock;;

@end
