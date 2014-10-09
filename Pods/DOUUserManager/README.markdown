## 用户管理组件说明文档 ##

### * 功能说明
* 管理用户的当前账户信息
* 维护用户的多账号信息
* 为用户提供默认的文件目录和基本管理
* 为原有的账号信息提供升级接口
* 应用之间共享帐号

### * 常见的使用方式
* 单帐号使用：添加帐号->删除帐号->添加帐号->...
* 多帐号使用：可添加多个帐号
* 为原有帐号升级：提供了迁移的接口，方便原有的帐号信息可以迁移

### * 使用说明

#### 添加帐号信息
      
	  NSString * userId = self.userInputView.userIdField.text;
	  NSString * name = self.userInputView.userNameField.text;
	  
	  if (userId.length > 0 && name.length > 0) {
	    AppUser * aUser = [[AppUser alloc] init];
	    aUser.userID = userId;
	    aUser.userName = name;
	    
	    DOUBasicAccount * account = [[DOUBasicAccount alloc] init];
	    account.userUUID = userId;
	    account.userInfo = aUser;
	    [[DOUAccountManager sharedInstance] addAccount:account];
	  }	  	  


#### 获取帐号信息

	// 所有帐号信息
    NSArray * arr = [[DOUAccountManager sharedInstance] allAccounts];
	// 当前的帐号信息
	DOUBasicAccount * account = [[DOUAccountManager sharedInstance] currentActiveAccount];


#### 更新帐号信息

	  NSString * userId = self.userInputView.userIdField.text;
	  NSString * name = self.userInputView.userNameField.text;
	  
	  if (userId.length > 0 && name.length > 0) {
	    AppUser * aUser = [[AppUser alloc] init];
	    aUser.userID = userId;
	    aUser.userName = name;
	    
	    DOUBasicAccount * account = [[DOUBasicAccount alloc] init];
	    account.userUUID = userId;
	    account.userInfo = aUser;
	    [[DOUAccountManager sharedInstance] updateAccount:account];
	  }

#### 删除帐号信息

    NSArray * arr = [[DOUAccountManager sharedInstance] allAccounts];
    DOUBasicAccount * account = [arr objectAtIndex:indexPath.row];
    [[DOUAccountManager sharedInstance] deleteAccount:account];

#### 共享帐号

##### 共享帐号的用处

获取到其他应用的共享帐号信息后，可以使用该帐号的 access token 来交换对应用户在自己应用下的 access token，这个过程不需要用户手动的输入用户名密码登录。

__注意__：需要保证两个应用的 API key 都在 exchange_token 的白名单中，代码见[这里](http://code.dapps.douban.com/redhorn/blob/master/auth/views/auth2/__init__.py)。

##### 如何与其他 App 共享帐号

* 使用 DOUUserManager 1.1 及之后的版本。
* 在应用的 entitlements 文件的 Keychain Access Group 中增加 `$(AppIdentifierPrefix)com.douban.DOUSharedAccount`。
* 在应用的 Info.plist 文件中增加 `URL Identifier` 为 `DOUAccountManager` 的 URL Scheme，并填写有效的 scheme。
* 为 DOUBasicAccount 的实现者增加 DOUSharedAccount 协议。具体请参见头文件中的注释。
* 保证你的应用的 API key 在[服务端代码](http://code.dapps.douban.com/redhorn/blob/master/auth/views/auth2/__init__.py)的白名单中。

完成上述步骤后，应用保存的帐号信息即可与其他 App 共享。

同时，你可以通过 `-[DOUAccountManager sharedAccounts]` 获得设备中保存的共享帐号信息（包括当前应用自己的）。

##### 示例

    __block NSString *token = nil;
    NSDictionary *sharedAccounts = [[DOUAccountManager sharedInstance] sharedAccounts];
    [sharedAccounts enumerateKeysAndObjectsUsingBlock:^(NSString *appId, NSArray *accounts, BOOL *stop) {
      if (![appId isEqualToString:[[NSBundle mainBundle] bundleIdentifier]]) {
        for (DOUCommonAccount *account in accounts) {
          token = account.oAuthToken;
          *stop = YES;
          break;
        }
      }
    }];

    [[DOUOAuthClient sharedInstance] fetchAccessTokenWithExchangeToken:token success:^(DOUOAuth *oauth) {
      // Got our own oauth info.
    } failure:^(DOUError *error) {
      DOULogDebug(@"fetch token error: %@", error);
    }];

#### 其他

	// 设置当前的帐号信息
	[[DOUAccountManager sharedInstance] setCurrentAccountByUUID:@"1000010"];
	// 两个迁移数据的方法
	- (BOOL)migrateAccountLagacyDataWithBlock:(DOUBasicAccount * (^)(void))migrationBlock;
	- (BOOL)migrateMultipleAccountsOfLagacyDataWithBlock:(NSArray * (^)(NSString ** currentAccountUUID))migrationBlock;

	
更多代码可见Demo项目：DOUUserManagerDemo

### * 发布历史
目前属于开发版本

### * 计划
* 存储当前版本的版本号，便于在版本升级的时候升级信息
* 添加Demo项目

### * 功能设计
![alt 功能设计图](http://code.dapps.douban.com/DOUUserManager/raw/master/docs/design/DOUUserManageDesign.png)










