//
//  DOUDebugUtilities.h
//  DOUFoundation
//
//  Created by Chongyu Zhu on 21/05/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUFoundationBase.h"
#import "DOULogger.h"
#include <mach/mach_time.h>

#ifdef DEBUG
#if TARGET_IPHONE_SIMULATOR
#define DOUBreak(cond) do { if (cond) __asm__("int3"); } while (0)
#else /* TARGET_IPHONE_SIMULATOR */
#define DOUBreak(cond) do { if (cond) __asm__("trap"); } while (0)
#endif /* TARGET_IPHONE_SIMULATOR */
#else /* DEBUG */
#define DOUBreak(cond) ((void)0)
#endif /* DEBUG */

DOU_EXTERN double kDOUAbsoluteTimeConversion;

#define ___DOU_CONCAT___(a, b) a ## b
#define ___DOU_CONCAT(a, b) ___DOU_CONCAT___(a, b)
#define ___DOU_UNIQUE(a) ___DOU_CONCAT(a, __LINE__)

#ifdef DEBUG
#define DOUTimeProfilerPerform(block) do { uint64_t ___DOU_UNIQUE(_begin) = mach_absolute_time(); block(); double elapsedTime = kDOUAbsoluteTimeConversion * (mach_absolute_time() - ___DOU_UNIQUE(_begin)); DOULog(@"elapsed time: %.6f", elapsedTime); } while (0)
#else /* DEBUG */
#define DOUTimeProfilerPerform(block) ((void)0)
#endif /* DEBUG */
