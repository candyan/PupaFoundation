//
//  PACommonFunctions.h
//  PupaDemo
//
//  Created by liuyan on 14-4-17.
//  Copyright (c) 2014年 Douban.Inc. All rights reserved.
//

#ifndef PupaDemo_PACommonFunctions_h
#define PupaDemo_PACommonFunctions_h

#ifndef PALocalString(__KEY)
#define PALocalString(__KEY) NSLocalizedString(__KEY, nil)
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
#ifndef IF_IOS7_OR_GREATER(...)
#define IF_IOS7_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1) \
{ \
__VA_ARGS__ \
}
#endif
#else
#ifndef IF_IOS7_OR_GREATER(...)
#define IF_IOS7_OR_GREATER(...)
#endif
#endif


#endif
