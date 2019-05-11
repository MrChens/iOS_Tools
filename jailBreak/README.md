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


# iOS11越狱
## 下载越狱app
- `https://coolstar.org/electra/`下载`Electra1141-1.3.2.ipa`or`https://github.com/coolstar/electra-ipas`
- `https://app.ignition.fun`下载`uncOver.ipa`or`https://github.com/pwn20wndstuff/Undecimus`
- 按照设备系统下载上面对应的清除工具 IPA 安装包，然后通过电脑进行自签名操作
  - ElectraRemover_v1.0 支持 iOS 11.0-iOS 11.1.2 清除工具,去除越狱状态`electraRemover_v1.0.ipa`
  - JB Remover_4.6 支持 iOS 11.2-11.4 清除工具`JB Remover-4.6 (iOS 11.2ï½11.4).ipa`



## 添加frida的软件源
- `https://build.frida.re`,
- 测试是否安装成功,在mac运行`frida-ps -U`

# iOS11，增加iPhoneX的手势
- 下载`Filza iOS11.3.x`


[appsigner]:https://dantheman827.github.io/ios-app-signer
[canjailbreak]:https://canijailbreak.com
