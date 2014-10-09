//
//  AmonsulConnection.h
//  amonDemo
//
//  Created by tan fish on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AmonsulConnection;

extern const NSTimeInterval kAmonsuleNetworkTimeout;

@interface AmonsulConnection : NSObject

@property (nonatomic, copy) NSString *requestURL;
@property (nonatomic, strong, readonly) NSMutableData *buf;

- (void)  get:(NSString *)urlPath
  queryParams:(NSDictionary *)params
        async:(BOOL)isAsync
      succeed:(void (^)(AmonsulConnection *conn))completedBlock
      failure:(void (^)(AmonsulConnection *conn))failureBlock;

- (void)post:(NSString *)aURL
        body:(NSString *)body
       async:(BOOL)isAsync
     succeed:(void (^)(AmonsulConnection *conn))completedBlock
     failure:(void (^)(AmonsulConnection *conn))failureBlock;

- (void)post:(NSString *)aURL
       async:(BOOL)isAsync
     succeed:(void (^)(AmonsulConnection *conn))completedBlock
     failure:(void (^)(AmonsulConnection *conn))failureBlock;

- (void)sendRequeset:(NSURLRequest *)request
               async:(BOOL)isAsync
             succeed:(void (^)(AmonsulConnection *conn))completedBlock
             failure:(void (^)(AmonsulConnection *conn))failureBlock;

- (NSString *)fecthResponseString;

- (NSData *)responseData;

@end
