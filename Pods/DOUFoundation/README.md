DOUFoundation 说明文档
------------------


### 主要功能 ###

DOUFoundation是豆瓣内部对Foundation类库的扩展，主要包含对String,Number,Date,JSON,Encryption等的扩展。

### TIPS ###
- 在使用DOUSharedUDID时，需要在Targets->YourTarget->Summary->Entitleiments中添加Keychain Groups `com.douban.DOUSharedUDID`。

### 这里已经有什么？ ###

- NSString和NSDate的转换()NSDate+DFFormat,NSString+DFDate)
- URL字符串编解码(NSString+DFURLEscape)
- md5和sha1校验(NSString+DOUDigest.h)
- DOUAutoCodingObject ： 基于objc runtime技术实现自动NSCoding
- 网络状态监测(DOUNetworkReachability)
- JSONKit
- DOULogger : Logger工具类，支持文件存储
- 基于mmap实现的内存文件映射：NSData+DOUMappedFile
- DOUSharedUDID : 使用Keychain来保存UDID


### 版本历史 ###
0.2.1

- 增加 App 之间共享的 UDID 方法 : [DOUSharedUDID sharedUDIDForDoubanApplications]

0.1.3 2014/1/2 

- DOULogger bugfix
- 设定 timezone 为 Shanghai/Asia
- 增加了CI自动化
