//
//  DOUMobileStatImp+ServiceAvailable.h
//  AmonsulIOS
//
//  Created by Jianjun Wu on 3/10/13.
//  Copyright (c) 2013 Douban. All rights reserved.
//

#import "DOUMobileStatImp.h"

@interface DOUMobileStatImp (ServiceAvailable)

- (void)sendRequestServiceAvailable;
- (BOOL)isServiceAvailable;

@end
