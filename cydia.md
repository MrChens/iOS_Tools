# 越狱开发中有用的软件
- OpenSSH:建立ssh连接，记得修改默认root密码(alpine)
    - 安装后可以使用scp
- APT 0.6 Transitional: apt-get包管理工具
- Gawk: 支持awk编程，awk是一种强大的文本处理及模式匹配语言
- Core Utilities (/bin):提供了dirname，kill，mktemp，su
- top:动态查看系统状态，如CPU负载
- inetutils: ping, ftp客户端/服务端
- cURL:
- ReRpovision:app自动续签
- tcpdump: 抓包工具
- network Commands: 网络管理工具, ifconfig, netstat, arp, route, traceroute
- readline: 方便命令行移动
    - `ctrl+r` 搜索
    -  `ctrl+a/e` 移动到行首/尾
    -  `ctrl+u/k` 删除到行首/尾
    -  `ctrl+l` 清屏
    - open:通过命令行打开应用
    - ipainstaller: 通过命令行安装ipa应用
    - plutil (com.Erica.Utilities): 支持设备上对plist文件进行操作
    - strings(Binutils): 打印某个文件的可打印字符串，便于了解一些非文本文件的内容。比如可用来查找浏览器Cokkies内容
    - cycript: TBD 通过`ctrl+d`退出
    - AppSync: 安装未经过认证的软件
    # 命令示例子
    - APT 0.6 Transitional
        - apt-cache search <pkg-name> 查找软件包
        - apt-cache show <pkg-name> 显示软件包信息
        - apt-get update 从APT源更新软件包列表
        - apt-get updrade 更新软件包
        - apt-get remove <pkg-name> 删除已安装的软件包
        - apt-get purge <pkg-name> 删除已安装的软件包及配置文件
        - apt-get autoremove 删除不需要的软件包(通常是由于依赖关系而安装)
        - apt-get autoclean 删除已卸载的软件包的.deb档
        - dpkg --get-selections | grep <pkg-name> 搜索已安装的软件包
        - dpkg -s/-L <kg-name> 查看已安装的包信息/路径



# 常用命令行
- `python tcprelay.py -t 2222:2244`
- `uicache //refresh ui`
- `ssh root@ip -p 2222`
- `scp -P<port> root@<remoteIpAddress>:<remote dir path> <source file path>`
- `tcpdump -i lo0 -s0 -w xxxx.pcapng //抓lo0接口的包`
- `ifconfig lo0`
- `rvictl -s uuid [Getting a Packet Trace]:https://developer.apple.com/library/content/qa/qa1176/_index.html#//apple_ref/doc/uid/DTS10001707-CH1-SECRVI`
- `defaults write ~/Desktop/config_Xcode/plistfiletst key value`
- `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`
- `curl - I  "http://ssxxx/hhh.txt"`
- `wget -c "http://sssxxx/hhh.txt"`
- `nscurl --ats-diagnostics --verbose https://127.0.0.1:443 //诊断app对于https的plist设置是否正确`
- `dig cache.default.server.matocloud.com`
- `telnet 123.103.23.219`
- `nm //display name list (symbol table)`
- `dpkg -i xxxx.deb (use apt-get install -f command tries to fix this broken package by installing the missing dependency)`
    - `https://unix.stackexchange.com/questions/159094/how-to-install-a-deb-file-by-dpkg-i-or-by-apt`
- `grep -rnw headOutPuts -e 'requestByRemovingPostCheckKey' //查找指定字符串的文件`
- `otool -l xxxx | grep crypt    // 0为脱过壳`
- `codesign -d --ent :- /path/to/the.app //Inspect the entitlements of a built app`
# 常用文件路径
- `host文件 /private/etc/`
- `cydia下载的deb文件 /private/var/cache/apt/archives 2014年11月，iOS8越狱后的deb包的变化: /User/Library/Caches/com.saurik.Cydia/archives/`

# 自动安装deb文件
- 将deb文件放入/private/var/root/Media/Cydia/AutoInstall,然后重启设备

# 常用的源
- http://apt.saurik.com/
- http://apt.thebigboss.org/repofiles/cydia/
- https://cydia.angelxwind.net/
- http://rpetri.ch/repo/
    - applist
- http://www.saurik.com/id/1
- http://xsf1re.github.io
    -flyjb

# iPhone相关的网站
 - https://www.theiphonewiki.com/wiki/Models
# 越狱可用的网站
1. https://checkra.in
2. https://frida.re/docs/installation/
3.
# 忘记ssh的密码
1. 使用iFiles或者Filza打开'/private/etc/master.password',找到下面这行

        root:xxxxxxxxxxxxx:0:0::0:0:System Administrator:/var/root:/bin/sh
        mobile:xxxxxxxxxxxxx:501:501::0:0:Mobile User:/var/mobile:/bin/sh

2. 将root:及mobile:后面的13个x字符处修改成

        root:/smx7MYTQIi2M:0:0::0:0:System Administrator:/var/root:/bin/sh
        mobile:/smx7MYTQIi2M:501:501::0:0:Mobile User:/var/mobile:/bin/sh
3. 修改后保存此文件，你越狱机的ssh密码就重新回到默认的：'alpine'

# cydia can't access network
1. cd  /var/preferences
2. backup
3. rm -rf com.apple.networkextension.plist
4. rm -rf com.apple.networkextension.cache.plist
5. rm -rf com.apple.networkextension.necp.plist
6. 提醒: 如果你是第一次使用的同学cydia启用网络之后 会搜索到cydia的更新 更新之后 的cydia又会无法联网.请再去删一次 3个文件然后再重启 即可.

# Reveal V4 fix "The operation couldn’t be completed. The app is linked against an older version of the Reveal library. You may need to update the Reveal library in your app."
0. `install Reveal2Loader_1.0-3_iphoneos-arm.deb or put deb in Device/var/root`
1. `copy RevealServer.framework to /Library/Frameworks`
2. `killall SpringBoard`

# ifunbox can see root
1. install "Apple File Conduit "2" (64位)"

# 方便的调试他人app的工具
- flexible
- woodpecker
- lookin

# IPA2Deb
- mkdir tmp
- cd tmp
- mkdir DEBIAN Applications
- touch DEBIAN/control
- vim DEBIAN/control
- 输入如下的文本:
    Package: com.sharedream.test
    Name: test
    Version: 0.1
    Description: test
    Section: test
    Depends: firmware (>= 4.3)
    Priority: optional
    Architecture: iphoneos-arm
    Author: test
    Homepage: test
    Maintainer: test
- cp text.app Applications
- cd ..
- dpkg-deb -b tmp test.deb
- dpkg-scanpackages -m debs >Packages
- bzip2 -zkf Packages

# homebrew
## 中科大镜像
替换brew.git:
cd "$(brew --repo)"
git remote set-url origin https://mirrors.ustc.edu.cn/brew.git

替换homebrew-core.git:
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git

## 阿里镜像

- cd "$(brew --repo)"

- git remote set-url origin https://mirrors.aliyun.com/homebrew/brew.git

- cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"

- git remote set-url origin https://mirrors.aliyun.com/homebrew/homebrew-core.git

## 更新

- brew update
- brew config

## 重置
- cd "$(brew --repo)"
- git remote set-url origin https://github.com/Homebrew/brew.git

- cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
- git remote set-url origin https://github.com/Homebrew/homebrew-core.git

## 更换 homebrew-bottles
- echo $SHELL

- echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles' >> ~/.zshrc

- source ~/.zshrc

- echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles' >> ~/.bash_profile

- source ~/.bash_profile

<!-- end -->
