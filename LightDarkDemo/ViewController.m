//
//  ViewController.m
//  LightDarkDemo
//
//  Created by Marshal on 2022/5/5.
//

#import "ViewController.h"
#import "lightDarkManager/LightDarkManagerEx.h"
#import "lightDarkManager/LightDarkManager.h"

@interface ViewController ()

@property NSObject *object;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.object = [NSObject new];
    
    //如果设置了主题色调，相信更容易更新
    //实际推荐采用主题的方式，一个app一共有多个主题色调，一般使用同一个颜色，例如黑、灰、蓝、红、白等
    //就像UIButton一样，同样的接口，根据主题创建不同的对象，在不同主题下显示不同颜色信息
    //当然如果设计没那么细，可以直接使用下面的方式写两种情况的颜色或者图片赋值
    //更新主题或者系统主题更新，主动回调所有block即可
    [[LightDarkManagerEx shared] setThemeBlock:^(LightDarkStyle style) {
        if (style == LightDarkStyleDark) {
            self.view.backgroundColor = [UIColor blackColor];
        }else {
            self.view.backgroundColor = [UIColor whiteColor];
        }
    } observe:self];
    
//    [LightDarkManager shared] setThemeBlock:^(UIUserInterfaceStyle style) {
//        if (style == UIUserInterfaceStyleDark) {
//            self.view.backgroundColor = [UIColor blackColor];
//        }else {
//            self.view.backgroundColor = [UIColor whiteColor];
//        }
//    } observe:self];
}

@end
