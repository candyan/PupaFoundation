
[豆瓣 API]: http://developers.douban.com/
[豆瓣Wiki API]: http://svn.douban.com/projects/shire/wiki/api
[DoubanObjCClinet]: http://code.dapps.douban.com/DoubanObjCClient

#[DoubanObjCClinet] 介绍

**DoubanObjCClient** 是一个 Objective－C 实现的 豆瓣 API 客户端，支持 iOS 和 MAc。

更多信息请查询 **[豆瓣 API]** **[豆瓣Wiki API]**

### 欢迎使用pods 安装Clinet

## 如何配置?

#### 1.DoubanObjCClient

将 `DoubanObjCClient.xcodeproj` 图标拖拽到你的项目文件目录中。

#### 2.设置项目 Building Settings

点击 `项目` -> `(TARGETS)` 图标，在 `Build Settings` 里找到 `Other Linker Flags`, 设置为 `-ObjC`。

#### 3.设置目标 Building Settings

同上，找到 Header Search Paths，添加

* ../DoubanObjCClient/DoubanObjCClient/Library
* ../DoubanObjCClient/DoubanObjCClient/Source

###### TIPS :
以上的两个目录可以是相对目录也可以是绝对目录，需要自行配置。参考 Example，这里将 DoubanObjCClient 项目文件直接拷贝到了 Demo 项目平行的目录。

#### 4.添加依赖

点击目标(TARGETS)图标，选择 `Building Phases`。

在 `Target Dependencies`，添加 `DoubanObjCClient`。

在 `Link Binary with Libaries` 中，加入下列库 `libDoubanObjCClient.a`

在 `Link Binary with Libaries` 中, 加入依赖 `security.framework`

##### TIPS:

请添加`DOUFoundation`依赖，并参考DOUFoundation的配置方法。

## 如何使用?
可以参考 Example，比如，获得用户信息：

	#import "DOUObjCClient.h"
	#import "DOUObjCClient+User.h"

	DOUAPIClient *client = [DOUAPIClient sharedInstance];

	[client getUser:@"ahbei" success:^(DOUUser *theUser){
    	self.user = theUser;
    	[self updateUI];
    }failure:^(DOUError *errro) {
    	NSLog(@"error msg:%@", error);
    }];

###### TIPS 
1. 在使用Client发送请求之前，要确认设置了Client的基本信息。
		
		[DOUAPIClient setAppDescriptionWithAppKey:yourAppKey
                                        appSecret:yourAppSecret
                                   appRedirectURL:yourAppRedirectURL];
                                   
2. 如需使用外部的OAuth，可以调用:
		
		[DOUAPIClient setOAuth:yourOAuth]; //会存储到keychain中

                                  
上述两个方法都为全局设置，无需在每次实例化Client时都设置。

## ChangeLog
##### v1.1.3
- 增加了DOUPushRegisterClient 用来注册推送设备

##### v1.1.1
- 去除了ifv参数
- fix project file warning : build active architecture only
- 去除DOUOAuthClient中的 defaultParamters 方法实现
- 增加新方法 addDefaultParameters:

##### v1.1.0
- 增加了Cocoapod支持
- 增加了http body JSON format的支持
- Deprecated old reuqestBlock 使用了 新的Block名称
- DOUAPIRequestOperation中增加了responseString字段。

##### v1.0.0
- 第一次发布正式版本
- 统一使用keychain存储OAuth，并且可以单独管理OAuth。
- 提供迁移v0.1.x版本存储OAuth的方法。
- 移除了多余的API和Model文件
- 更新AFNetworking到1.3.1版本

######TIPS：无特殊需求请不要使用以下版本。

##### v0.3.1

- 使用了DOUFoundation中的DOUSharedUDID做为设备的唯一标识。

##### v0.3.0
- AFNetworking更新到最新版本。
- 支持ARC。所以不再支持ios5.0以下。

###### Branch v0.2.x，支持iOS 5.0以下。

##### v0.2.0
- 除去了DOUOAuthManager中管理OAuth的功能。
- 除去了Client compile source中的JSONKit.m

##### v0.1.3
- Remove property doubanAFClient in DOUAPIClient
- Extract common header and default parmaters into private category:DOUAPIClient+Private.h

##### v0.1.2

- 增加了User Agent，格式为: "api-client/版本号 包名/版本(版本号) 系统版本 机器型号"
    
##### v0.1.1

- 加入了KeyChain来存储用户OAuth信息。 

##### v0.1.0

- 第一次发布稳定版本 
