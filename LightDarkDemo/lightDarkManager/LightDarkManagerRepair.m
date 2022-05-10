//
//  LightDarkManagerRepair.m
//  LightDarkDemo
//
//  Created by Marshal on 2022/5/10.
//

#import "LightDarkManagerRepair.h"
#import <objc/message.h>

static LightDarkManagerRepair *instance = nil;

@interface LightDarkManagerRepair () {
    NSMapTable *_mapTable;
}
@property (nonatomic, assign) LightDarkRepairStyle style;

@end

@implementation LightDarkManagerRepair

+ (void)registerByWindow:(UIWindow *)window {
    //交换方法，避免重复交换
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setupChanged:window];
    });
    
    [self shared];
    instance.style = LightDarkRepairStyleLight;//默认白色
    if (@available(iOS 12.0, *)) {
        [LightDarkManagerRepair shared].style = (LightDarkRepairStyle)window.traitCollection.userInterfaceStyle;
    }else {
        [LightDarkManagerRepair shared].style = LightDarkRepairStyleLight;
    }
}

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance->_mapTable = [NSMapTable mapTableWithKeyOptions:(NSPointerFunctionsWeakMemory| NSPointerFunctionsObjectPersonality) valueOptions:NSPointerFunctionsStrongMemory];
    });
    return instance;
}

+ (void)setupChanged:(UIWindow *)window {
    if (@available(iOS 12.0, *)) {
        SEL oriSEL = @selector(traitCollectionDidChange:);
        SEL swiSEL = @selector(m_traitCollectionDidChange:);
        Method oriMethod = class_getInstanceMethod([window class], oriSEL);
        Method swiMethod = class_getInstanceMethod([window class], swiSEL);
        
        //查看原方法是否存在
        if (!oriMethod) {
            //原方法不存在，给原方法赋值新方法
            class_addMethod([window class], oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
            return;
        }
        
        //向子类添加原方法，实现为新方法，如果添加成功，证明原方法不存在，并添加了一个新的方法占用原方法
        BOOL isAdd = class_addMethod([window class], oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
        if (isAdd) {
            //添加成功后，替换本类中新添加方法为原有的父类方法实现，并未与父类交换
            class_replaceMethod([window class], swiSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
        }else {
            //说明原方法在子类中存在，直接交换即可
            method_exchangeImplementations(oriMethod, swiMethod);
        }
    }else return;
}

- (void)setThemeBlock:(void (^)(LightDarkRepairStyle style))block observe:(id)object {
    [_mapTable setObject:block forKey:object];
    //调用的同时执行一次，避免写两遍代码
    block(self.style);
}

- (void)invokeThemeBlocks {
    for (id key in _mapTable) {
        void(^block)(LightDarkRepairStyle) = [_mapTable objectForKey:key];
        if (block) block(self.style);
    }
}

@end

@implementation UIWindow (LightDarkExtersion)

- (void)m_traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self m_traitCollectionDidChange: previousTraitCollection];
    if (@available(iOS 12.0, *)) {
        //方法每次都会走多次(测试两次),过滤
        UIWindow *window = (UIWindow *)self;
        if (instance.style == (LightDarkRepairStyle)window.traitCollection.userInterfaceStyle) return;
        instance.style = (LightDarkRepairStyle)window.traitCollection.userInterfaceStyle;
        if (instance.style == (LightDarkRepairStyle)previousTraitCollection.userInterfaceStyle) return;
        
        [instance invokeThemeBlocks];
    }
}

@end
