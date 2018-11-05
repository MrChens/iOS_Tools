# 有空去研究一下(~~永远都没有空~~)
- 让自己写的库也能使用尖括号来引用
    - http://stackoverflow.com/questions/749027/how-to-add-a-global-include-path-for-xcode
    - http://stackoverflow.com/questions/3162030/difference-between-angle-bracket-and-double-quotes-while-including-heade
    - http://stackoverflow.com/questions/1044360/import-using-angle-brackets-and-quote-marks

- ARC相关
    - https://fuller.li/posts/memory-management-arc/#retainable-object-pointers

- ConfiguringYourApp
    - https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/ConfiguringYourApp/ConfiguringYourApp.html

- crul
    - https://ec.haxx.se/

- Debug/Hack
    - `Xtrace` 让它支持64位的
    - `itracker`

- 修改`Webview`中获取`title`和`url`的方式
将js获取的方式改为https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/DisplayWebContent/Tasks/LocationChanges.html#//apple_ref/doc/uid/20002027-CJBEHAAG 中提到的几个代理方案，为以后将webview切换到wkwebview做准备。
- 获取手机安装的`app`列表:https://github.com/lanvsblue/AppBrowser

- `iOS`也试试使用`jekins`？还是用现在的自动打包脚本？使用`jekins`可能说以后用`xpms`就能实现打包的发布的动作。
- 调试时打印视图层次
	- http://blog.csdn.net/duanyipeng/article/details/50523018

- apple的标记
    - https://developer.apple.com/library/content/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html
- iOS加固
    - http://www.blogfshare.com/ios-protect.html
    - http://www.cocoachina.com/ios/20170324/18955.html
- 好用的工具
 fauxpas 静态分析工具
	- http://blog.csdn.net/duanyipeng/article/details/50523018

- 中间人攻击:`mitmproxy`
    - http://docs.mitmproxy.org/en/stable/install.html
    - https://blog.heckel.xyz/2013/07/01/how-to-use-mitmproxy-to-read-and-modify-https-traffic-of-your-phone/
    - 针对iOS10系统需要在设置->通用->关于本机->证书信任设置->开启针对根证书启用完全信任
- 中间人攻击:`SSLsplit`
    - http://www.roe.ch/SSLsplit
    - https://blog.heckel.xyz/2013/08/04/use-sslsplit-to-transparently-sniff-tls-ssl-connections/

-  使用`AVAssetResourceLoaderDelegate`来实现播放器的缓冲以及设置代理的局限性
    - http://msching.github.io/blog/2016/05/24/audio-in-ios-9/
- 开启未定义行为监测
    - https://developer.apple.com/documentation/code_diagnostics/undefined_behavior_sanitizer/enabling_the_undefined_behavior_sanitizer

- 文档处理
    - https://www.gnu.org/software/gawk/manual/gawk.html
- 网络数据抓包处理(命令行工具，可以用脚本来)
    - https://www.wireshark.org/docs/man-pages/tshark.html

- `Xcode`打包
    - https://developer.apple.com/library/content/technotes/tn2339/_index.html#//apple_ref/doc/uid/DTS40014588-CH1-MY_APP_HAS_MULTIPLE_BUILD_CONFIGURATIONS__HOW_DO_I_SET_A_DEFAULT_BUILD_CONFIGURATION_FOR_XCODEBUILD_
- 隐藏符号表
    - https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/CppRuntimeEnv/CPPRuntimeEnv.html#//apple_ref/doc/uid/TP40001675-SW1
