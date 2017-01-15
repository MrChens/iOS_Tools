# 环境要求:
1. OSX 10.8以上.
2. Xcode8.0以上.

# 使用方式:       
1. 直接在终端运行`autoResign.sh`.
2. 将要需要企业重签名的`ipa`放入`input文件夹`中.
3. 企业重签名后的`ipa`文件会自动放入`output文件夹`中.

# 重要的:
在使用该脚本前您需要确保做了以下几件事:
- 配置了企业证书在本地的电脑中(钥匙串中)
- 将您的`Entitlements.plist`,`xx.mobileprovision`放入resign目录中,文件结构如下图所示
- 在`resign.config`文件中配置`Entitlements.plist`文件
- 在`resign.config`文件中修改`NEW_MOBILEPROVISION`的值为您的`xx.mobileprovision`
- 在`resign.config`文件中修改`CODESIGN_IDENTITIES`的值为您的`证书名字`

# 如何获取xx.mobileprovision
- 登陆你的企业开发者账号，选择`Provisioning Profiles`下的`Distribution`下载你的配置文件

# 如何修改`Entitlements.plist`
假设你的teamID为:`yourTeamID`
假设你的`application-identifier`:为`yourTeamID.com.xxx.xxx`
将`keychain-access-groups`的中的`xxx.*`改为`yourTeamID.*`
将`application-identifier`中的`xxx.xxx.xxx.xxx`改为`yourTeamID.com.xxx.xxx`

# 文件结构:
autoResign/
├── README.md
├── autoResign.sh
├── input
├── output
└── resign
    ├── xx.mobileprovision
    ├── Entitlements.plist
    ├── Payload
    ├── resign.config
    └── resign.sh
