//
//  DOUAPIClient+Private.h
//  DoubanObjCClient
//
//  Created by Jianjun Wu on 4/23/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "DOUAPIClient.h"

@interface DOUAPIClient (Private)

- (void)addUserAgentHeaderToClient;

- (void)handleClientError:(DOUError *)error
              handleBlock:(DOUAPIRequestFailErrorBlock)handleBlock;

@end
