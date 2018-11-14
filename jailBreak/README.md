# iPhone越狱步骤

## 1. 查看当前设备是否能越狱
- [canjailbreak][canjailbreak]

## 2. 选取合适的越狱工具
- 从1中的网站点击对应的越狱工具网站

## 3. 下载越狱app
- 从2中的越狱工具网站下载app

## 4. 添加特殊权限
- 比如`Electra`需要`com.apple.developer.networking.multipath`权限
- 创建一个`app identifiers`，并勾选需要的权限`Multipath`
- 创建`AdHoc`的`ProvisioningProfile`

## 4. 使用工具对app进行重签名
- [appsigner][appsigner]

## 5. 将app安装到手机
- Apple Configurator 2
- 同步推
- ideviceinstaller


[appsigner]:https://dantheman827.github.io/ios-app-signer
[canjailbreak]:https://canijailbreak.com
