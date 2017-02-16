
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Xtrace.h"
// exchange Class Method and Instance Method
static void __exchangeClassMethod(Class oldClass, SEL oldSEL, Class newClass, SEL newSEL)
{
    Method oldMethod = class_getClassMethod(oldClass, oldSEL);
    assert(oldMethod);
    Method newMethod = class_getClassMethod(newClass, newSEL);
    assert(newMethod);
    method_exchangeImplementations(oldMethod, newMethod);
    NSLog(@"替换方法成功");
}

static void __exchangeInstanceMethod(Class oldClass, SEL oldSEL, Class newClass, SEL newSEL)
{
    Method oldMethod = class_getInstanceMethod(oldClass, oldSEL);
    assert(oldMethod);
    Method newMethod = class_getInstanceMethod(newClass, newSEL);
    assert(newMethod);
    method_exchangeImplementations(oldMethod, newMethod);
}

@interface UIViewController (Hooked)
- (void)hooked_viewDidLoad;
- (void)hooked_viewWillAppear:(BOOL)animated;
+ (void)hook;
@end
@implementation UIViewController (Hooked)
- (void)hooked_viewDidLoad {
    NSLog(@" Test:%@ \nTestfunc:%s", NSStringFromClass([self class]), __PRETTY_FUNCTION__);
    static BOOL finish = NO;
    if ([NSStringFromClass([self class]) isEqualToString:@"UCMovieRootController"] && !finish) {
        finish = YES;
        Class asClass = NSClassFromString(@"UCMoviePlayerToolController");//UCMovieRootController
        SEL sel = @selector(xtrace);
        NSMethodSignature *signature = [asClass methodSignatureForSelector:sel];
        if(!signature) {
            NSLog(@"csl test signature nil");
            signature = [asClass methodSignatureForSelector:sel];
        }
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.target = asClass;
        invocation.selector = sel;
        
        if([asClass respondsToSelector:sel]){
            NSLog(@"csl test invokeWithTarget");
            [invocation invokeWithTarget:asClass];
        } else {
            NSLog(@"csl test invoke");
            [invocation invoke];
        }
    }
    [self hooked_viewDidLoad];
}
- (void)hooked_viewWillAppear:(BOOL)animated {
    NSLog(@" Test:%@ \nTestfunc:%s", NSStringFromClass([self class]), __PRETTY_FUNCTION__);
    [self hooked_viewWillAppear:animated];
}

+ (void)hook {
    Class oldClass = NSClassFromString(@"UIViewController");
    Class newClass = NSClassFromString(@"UIViewController_Hooked");
    if (oldClass == nil && newClass == nil) {
        NSLog(@"oldClass or newClass is nil");
        return;
    }

    __exchangeInstanceMethod(oldClass, @selector(viewDidLoad), oldClass, @selector(hooked_viewDidLoad));
    __exchangeInstanceMethod(oldClass, @selector(viewWillAppear:), oldClass, @selector(hooked_viewWillAppear:));
}
@end
@interface NSURLSession(Hooked)

+ (NSData *)readTVConfig;
- (NSURLSessionDataTask *)hooked_dataTaskWithRequest:(NSURLRequest *)request;
- (NSURLSessionDataTask *)hooked_dataTaskWithURL:(NSURL *)url;

- (NSURLSessionDataTask *)hooked_dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;
- (NSURLSessionDataTask *)hooked_dataTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

+ (void) hook;

@end

@implementation NSURLSession(Hooked)

+ (NSData *) readTVConfig {
    NSData * data = nil;
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES) objectAtIndex:0];

    NSString *configFile = [docPath stringByAppendingPathComponent:@"tvconfig.txt"];
    NSLog(@"configFile: %@\n",configFile);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:configFile]) {
        data = [NSData dataWithContentsOfFile:configFile];
    }
    return data;
}

+ (void) hook {

    Class oldClass = NSClassFromString(@"NSURLSession");
    Class newClass = NSClassFromString(@"NSURLSession_Hooked");
    if (oldClass == nil && newClass == nil) {
        NSLog(@"oldClass or newClass is nil");
        return;
    }

    __exchangeInstanceMethod(oldClass, @selector(dataTaskWithRequest:), oldClass, @selector(hooked_dataTaskWithRequest:));
    __exchangeInstanceMethod(oldClass, @selector(dataTaskWithURL:), oldClass, @selector(hooked_dataTaskWithURL:));

    __exchangeInstanceMethod(oldClass, @selector(dataTaskWithRequest:completionHandler:), oldClass, @selector(hooked_dataTaskWithRequest:completionHandler:));
    __exchangeInstanceMethod(oldClass, @selector(dataTaskWithURL:completionHandler:), oldClass, @selector(hooked_dataTaskWithURL:completionHandler:));
    return;
}


- (NSURLSessionDataTask *)hooked_dataTaskWithRequest:(NSURLRequest *)request {
    //NSLog(@"hooked_dataTaskWithRequest -> \n %@\n", request.URL.absoluteString);
    return [self hooked_dataTaskWithRequest:request];
}

- (NSURLSessionDataTask *)hooked_dataTaskWithURL:(NSURL *)url {
    //NSLog(@"hooked_dataTaskWithURL -> \n %@ \n", url.absoluteString);
    return [self hooked_dataTaskWithURL:url];
}

- (NSURLSessionDataTask *)hooked_dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
    //NSLog(@"hooked_dataTaskWithRequest:completionHandler: -> \n %@\n", request.URL.absoluteString);
    NSURLSessionDataTask * task = nil;
    if (request != nil && [request.URL.absoluteString hasPrefix: @"https://static.api.m.panda.tv/index.php?method=clientconf.tvconf"]) {
        task = [self hooked_dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSData * newData = [NSURLSession readTVConfig];
            if (newData == nil) {
                NSLog(@"tvconfig.txt is empty");
                newData = data;
            }
            NSString * strData = [[NSString alloc] initWithData: newData encoding:NSUTF8StringEncoding];
            NSLog(@"%@ \n\n %@ \noo\n", request.URL.absoluteString, strData);
            if (completionHandler) {
                completionHandler(newData, response, error);
            }
        }];
    } else {
        task = [self hooked_dataTaskWithRequest:request completionHandler:completionHandler];
    }
    return task;
}

- (NSURLSessionDataTask *)hooked_dataTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
    //NSLog(@"hooked_dataTaskWithURL:completionHandler: -> \n %@ \n", url.absoluteString);
    NSURLSessionDataTask * task = nil;
    if (url != nil && [url.absoluteString hasPrefix: @"https://static.api.m.panda.tv/index.php?method=clientconf.tvconf"]) {
        task = [self hooked_dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSData * newData = [NSURLSession readTVConfig];
            if (newData == nil) {
                NSLog(@"tvconfig.txt is empty");
                newData = data;
            }
            NSString * strData = [[NSString alloc] initWithData: newData encoding:NSUTF8StringEncoding];
            NSLog(@"%@ \n\n %@ \noo\n", url.absoluteString, strData);
            if (completionHandler) {
                completionHandler(newData, response, error);
            }
        }];
    } else {
        task = [self hooked_dataTaskWithURL:url completionHandler:completionHandler];
    }
    return task;
}


@end

@interface wspxHooks : NSObject
+ (void)hookAppProxy;
+ (void)hookAsynSocket;
@end

@implementation wspxHooks

+ (void)hookAppProxy {
    Class oldClass = NSClassFromString(@"AppProxy");
    SEL sel = @selector(setLogEnabled:);

    NSMethodSignature *signature = [oldClass methodSignatureForSelector:sel];

    if(!signature) {
        NSLog(@"csl test signature nil");
        signature = [oldClass instanceMethodSignatureForSelector:sel];
    }


    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = oldClass;
    invocation.selector = sel;
    int enable = 1;

    [invocation setArgument:&enable atIndex:2];
    if([oldClass respondsToSelector:sel]){
        NSLog(@"csl test invokeWithTarget");
        [invocation invokeWithTarget:oldClass];
    } else {
        NSLog(@"csl test invoke");
        [invocation invoke];
    }
}

+ (void)hookAsynSocket {
    Class oldClass = NSClassFromString(@"AsyncSocket");
    SEL sel = @selector(createStreamsToHost:onPort:error:);

    NSMethodSignature *signature = [oldClass methodSignatureForSelector:sel];

    if(!signature) {
        NSLog(@"csl test signature nil");
        signature = [oldClass instanceMethodSignatureForSelector:sel];
    }


    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = oldClass;
    invocation.selector = sel;

    NSLog(@"csl test invoke with AsynSocket");
}

@end

// MobileSubstrace dynamic library initialize
static void __attribute__((constructor)) initialize(void)
{
    NSLog(@"======================= csl WspxInject Initialize at Date:%@========================",[NSDate dateWithTimeIntervalSinceNow:0]);
 //   [NSURLSession hook];
    [UIViewController hook];
//    [wspxHooks hookAppProxy];
//    [wspxHooks hookAsynSocket];
//Hooked AppProxy Log
/*
 Class oldClass = NSClassFromString(@"AppProxy");
 SEL sel = @selector(setLogEnabled:);

 NSMethodSignature *signature = [oldClass methodSignatureForSelector:sel];

 if(!signature) {
     NSLog(@"csl test signature nil");
     signature = [oldClass instanceMethodSignatureForSelector:sel];
 }


 NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
 invocation.target = oldClass;
 invocation.selector = sel;
 int enable = 1;

 [invocation setArgument:&enable atIndex:2];
 if([oldClass respondsToSelector:sel]){
     NSLog(@"csl test invokeWithTarget");
     [invocation invokeWithTarget:oldClass];
 } else {
     NSLog(@"csl test invoke");
     [invocation invoke];
 }
 */

    NSLog(@"======================= WspxInject Initialize at Date:%@========================",[NSDate dateWithTimeIntervalSinceNow:0]);
}
