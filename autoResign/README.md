# 环境要求:
1. OSX 10.8以上.
2. Xcode8.0以上.

# 使用方式:       
1. 直接在终端运行`autoResign.sh`.
2. 将要需要企业重签名的`ipa`放入`input文件夹`中.
3. 企业重签名后的`ipa`文件会自动放入`output文件夹`中.

# 重要的:
在使用该脚本前您需要确保做了以下几件事:(__P.S.:请看完全文，后面附有文件的详细获取/修改步骤__)
- 配置了企业证书在本地的电脑中(钥匙串中)
- 将您下载的`xx.mobileprovision`放入resign目录中,文件结构如下图`文件结构`所示
- 修改`resign`中`Entitlements.plist`的配置
- 在`resign.config`文件中修改`NEW_MOBILEPROVISION`的值为您的`xx.mobileprovision`
- 在`resign.config`文件中修改`CODESIGN_IDENTITIES`的值为您的`证书名字`

# 如何修改`Entitlements.plist`
  - 假设你的teamID为:`yourTeamID`
  - 假设你的`application-identifier`:为`yourTeamID.com.xxx.xxx`
  - 将`application-identifier`中的`xxx.com.xxx.xxx`改为`yourTeamID.com.xxx.xxx`
  - 将`keychain-access-groups`的中的`xxx.*`改为`yourTeamID.*`


如果看不懂上面说的是什么.
- 将`Entitlements.plist`中的`application-identifier`值改为`xx.mobileprovision`文件中`application-identifier`中对应的值
- 将`Entitlements.plist`中的`keychain-access-groups`的值改为`xx.mobileprovision`文件中`keychain-access-groups`中对应的值

# 如何获取`xx.mobileprovision`
- 登陆你的企业开发者账号，选择`Provisioning Profiles`下的`Distribution`下载`Type`为`iOS Distribution`的`Provisioning Profiles`文件(P.S.:没试过`Type`为`iOS UniversalDistribution`的)

# 如何获取您证书的名字
- 打开电脑中的`Keychain Access`
- 找到您的企业证书，并双击
- 复制证书的中`Common Name`中对应的值

# 如果不想使用自动重签名，可以将`xx.ipa`放在`resign`目录下,并执行脚本`resign.sh`
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


### 在使用过程中如果有任何问题或者改良的方案欢迎提issue和pr.
![wechat_qrcode][wechat_qrcode]

              "5毛一块赞助一下"

<img src="https://mrchens.github.io/images/wechat_reward.JPG" width="120" height="120" align=center />
<img src="https://mrchens.github.io/images/alipay_reward.JPG" width="120" height="120" align=center />
[wechat_qrcode]:https://mrchens.github.io/images/wechat_qrcode.jpg "扫码关注一个很懒的程序员!"
