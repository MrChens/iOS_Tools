# 本工具是用于混淆方法名和类名   
> 改良这个脚本工具的初衷:因为项目中使用JSPatch的热修复功能，然后上架的时候被Apple拒绝了，然后就有了这个混淆的工具。如果你也需要混淆JSPatch那么你可以复用`obfuscation.list`,本人已经通过审核了.
> 使用本脚本做完了混淆后，可以使用github上整理好的上的[class_dump][class_dump]中的工具做.h文件的dump查看混淆的效果.

>建议:理论上来说能混淆任意的字符串，但是出于实用性`obfuscation.list`最好不要放置属性名，我只测试过函数名和类名的混淆，如果有兴趣对其他的字符串做混淆请自行测试。

该工具是由[念茜的iOS安全攻防（二十三）：Objective-C代码混淆](http://blog.csdn.net/yiyaaixuexi/article/details/29201699)为原型做了以下的修改
- 防止生成的随机数有可能重复的问题
- 防止每次编译程序的时候,`codeObfuscation.h`文件都会发生变化而导致的每次编译都要很久的问题

### 使用步骤:
- 将混淆脚本`obfuscated.sh`和需要混淆的函数名/类名表`obfuscation.list`放到工程目录下
- 配置`Build Phase`:在工程`Build Phase`中添加执行脚本操作，执行`obfuscated.sh`如图![BuildPhase][BuildPhase].
- 在`obfuscation.list`中写入需要混淆的方法名和类名，如:   
        @interface JPCore : NSObject    //其中JPCore是需要混淆的类名
        -(void)sample;  
        -(void)seg1:(NSString *)string seg2:(NSUInteger)num;    
        就这样写：   
        JPCore  
        sample  
        seg1    
        seg2
- 脚本执行完了以后会生成一个`codeObfuscation.h`头文件，将此头文件加入`XXX-Prefix.ch`中
        #ifdef __OBJC__  
            #import <UIKit/UIKit.h>  
            #import <Foundation/Foundation.h>  
            //添加混淆作用的头文件（这个文件名是脚本obfuscated.sh中定义的）  
            #import "codeObfuscation.h"  
        #endif  


[BuildPhase]:http://mrchens.github.io/images/article/2017.04/2017-04-17-iOS-Tools-BuildPhase.png
[class_dump]:https://github.com/MrChens/iOS_Tools/tree/master/class_dump
