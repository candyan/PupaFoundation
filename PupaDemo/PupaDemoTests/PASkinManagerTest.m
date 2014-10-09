//
//  PASkinManagerTest.m
//  PupaDemo
//
//  Created by liuyan on 14-3-17.
//  Copyright (c) 2014年 Douban.Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PASkinManager.h"

@interface PASkinManagerTest : XCTestCase

@end

@implementation PASkinManagerTest
{
  PASkinManager *_skinManager;
}

- (void)setUp
{
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  _skinManager = [[PASkinManager alloc] initWithSkinName:nil];
}

- (void)testSkinManagerCreate
{
  XCTAssertNotNil(_skinManager, @"Skin Manager is nil.");
  XCTAssertTrue([_skinManager.skinName isEqualToString:@"DefaultSkin"], @"Skin Name is incorrect!");
}

- (void)testSkinManagerGetResource
{
  UIFont *defaultFont = [_skinManager fontForTag:nil];
  UIColor *defaultColor = [_skinManager colorForTag:nil];
  UIImage *image = [_skinManager imageWithName:@"ic_navi_back"];

  XCTAssertNotNil(defaultColor, @"Skin Manager color for tag is nil.");
  XCTAssertNotNil(defaultFont, @"Skin Manager Font for tag is nil.");
  XCTAssertNotNil(image, @"Skin Manager should have ic_navi_back image!");
  XCTAssertTrue([defaultFont.fontName isEqualToString:@"Helvetica"], @"Skin Manager Font Name is incorrect!");
  XCTAssertTrue(defaultFont.pointSize == 15.0f, @"Skin Manager Font size is incorrect!");
}

- (void)tearDown
{
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

@end
