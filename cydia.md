# 越狱开发中有用的软件
- OpenSSH:建立ssh连接，记得修改默认root密码(alpine)
    - 安装后可以使用scp
- APT 0.6 Transitional: apt-get包管理工具
- Gawk: 支持awk编程，awk是一种强大的文本处理及模式匹配语言
- Core Utilities (/bin):提供了dirname，kill，mktemp，su
- top:动态查看系统状态，如CPU负载
- inetutils: ping, ftp客户端/服务端
- cURL:
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
- python tcprelay.py -t 2222:2244
- ssh root@ip -p 2222
- scp -P<port> root@<remoteIpAddress>:<remote dir path> <source file path>
- tcpdump -i lo0 -s0 -w xxxx.pcapng //抓lo0接口的包
- ifconfig lo0
- rvictl -s uuid [Getting a Packet Trace]:https://developer.apple.com/library/content/qa/qa1176/_index.html#//apple_ref/doc/uid/DTS10001707-CH1-SECRVI
- sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
- curl - I  "http://ssxxx/hhh.txt"
- wget -c "http://sssxxx/hhh.txt"
- nscurl --ats-diagnostics --verbose https://127.0.0.1:443 //诊断app对于https的plist设置是否正确
- dig cache.default.server.matocloud.com
- telnet 123.103.23.219
- nm //display name list (symbol table)
- dpkg -i xxxx.deb (use apt-get install -f command tries to fix this broken package by installing the missing dependency)
    - https://unix.stackexchange.com/questions/159094/how-to-install-a-deb-file-by-dpkg-i-or-by-apt
- grep -rnw headOutPuts -e 'requestByRemovingPostCheckKey' //查找指定字符串的文件
-otool -l xxxx | grep crypt
# 常用文件路径
- host文件 /private/etc/
- cydia下载的deb文件 /private/var/cache/apt/archives 2014年11月，iOS8越狱后的deb包的变化: /User/Library/Caches/com.saurik.Cydia/archives/

# 自动安装deb文件
- 将deb文件放入/private/var/root/Media/Cydia/AutoInstall,然后重启设备

# 常用的源
- http://apt.saurik.com/
- http://apt.thebigboss.org/repofiles/cydia/


http://www.saurik.com/id/1