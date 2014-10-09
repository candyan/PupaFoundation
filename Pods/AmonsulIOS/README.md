iOS豆瓣移动统计工具 - AmonSul For iOS
=====================================

维护人 ： Jianjun (jianjun@douban.com)   Zou Cong (zoucong@douban.com)
                                               

1.功能简述
-------
1. 统计设备的数量
2. 按渠道统计应用使用的状况
3. 加入用户id跟踪用户行为
4. 默认为启动发送所有数据

详细的策略见：[wiki](http://svn.douban.com/projects/shire/wiki/DeptMobile/MobileAnalytics)

2.配置
---------
* ** 设置App的API Key和App Name, 用于向服务器注册 **

  名称的格式：{AppName}_{iPad/iPhone/iOS}, 举例：Group_iPhone

######TIPS:
* `v1.4.0版本之后` 使用DOUFoundation中的DOUSharedUDID做为device ID的取值。DOUSharedUDID使用了Keychain做为UDID的共享方式。相关的配置方法请参考：[DOUFoundation README](http://code.dapps.douban.com/DOUFoundation/blob/master/README.md)

3.使用方式
---------

##### 常见问题提醒 #####

1. 注意一定要在 application:didFinishLaunchingWithOptions设置统计SDK</font>
2. 在 App 启动的时候(也在didFinishLaunch中)需要设置用户信息，而不仅仅是在初次登录的时候</font>
3. 如果同时使用 UMeng 和 AmonSul, 请使用类库中的DOUEventLogger

##### 具体使用步骤 #####

第一步 在“(BOOL)application:didFinishLaunchingWithOptions:”完成两件事：

    * 设置AmonSul的appKey,appName,strategy,channel
    [DOUMobileStat startWithAppkey:appKey
                   			appName:appName                  				    		userUID:@11111111];
    * 更换登录的"豆瓣用户数字ID"
    [DOUMobileStat bindUserUID:@11111111 token:@"dsadsadsagg"];

第二步 记录事件的两种方式

  	* [DOUMobileStat event:@"homepage"]; // 记录事件

  	* [DOUMobileStat event:@"homepage" label:@"refresh"];

第三步 在用户登录的时候

  * 绑定用户[DOUMobileStat bindUser:userUUID token:@"dsadsadsagg"];


第四步 在用户登出的时候

  * 调用解绑用户的方法 [DOUMobileStat unBindUser]


4.版本历史
---------
` 重要: 更新版本时记得更新version号 lib/AmonsulIOS/Source/Core/DOUStatConstant.h中的宏DOU_STAT_SDK_VERSION`

v1.6.1 2014/2/26
* 使用 App 之间公用的 udid

v1.6.0 2014/2/11
* 增加 Google Analytics

v1.5.1 2013/11/14
* 更新Umeng到2.2.1

v1.5.0 2013/11/14
* 去除了important类型的数据记录
* 去除了strategy，只支持默认的strategy
* 通过check2的API获取上传间隔

v1.4.2 2013/10/12
* Remove feature : crash report 
* Remove some category method

v1.4.1 2013/8/1
* Update Doufoundation : DOUSharedUDID改进

v1.4.0 2013/7/26

* 使用DOUSharedUDID
* 增加了请求url的参数 : did=xxx

v1.3.6 更新记录 : bugfix : 设置Event的net属性

v1.3.5 更新记录 : [NSLocale currentLocale]中NSLocaleCountryCode的value为nil会导致crash

更多版本历史见: release_notes.md

