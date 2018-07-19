# 导出头文件操作流程文档

[class-dump](http://stevenygard.com/projects/class-dump/)

[砸壳(破解)工具](https://github.com/stefanesser/dumpdecrypted.git)

### 砸壳时遇见如下
    dyld: could not load inserted library 'dumpdecrypted.dylib' because no suitable image found. Did find:
    dumpdecrypted.dylib: required code signature missing for 'dumpdecrypted.dylib'

    security find-identity -v -p codesigning
    codesign --force --verify --verbose --sign "iPhone Developer: xxx xxxx (xxxxxxxxxx)" dumpdecrypted.dylib

### 本目录下已经预先放置好了需要使用的工具，如果不能使用请从上面的网址去download新的工具来。

从App Store下载的ipa是需要先砸壳然后再使用`class-dump`才能导出头文件.
如果是自己打包的企业app直接把ipa解压后的xx.app用`class-dump`就能导出头文件.

### 针对App Store下载的ipa进行的`class-dump`(需要越狱的设备)   
  - 先从ituness上下载xxx.ipa
  - 然后将ipa安装到越狱的手机中
  - 将`dumpdecrypted.dylib`拷贝到手机的`(iOS8)/var/mobile/Containers/Data/Application/xxx-xxx/Documents`目录下，在iOS7中是`/var/mobile/Applications/xxx-xxx/Documents`
  - iOS8然后再cd到3中的目录下执行:`DYLD_INSERT_LIBRARIES=dumpdecrypted.dylib /var/mobile/Containers/Bundle/Application/xxx-xxx/yyy.app/yyy`
  iOS7然后再cd到3中的目录下执行:`DYLD_INSERT_LIBRARIES=dumpdecrypted.dylib /var/mobile/Applications/xxx-xxx/yyy.app/yyy`
  - 然后就会生成`yyy.decrypted`
  - 使用`scp`将`yyy.decrypted`传输到电脑上
  - `./class-dump -H yyy.decrypted -o outputs`
  - 然后就能在`outputs`中看到导出的头文件

### 针对不需要砸壳的ipa进行的class-dump(不需要越狱的设备)    
  - 将xxx.ipa解压到`class-dump`同个目录下，然后使用下面的命令将头文件导出到`outputs`目录下:
  - `./class-dump -H xx.app -o  outputs`
  - 然后就能在`outputs`中看到导出的头文件


### 在使用过程中如果有任何问题或者改良的方案欢迎提issue和pr.

