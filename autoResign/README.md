# 1. 环境要求:


1.	OSX 10.8以上.
2.	Xcode8.0以上.

# 2. 使用方式:

1.	直接在终端运行`aUtoReSiGn.sh`.
2.	将要需要企业重签名的`ipa`放入`input文件夹`中.
3.	企业重签名后的`ipa`文件会自动放入`output文件夹`中.
4.	默认情况下重签名的是Distribution版的，如需重签名`Development`版的请修改`resign.config`中的`GET_TASK_ALLOW`为`true`
5. 如若不需要自动重签名，请直接运行`resign.sh`脚本
6. 如若需要自动安装`ipa`到手机上，请修改`resign.config`中的`AUTO_INSTALL_IPA`为`true`

# 3. 重要的:

在使用该脚本前您需要确保做了以下几件事:

 **P.S.:请看完全文后再配置，后面附有文件的详细获取/修改步骤** Development和Distribution的区别在于Development的重签名是可以`get-task-allow`

 ## 3.1 Development配置

 -	配置`Development`的企业证书在本地的电脑中(钥匙串中)
 -	将您下载的`Development`版的`xx.mobileprovision`放入`resign`目录中并重命名为`EnterPrise_Development.mobileprovision`,文件结构如下图`文件结构`所示
 -	修改`resign`中`Entitlements/developer/Entitlements.plist`的配置
 -	在`resign.config`文件中修改`CODESIGN_IDENTITIES_DEV`的值为您`Development`版的企业证书名字

## 3.1 Distribution配置

-	配置`Distribution`的企业证书在本地的电脑中(钥匙串中)
-	将您下载的`Distribution`版的`yy.mobileprovision`放入`resign`目录中并重命名为`EnterPrise_Distribution.mobileprovision`,文件结构如下图`文件结构`所示
-	修改`resign`中`Entitlements/production/Entitlements.plist`的配置
-	在`resign.config`文件中修改`CODESIGN_IDENTITIES`的值为您`Distribution`版的企业证书名字

## 3.2 如何修改对应的`Entitlements.plist`

-	假设你的`teamID`为:`yourTeamID`
-	假设你的`application-identifier`:为`yourTeamID.com.xxx.xxx`
-	将`application-identifier`中的`yyyy.com.xxx.xxx`改为`yourTeamID.com.xxx.xxx`
-	将`keychain-access-groups`的中的`yyyy.*`改为`yourTeamID.*`

如果看不懂上面说的是什么鬼.
- Development配置
	- 将`Entitlements/developer/Entitlements.plist`中的`application-identifier`的值，改为`EnterPrise_Development.mobileprovision`文件中`application-identifier`中对应的值
	- 将`Entitlements/developer/Entitlements.plist`中的`keychain-access-groups`的值，改为`EnterPrise_Development.mobileprovision`文件中`keychain-access-groups`中对应的值

-	Distribution配置
	-	将`Entitlements/production/Entitlements.plist`中的`application-identifier`的值，改为`EnterPrise_Distribution.mobileprovision`文件中`application-identifier`中对应的值
	-	将`Entitlements/production/Entitlements.plist`中的`keychain-access-groups`的值，改为`EnterPrise_Distribution.mobileprovision`文件中`keychain-access-groups`中对应的值

## 3.3 如何获取对应的`xx.mobileprovision`

-	Development
	-	登陆你的企业开发者账号，选择`Provisioning Profiles`下的`Development`下载`Type`为`iOS Development`的`Provisioning Profiles`文件(P.S.:没试过`Type`为`iOS UniversalDistribution`的)
-	Distribution
	-	登陆你的企业开发者账号，选择`Provisioning Profiles`下的`Distribution`下载`Type`为`iOS Distribution`的`Provisioning Profiles`文件(P.S.:没试过`Type`为`iOS UniversalDistribution`的)

## 3.4 如何获取您证书的名字
-	Development
	-	打开电脑中的`Keychain Access`
	-	找到您的`Development`企业证书，并双击
	-	复制证书`Common Name`中对应的值到`resign.config`的`CODESIGN_IDENTITIES_DEV`
-	Distribution
	-	打开电脑中的`Keychain Access`
	-	找到您的`Distribution`企业证书，并双击
	-	复制证书`Common Name`中对应的值到`resign.config`的`CODESIGN_IDENTITIES`

## 3.5 如何使用自动安装重签名后的ipa到手机
- 先使用数据连接线将手机和Mac连接
- 修改`resign.config`中的`AUTO_INSTALL_IPA`为`true`
- 运行`aUtoReSiGn.sh`脚本

### 如果不想使用自动重签名，可以将`xx.ipa`放在`resign`目录下,并执行脚本`resign.sh`

---

# 文件结构:


```
aUtoReSiGn
│   ├── README.md
│   ├── aUtoReSiGn.sh
│   └── resign
│       ├── EnterPrise_Development.mobileprovision
│       ├── EnterPrise_Distribution.mobileprovision
│       ├── Entitlements
│       │   ├── developer
│       │   └── production
│       ├── certificate.png
│       ├── provisioning\ profiles.png
│       ├── resign.config
│       └── resign.sh
```

### 在使用过程中如果有任何问题或者改良的方案欢迎提issue和pr.

<img src="https://mrchens.github.io/images/wechat_qrcode.jpg" width="120" height="120" align=left /><!-- <img src="https://mrchens.github.io/images/wechat_reward.JPG" width="120" height="120" align=right /><img src="https://mrchens.github.io/images/alipay_reward.jpg" width="120" height="120" align=right /> -->
