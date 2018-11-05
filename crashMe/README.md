# app崩溃时排查步骤
> 在app崩溃时所生成的`.crash`文件，默认情况下该文件显示的都是十六进制数无法分析。所以我们需要对这些文件进行分析。
## 需要的工具:
- `Xcode`
- `app`崩溃时生成的`.crash`文件,可通过`Xcode`--> `Window`--> `Devices and Simulators`--> `View Device Logs`从iPhone中提取出来
- `dsym`文件(符号表文件)
- `symbolicatecrash`(可通过执行`find /Applications/Xcode.app/ -name symbolicatecrash`找到该文件的所在位置)

## 使用方式:
1. 打开`.crash`文件找到其中的`uuid`
2. 找到对应的`dysm`文件.(可通过`dwarfdump --uuid xxx.dsym`查看`uuid`是否和1的一致)
3. 将`.crash`,`dysm`,`symbolicatecrash`这3个文件放在同一个文件夹下方便处理
4. 执行命令`./symbolicatecrash xxxx.crash xxxx.dSYM/ > output.crash`就可以看到符号化以后的崩溃堆栈信息
5. 若报错`Error: "DEVELOPER_DIR" is not defined at ./symbolicatecrash`，则在终端执行一次后面的命令`export DEVELOPER_DIR="/Applications/XCode.app/Contents/Developer"`，然后再执行一次`4`的命令.

ps:最后生成的`.crash`文件只会解析当前项目的代码，其余的还是十六进制数据

## 实际操作
1. 从`iPhone`中获取`wspxDemo  2018-11-5, 2-42 PM.crash.crash`文件如下(只保留需要的关键信息)


    Incident Identifier: 211AB31B-F097-47DC-83ED-3AC6B05A1F7A
    CrashReporter Key:   991cabc05f20cb4812ea851d9b4c57cf7b9c00c2
    Hardware Model:      iPhone10,3
    Process:             wspxDemo [1214]
    Path:                /private/var/containers/Bundle/Application/DF7AAB28-9FF0-4EA1-99EC-C50EB87C16B5/wspxDemo.app/wspxDemo
    Identifier:          com.chinanetcenter.UOne
    Version:             2222 (22.22.222)
    Code Type:           ARM-64 (Native)
    Role:                Foreground
    Parent Process:      launchd [1]
    Coalition:           com.chinanetcenter.UOne [738]

    Date/Time:           2018-11-05 14:42:17.6018 +0800
    Launch Time:         2018-11-05 14:42:17.3303 +0800
    OS Version:          iPhone OS 12.1 (16B5089b)
    Baseband Version:    3.11.00
    Report Version:      104

    Exception Type:  EXC_CRASH (SIGABRT)
    Exception Codes: 0x0000000000000000, 0x0000000000000000
    Exception Note:  EXC_CORPSE_NOTIFY
    Triggered by Thread:  0

    Application Specific Information:
    abort() called

    Last Exception Backtrace:
    (0x1dcfcfea0 0x1dc1a1a40 0x1dcede054 0x102ceb9b4 0x209fda3c8 0x209fdbb30 0x209fe157c 0x20987ea18 0x209887698 0x20987e694 0x20987f034 0x20987d134 0x20987cde0 0x209881fa0 0x209882f00 0x209881e58 0x209886d44 0x209fdfa74 0x209bca088 0x1dfa049d4 0x1dfa0f79c 0x1dfa0ee94 0x1dca0a484 0x1dc9e13f0 0x1dfa43a9c 0x1dfa43728 0x1dfa43d44 0x1dcf601cc 0x1dcf6014c 0x1dcf5fa30 0x1dcf5a8fc 0x1dcf5a1cc 0x1df1d1584 0x209fe3328 0x102cebaf0 0x1dca1abb4)

    Thread 0 name:  Dispatch queue: com.apple.main-thread
    Thread 0 Crashed:
    0   libsystem_kernel.dylib        	0x00000001dcb67104 0x1dcb44000 + 143620
    1   libsystem_pthread.dylib       	0x00000001dcbe6998 0x1dcbe0000 + 27032
    2   libsystem_c.dylib             	0x00000001dcabed78 0x1dca67000 + 359800
    3   libc++abi.dylib               	0x00000001dc188f78 0x1dc187000 + 8056
    4   libc++abi.dylib               	0x00000001dc189120 0x1dc187000 + 8480
    5   libobjc.A.dylib               	0x00000001dc1a1e48 0x1dc19b000 + 28232
    6   libc++abi.dylib               	0x00000001dc1950fc 0x1dc187000 + 57596
    7   libc++abi.dylib               	0x00000001dc195188 0x1dc187000 + 57736
    8   libdispatch.dylib             	0x00000001dca0a498 0x1dc9a9000 + 398488
    9   libdispatch.dylib             	0x00000001dc9e13f0 0x1dc9a9000 + 230384
    10  FrontBoardServices            	0x00000001dfa43a9c 0x1df9f8000 + 309916
    11  FrontBoardServices            	0x00000001dfa43728 0x1df9f8000 + 309032
    12  FrontBoardServices            	0x00000001dfa43d44 0x1df9f8000 + 310596
    13  CoreFoundation                	0x00000001dcf601cc 0x1dceb4000 + 704972
    14  CoreFoundation                	0x00000001dcf6014c 0x1dceb4000 + 704844
    15  CoreFoundation                	0x00000001dcf5fa30 0x1dceb4000 + 703024
    16  CoreFoundation                	0x00000001dcf5a8fc 0x1dceb4000 + 682236
    17  CoreFoundation                	0x00000001dcf5a1cc 0x1dceb4000 + 680396
    18  GraphicsServices              	0x00000001df1d1584 0x1df1c6000 + 46468
    19  UIKitCore                     	0x0000000209fe3328 0x2096fc000 + 9335592
    20  wspxDemo                      	0x0000000102cebaf0 0x102ce4000 + 31472
    21  libdyld.dylib                 	0x00000001dca1abb4 0x1dca1a000 + 2996

    Thread 1:
    0   libsystem_pthread.dylib       	0x00000001dcbeece8 0x1dcbe0000 + 60648

    Thread 2:
    0   libsystem_pthread.dylib       	0x00000001dcbeece8 0x1dcbe0000 + 60648

    Thread 3:
    0   libsystem_pthread.dylib       	0x00000001dcbeece8 0x1dcbe0000 + 60648

    Thread 4:
    0   libsystem_pthread.dylib       	0x00000001dcbeece8 0x1dcbe0000 + 60648

    Thread 5 name:  com.apple.uikit.eventfetch-thread
    Thread 5:
    0   libsystem_kernel.dylib        	0x00000001dcb5bed0 0x1dcb44000 + 98000
    1   libsystem_kernel.dylib        	0x00000001dcb5b3a8 0x1dcb44000 + 95144
    2   CoreFoundation                	0x00000001dcf5fbc4 0x1dceb4000 + 703428
    3   CoreFoundation                	0x00000001dcf5aa60 0x1dceb4000 + 682592
    4   CoreFoundation                	0x00000001dcf5a1cc 0x1dceb4000 + 680396
    5   Foundation                    	0x00000001dd94f404 0x1dd947000 + 33796
    6   Foundation                    	0x00000001dd94f2b0 0x1dd947000 + 33456
    7   UIKitCore                     	0x000000020a0d0430 0x2096fc000 + 10306608
    8   Foundation                    	0x00000001dda821ac 0x1dd947000 + 1290668
    9   libsystem_pthread.dylib       	0x00000001dcbeb2ac 0x1dcbe0000 + 45740
    10  libsystem_pthread.dylib       	0x00000001dcbeb20c 0x1dcbe0000 + 45580
    11  libsystem_pthread.dylib       	0x00000001dcbeecf4 0x1dcbe0000 + 60660

    Thread 0 crashed with ARM Thread State (64-bit):
        x0: 0x0000000000000000   x1: 0x0000000000000000   x2: 0x0000000000000000   x3: 0x000000028248b4b7
        x4: 0x00000001dc198b81   x5: 0x000000016d11a570   x6: 0x000000000000006e   x7: 0xffffffff00000500
        x8: 0x0000000000000800   x9: 0x00000001dcbe6870  x10: 0x00000001dcbe1ef4  x11: 0x0000000000000003
       x12: 0x0000000000000069  x13: 0x0000000000000000  x14: 0x0000000000000010  x15: 0x0000000000000016
       x16: 0x0000000000000148  x17: 0x0000000000000000  x18: 0x0000000000000000  x19: 0x0000000000000006
       x20: 0x00000001030aeb80  x21: 0x000000016d11a570  x22: 0x0000000000000303  x23: 0x00000001030aec60
       x24: 0x0000000000001903  x25: 0x0000000000002103  x26: 0x0000000000000000  x27: 0x0000000000000000
       x28: 0x00000002836bc408   fp: 0x000000016d11a4d0   lr: 0x00000001dcbe6998
        sp: 0x000000016d11a4a0   pc: 0x00000001dcb67104 cpsr: 0x00000000

    Binary Images:
    0x102ce4000 - 0x102ceffff wspxDemo arm64  <b0ffd72fc5c33a59bf9730202c795564> /var/containers/Bundle/Application/DF7AAB28-9FF0-4EA1-99EC-C50EB87C16B5/wspxDemo.app/wspxDemo

2. 从`Binary Images:
0x102ce4000 - 0x102ceffff wspxDemo arm64  <b0ffd72fc5c33a59bf9730202c795564> /var/containers/Bundle/Application/DF7AAB28-9FF0-4EA1-99EC-C50EB87C16B5/wspxDemo.app/wspxDemo`中我们拿到`b0ffd72fc5c33a59bf9730202c795564`
3. 在终端执行`dwarfdump --uuid wspxDemo.app.dSYM/`后得到如下的输出:


    Mero:wspxDemo 2018-11-05 12-56-20 dc$ dwarfdump --uuid wspxDemo.app.dSYM/
    UUID: 43C734F8-405F-3970-8B8D-D58575672912 (armv7) wspxDemo.app.dSYM/Contents/Resources/DWARF/wspxDemo
    UUID: B0FFD72F-C5C3-3A59-BF97-30202C795564 (arm64) wspxDemo.app.dSYM/Contents/Resources/DWARF/wspxDemo

4. 对比步骤2和3的结果会发现:`b0ffd72fc5c33a59bf9730202c795564`和`B0FFD72F-C5C3-3A59-BF97-30202C795564`是一致的，所以该`wspxDemo  2018-11-5, 2-42 PM.crash.crash`对应的`dysm`就是`wspxDemo.app.dSYM`
5. 在终端执行命令：`./symbolicatecrash wspxDemo\ \ 2018-11-5\,\ 2-42\ PM.crash wspxDemo.app.dSYM/ > output.crash`得到如下的输出:


    Mero:wspxDemo 2018-11-05 12-56-20 dc$ ./symbolicatecrash wspxDemo\ \ 2018-11-5\,\ 2-42\ PM.crash wspxDemo.app.dSYM/ > output.crash
    Error: "DEVELOPER_DIR" is not defined at ./symbolicatecrash line 69.

6. 报错:`Error: "DEVELOPER_DIR" is not defined at ./symbolicatecrash line 69.`
7. 执行如下命令:`export DEVELOPER_DIR="/Applications/XCode.app/Contents/Developer"`然后再执行5的命令.执行结果如下:


    `Mero:wspxDemo 2018-11-05 12-56-20 dc$ export DEVELOPER_DIR="/Applications/XCode.app/Contents/Developer"
    Mero:wspxDemo 2018-11-05 12-56-20 dc$ ./symbolicatecrash wspxDemo\ \ 2018-11-5\,\ 2-42\ PM.crash wspxDemo.app.dSYM/ > output.crash`

8. 如果没有报任何其他错误，则说明你已经成功把crash符号了，这时打开output.crash开始查看崩溃堆栈吧
9. 如下是符号化后的output.crash文件的内容:



    Incident Identifier: 211AB31B-F097-47DC-83ED-3AC6B05A1F7A
    CrashReporter Key:   991cabc05f20cb4812ea851d9b4c57cf7b9c00c2
    Hardware Model:      iPhone10,3
    Process:             wspxDemo [1214]
    Path:                /private/var/containers/Bundle/Application/DF7AAB28-9FF0-4EA1-99EC-C50EB87C16B5/wspxDemo.app/wspxDemo
    Identifier:          com.chinanetcenter.UOne
    Version:             2222 (22.22.222)
    Code Type:           ARM-64 (Native)
    Role:                Foreground
    Parent Process:      launchd [1]
    Coalition:           com.chinanetcenter.UOne [738]

    Date/Time:           2018-11-05 14:42:17.6018 +0800
    Launch Time:         2018-11-05 14:42:17.3303 +0800
    OS Version:          iPhone OS 12.1 (16B5089b)
    Baseband Version:    3.11.00
    Report Version:      104

    Exception Type:  EXC_CRASH (SIGABRT)
    Exception Codes: 0x0000000000000000, 0x0000000000000000
    Exception Note:  EXC_CORPSE_NOTIFY
    Triggered by Thread:  0

    Application Specific Information:
    abort() called

    Last Exception Backtrace:
    0   CoreFoundation                	0x1dcfcfea0 __exceptionPreprocess + 228
    1   libobjc.A.dylib               	0x1dc1a1a40 objc_exception_throw + 55
    2   CoreFoundation                	0x1dcede054 -[__NSSingleObjectArrayI objectAtIndex:] + 127
    3   wspxDemo                      	0x102ceb9b4 -[AppDelegate application:didFinishLaunchingWithOptions:] + 31156 (AppDelegate.m:150)
    4   UIKitCore                     	0x209fda3c8 -[UIApplication _handleDelegateCallbacksWithOptions:isSuspended:restoreState:] + 411
    5   UIKitCore                     	0x209fdbb30 -[UIApplication _callInitializationDelegatesForMainScene:transitionContext:] + 3339
    6   UIKitCore                     	0x209fe157c -[UIApplication _runWithMainScene:transitionContext:completion:] + 1551
    7   UIKitCore                     	0x20987ea18 __111-[__UICanvasLifecycleMonitor_Compatability _scheduleFirstCommitForScene:transition:firstActivation:completion:]_block_invoke + 783
    8   UIKitCore                     	0x209887698 +[_UICanvas _enqueuePostSettingUpdateTransactionBlock:] + 159
    9   UIKitCore                     	0x20987e694 -[__UICanvasLifecycleMonitor_Compatability _scheduleFirstCommitForScene:transition:firstActivation:completion:] + 239
    10  UIKitCore                     	0x20987f034 -[__UICanvasLifecycleMonitor_Compatability activateEventsOnly:withContext:completion:] + 1075
    11  UIKitCore                     	0x20987d134 __82-[_UIApplicationCanvas _transitionLifecycleStateWithTransitionContext:completion:]_block_invoke + 771
    12  UIKitCore                     	0x20987cde0 -[_UIApplicationCanvas _transitionLifecycleStateWithTransitionContext:completion:] + 431
    13  UIKitCore                     	0x209881fa0 __125-[_UICanvasLifecycleSettingsDiffAction performActionsForCanvas:withUpdatedScene:settingsDiff:fromSettings:transitionContext:]_block_invoke + 219
    14  UIKitCore                     	0x209882f00 _performActionsWithDelayForTransitionContext + 111
    15  UIKitCore                     	0x209881e58 -[_UICanvasLifecycleSettingsDiffAction performActionsForCanvas:withUpdatedScene:settingsDiff:fromSettings:transitionContext:] + 247
    16  UIKitCore                     	0x209886d44 -[_UICanvas scene:didUpdateWithDiff:transitionContext:completion:] + 367
    17  UIKitCore                     	0x209fdfa74 -[UIApplication workspace:didCreateScene:withTransitionContext:completion:] + 539
    18  UIKitCore                     	0x209bca088 -[UIApplicationSceneClientAgent scene:didInitializeWithEvent:completion:] + 363
    19  FrontBoardServices            	0x1dfa049d4 -[FBSSceneImpl _didCreateWithTransitionContext:completion:] + 443
    20  FrontBoardServices            	0x1dfa0f79c __56-[FBSWorkspace client:handleCreateScene:withCompletion:]_block_invoke_2 + 259
    21  FrontBoardServices            	0x1dfa0ee94 __40-[FBSWorkspace _performDelegateCallOut:]_block_invoke + 63
    22  libdispatch.dylib             	0x1dca0a484 _dispatch_client_callout + 15
    23  libdispatch.dylib             	0x1dc9e13f0 _dispatch_block_invoke_direct$VARIANT$armv81 + 215
    24  FrontBoardServices            	0x1dfa43a9c __FBSSERIALQUEUE_IS_CALLING_OUT_TO_A_BLOCK__ + 39
    25  FrontBoardServices            	0x1dfa43728 -[FBSSerialQueue _performNext] + 415
    26  FrontBoardServices            	0x1dfa43d44 -[FBSSerialQueue _performNextFromRunLoopSource] + 55
    27  CoreFoundation                	0x1dcf601cc __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 23
    28  CoreFoundation                	0x1dcf6014c __CFRunLoopDoSource0 + 87
    29  CoreFoundation                	0x1dcf5fa30 __CFRunLoopDoSources0 + 175
    30  CoreFoundation                	0x1dcf5a8fc __CFRunLoopRun + 1039
    31  CoreFoundation                	0x1dcf5a1cc CFRunLoopRunSpecific + 435
    32  GraphicsServices              	0x1df1d1584 GSEventRunModal + 99
    33  UIKitCore                     	0x209fe3328 UIApplicationMain + 211
    34  wspxDemo                      	0x102cebaf0 main + 31472 (main.m:14)
    35  libdyld.dylib                 	0x1dca1abb4 start + 3


    Thread 0 name:  Dispatch queue: com.apple.main-thread
    Thread 0 Crashed:
    0   libsystem_kernel.dylib        	0x00000001dcb67104 __pthread_kill + 8
    1   libsystem_pthread.dylib       	0x00000001dcbe6998 pthread_kill$VARIANT$armv81 + 296
    2   libsystem_c.dylib             	0x00000001dcabed78 abort + 140
    3   libc++abi.dylib               	0x00000001dc188f78 __cxa_bad_cast + 0
    4   libc++abi.dylib               	0x00000001dc189120 default_unexpected_handler+ 8480 () + 0
    5   libobjc.A.dylib               	0x00000001dc1a1e48 _objc_terminate+ 28232 () + 124
    6   libc++abi.dylib               	0x00000001dc1950fc std::__terminate(void (*)+ 57596 ()) + 16
    7   libc++abi.dylib               	0x00000001dc195188 std::terminate+ 57736 () + 84
    8   libdispatch.dylib             	0x00000001dca0a498 _dispatch_client_callout + 36
    9   libdispatch.dylib             	0x00000001dc9e13f0 _dispatch_block_invoke_direct$VARIANT$armv81 + 216
    10  FrontBoardServices            	0x00000001dfa43a9c __FBSSERIALQUEUE_IS_CALLING_OUT_TO_A_BLOCK__ + 40
    11  FrontBoardServices            	0x00000001dfa43728 -[FBSSerialQueue _performNext] + 416
    12  FrontBoardServices            	0x00000001dfa43d44 -[FBSSerialQueue _performNextFromRunLoopSource] + 56
    13  CoreFoundation                	0x00000001dcf601cc __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__ + 24
    14  CoreFoundation                	0x00000001dcf6014c __CFRunLoopDoSource0 + 88
    15  CoreFoundation                	0x00000001dcf5fa30 __CFRunLoopDoSources0 + 176
    16  CoreFoundation                	0x00000001dcf5a8fc __CFRunLoopRun + 1040
    17  CoreFoundation                	0x00000001dcf5a1cc CFRunLoopRunSpecific + 436
    18  GraphicsServices              	0x00000001df1d1584 GSEventRunModal + 100
    19  UIKitCore                     	0x0000000209fe3328 UIApplicationMain + 212
    20  wspxDemo                      	0x0000000102cebaf0 main + 31472 (main.m:14)
    21  libdyld.dylib                 	0x00000001dca1abb4 start + 4

    Thread 1:
    0   libsystem_pthread.dylib       	0x00000001dcbeece8 start_wqthread + 0

    Thread 2:
    0   libsystem_pthread.dylib       	0x00000001dcbeece8 start_wqthread + 0

    Thread 3:
    0   libsystem_pthread.dylib       	0x00000001dcbeece8 start_wqthread + 0

    Thread 4:
    0   libsystem_pthread.dylib       	0x00000001dcbeece8 start_wqthread + 0

    Thread 5 name:  com.apple.uikit.eventfetch-thread
    Thread 5:
    0   libsystem_kernel.dylib        	0x00000001dcb5bed0 mach_msg_trap + 8
    1   libsystem_kernel.dylib        	0x00000001dcb5b3a8 mach_msg + 72
    2   CoreFoundation                	0x00000001dcf5fbc4 __CFRunLoopServiceMachPort + 236
    3   CoreFoundation                	0x00000001dcf5aa60 __CFRunLoopRun + 1396
    4   CoreFoundation                	0x00000001dcf5a1cc CFRunLoopRunSpecific + 436
    5   Foundation                    	0x00000001dd94f404 -[NSRunLoop+ 33796 (NSRunLoop) runMode:beforeDate:] + 300
    6   Foundation                    	0x00000001dd94f2b0 -[NSRunLoop+ 33456 (NSRunLoop) runUntilDate:] + 148
    7   UIKitCore                     	0x000000020a0d0430 -[UIEventFetcher threadMain] + 136
    8   Foundation                    	0x00000001dda821ac __NSThread__start__ + 1040
    9   libsystem_pthread.dylib       	0x00000001dcbeb2ac _pthread_body + 128
    10  libsystem_pthread.dylib       	0x00000001dcbeb20c _pthread_start + 48
    11  libsystem_pthread.dylib       	0x00000001dcbeecf4 thread_start + 4

    Thread 0 crashed with ARM Thread State (64-bit):
    x0: 0x0000000000000000   x1: 0x0000000000000000   x2: 0x0000000000000000   x3: 0x000000028248b4b7
    x4: 0x00000001dc198b81   x5: 0x000000016d11a570   x6: 0x000000000000006e   x7: 0xffffffff00000500
    x8: 0x0000000000000800   x9: 0x00000001dcbe6870  x10: 0x00000001dcbe1ef4  x11: 0x0000000000000003
    x12: 0x0000000000000069  x13: 0x0000000000000000  x14: 0x0000000000000010  x15: 0x0000000000000016
    x16: 0x0000000000000148  x17: 0x0000000000000000  x18: 0x0000000000000000  x19: 0x0000000000000006
    x20: 0x00000001030aeb80  x21: 0x000000016d11a570  x22: 0x0000000000000303  x23: 0x00000001030aec60
    x24: 0x0000000000001903  x25: 0x0000000000002103  x26: 0x0000000000000000  x27: 0x0000000000000000
    x28: 0x00000002836bc408   fp: 0x000000016d11a4d0   lr: 0x00000001dcbe6998
    sp: 0x000000016d11a4a0   pc: 0x00000001dcb67104 cpsr: 0x00000000

    Binary Images:
    0x102ce4000 - 0x102ceffff wspxDemo arm64  <b0ffd72fc5c33a59bf9730202c795564> /var/containers/Bundle/Application/DF7AAB28-9FF0-4EA1-99EC-C50EB87C16B5/wspxDemo.app/wspxDemo

10. 从crash文件中我们很容易定位到app挂在了AppDelegate.m 文件中的第150行这里.并且可能是因为数组越界导致崩溃。从源码截图中看确实是在AppDelegate.m的150行有问题.
11. 得到符号化crash文件后就可以进一步排查问题，之前有写过相关的博客[传送门][debug-with-crashlog]在这里就不再详细说明.

![源码][sourceCode]

[debug-with-crashlog]:https://mrchens.github.io/2018/07/26/debug-with-crashlog
[sourceCode]:https://github.com/MrChens/iOS_Tools/blob/master/crashMe/sourcecode.png
