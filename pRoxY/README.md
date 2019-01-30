
# 代理使用指南
## 背景
因较多CP的测试人员或开发人员不具备抓包能力，且获取uuid的办法较复杂，每次根据CP的专业程度可能需花费2-3h用以指导CP操作.所以弄了这个代理使用指南，旨在减少和CP的沟通成本.
## 使用步骤
### 1. 给手机设置代理
> 以下描述都是在Wi-Fi环境下进行的
#### iPhone
- 打开`设置`--->`无线局域网`--->点击你所连接的Wi-Fi里的感叹号--->`HTTP代理`--->`手动`--->在`服务器`中输入`deafchen.com`--->在`端口`中输入`8080`
- 如果不懂请百度/谷歌:`iPhone如何设置代理`
- 友情链接:[iPhone设置代理][iPhone proxy]

#### Android
- 如果不懂请百度/谷歌:`Android设置代理`
- 友情链接:[Android设置代理][Android proxy]

### 2. 给手机安装根证书
- 使用手机自带的浏览器打开这个网站[网址][certSite]链接:http://mitm.it
- 点击对应的图标就行下载，比如iPhone的手机就点击那个苹果的图标
- 友情链接:[参考链接1][mitmproxy en],[参考链接2][mitmproxy zh].(PS:仅看如何安装证书部分就行，从有苹果，Android的图标开始)
- 如果你的iOS系统是大于等于10.3的还需点击`设置`--->`通用`--->`关于本机`--->`证书信任设置`--->把`mitmproxy`开关打开弄成绿色的就行

### 3.到这里您的工作已经完成了，这时候联系QA人员等待他们下一步安排(如果等不及，可以自己完成下面4这个的操作)

### 4.上面的设置好以后，建议用电脑浏览器打开[查看界面][proxy GUI]
> 流程是这样子的:`查看界面`连接正常没问题，再打开app

- 打开手机上要测试的app，等待5秒(主要是等它触发SDK的`getBaseConfigInfo`的请求)
- 如果在`查看界面`的右上角显示了红色的`connection lost`或者没有页面显示出来,请刷新一下页面如果还是不行，请联系我方人员
- 在`查看界面`这里的`Search`框框中输入`~u getBaseConfigInfo`
  - `~u getBaseConfigInfo`解释:`~u`是对`url`进行匹配,`getBaseConfigInfo`是匹配`url`中含有`getBaseConfigInfo`
- 点击最后一条符合搜索条件的请求，这时在右边会显示请求相关的参数(如果对显示格式有要求可选择View:auto中进行调整)
- 复制这些参数给测试人员就行
- 友情提示：如若对`mitmproxy`不了解的话请误乱点，否则可能不可预料的问题，增加沟通测试的成本

## 进阶使用指南
> 以上是给CP使用的教程，以下是给我方的Server开发&QA人员的指南

### QA人员
- 过滤log:在[查看界面][proxy GUI]中点击`Options`--->勾选`Display Event Log`，然后再去掉`info`，`web`,`warn`的显示等级，就留下`error`的(因为打印的就是`error`级别的`log`,量少),则能看到上面的那头牛，每个请求的`host`为`base.micro.server.matocloud.com`都会打印一次
-
- `Time`，参数表示该log打印的时间，可以和cp那的app发起请求的时间有大致的对应关系
- `Request`请求相关的，可以用来查看是否是感兴趣的url
- `param`请求带上来的参数，这里的就是我们想要的东西

### Server开发
- 部署该代理GUI界面的大致步骤
- 下载安装`mitmweb`[installation][mitmproxy doc]
- 下载安装`caddy`[installation][caddy doc](也可以使用nginx)：用来将外网的访问代理到内网的`mitmweb`中
- 安装`screen`:应该也可以不用
- 编辑配置`Caddyfile`文件:注意使用`nginx`需要配置`websocket`的代理(没用过nginx可能需要自己去google一下)
```
      http://deafchen.com:8083 {
        proxy / http://127.0.0.1:8081 {
        websocket
        header_upstream -Origin
        }
      }
```

- 编辑配置`matocloud_proxy.py`
```
      """
      This example shows two ways to redirect flows to another server.
      """
      from mitmproxy import http
      from mitmproxy import ctx
      import time

      def request(flow: http.HTTPFlow) -> None:
      # pretty_host takes the "Host" header of the request into account,
      # which is useful in transparent mode where we usually only have the IP
      # otherwise.
      if flow.request.pretty_host == "base.micro.server.matocloud.com":
        ctx.log.error('''
      --------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/
                ||----w |
                ||     ||

      Time: %s
      Request:%s
      param:%s
      --------------------------------\n''' % (time.strftime('%Y.%m.%d %H:%M:%S',time.localtime(time.time())), flow.request, flow.request.text))
```

- 先运行`caddy -conf Caddyfile &`


## 可配合使用的选项
- 1. 配合`screen`使用
    -   运行`SCREEN -S mitmproxy ./mitmweb --set web_port=8081 --set block_global=false -s matocloud_proxy.py`

- 2. 配合`crontab`使用
    - 将目录下的`crontabScript.sh`拷贝到`matocloud_proxy.py`同目录下,
    - 运行`crontab -e`
    - 输入`2 */1 * * * /root/sourceCode/mitmproxy/mitmproxy-4.0.4-linux/crontabScript.sh >/dev/null 2>&1`用来防止`mitmweb`挂掉后没人去重启
    - 输入`3 */1 * * * /root/sourceCode/mitmproxy/mitmproxy-4.0.4-linux/mitmproxy.sh >/dev/null 2>&1`让`mitmproxy.sh`脚本
### 关于`screen`的用法

- [crontab][crontab]
- [screen][screen]
- [screen trik][screen trik]


### 关于`crontab`的用法

- [crontab1][crontab1]
- [crontab2][crontab2]



















[crontab]:https://crontab.guru
[crontab1]:https://www.ibm.com/support/knowledgecenter/zh/ssw_aix_71/com.ibm.aix.cmds1/crontab.htm
[crontab2]:http://einverne.github.io/post/2017/03/crontab-schedule-task.html
[iPhone proxy]:https://jingyan.baidu.com/article/dca1fa6f620442f1a4405202.html
[Android proxy]:https://jingyan.baidu.com/article/fd8044faebfaa85030137a72.html
[certSite]:http://mitm.it
[mitmproxy en]:https://mrchens.github.io/2017/07/05/mitmproxy-for-iOS-app-usage
[mitmproxy zh]:https://www.jianshu.com/p/032eb87aa7e0
[proxy GUI]:http://deafchen.com:8083
[mitmproxy doc]:https://docs.mitmproxy.org/stable/overview-installation/
[caddy doc]:https://github.com/mholt/caddy
[screen]:https://linux.cn/article-8215-1.html
[screen trik]:https://www.ibm.com/developerworks/cn/linux/l-cn-screen/index.html
