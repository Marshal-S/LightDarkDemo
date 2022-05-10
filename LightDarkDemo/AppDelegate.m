//
//  AppDelegate.m
//  LightDarkDemo
//
//  Created by Marshal on 2022/5/5.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "lightDarkManager/LightDarkManager.h"
#import "lightDarkManager/LightDarkManagerEx.h"
#import "lightDarkManager/LightDarkManagerRepair.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //注册，实际交换方法
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
//    LightDarkManager registerByDefalutStyle:self.window.traitCollection.userInterfaceStyle];
    
    if (@available(iOS 12.0, *)) {
        [LightDarkManagerEx registerByDefalutStyle:(LightDarkStyle)self.window.traitCollection.userInterfaceStyle];
    }else {
        [LightDarkManagerEx register];
    }
    
//    [LightDarkManagerRepair registerByWindow:self.window];
    
    self.window.rootViewController = [[ViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    
    //设置全局黑暗模式
//    self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    NSLog(@"active:%ld", self.window.traitCollection.userInterfaceStyle);
}



@end
