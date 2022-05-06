//
//  LightDarkManagerEx.m
//  LightDarkDemo
//
//  Created by Marshal on 2022/5/6.
//

#import "LightDarkManagerEx.h"
#import <objc/message.h>

@interface LightDarkManagerEx () {
    NSMapTable *_mapTable;
}

@end

@implementation LightDarkManagerEx

static LightDarkManagerEx *instance = nil;

+ (void)registerByDefalutStyle:(LightDarkStyle)style {
    [self setupChanged];
    [self shared];
    instance.style = style;
}

+ (void)register {
    [self setupChanged];
    [self shared];
    instance.style = LightDarkStyleLight;//默认白色
}

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance->_mapTable = [NSMapTable mapTableWithKeyOptions:(NSPointerFunctionsWeakMemory| NSPointerFunctionsObjectPersonality) valueOptions:NSPointerFunctionsStrongMemory];
    });
    return instance;
}

+ (void)setupChanged {
    if (@available(iOS 12.0, *)) {
        SEL oriSEL = @selector(traitCollectionDidChange:);
        SEL swiSEL = @selector(m_traitCollectionDidChange:);
        Method oriMethod = class_getInstanceMethod([UIWindow class], oriSEL);
        Method swiMethod = class_getInstanceMethod([self class], swiSEL);
        
        //查看原方法是否存在
        if (!oriMethod) {
            //原方法不存在，给原方法赋值新方法
            class_addMethod([UIWindow class], oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
            return;
        }
        
        //向子类添加原方法，实现为新方法，如果添加成功，证明原方法不存在，并添加了一个新的方法占用原方法
        BOOL isAdd = class_addMethod([UIWindow class], oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
        if (isAdd) {
            //添加成功后，替换本类中新添加方法为原有的父类方法实现，并未与父类交换
            class_replaceMethod([self class], @selector(m_traitCollectionDidChange:), method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
        }else {
            //说明原方法在子类中存在，直接交换即可
            method_exchangeImplementations(oriMethod, swiMethod);
        }
    }else return;
}

//取决于调用者,window
- (void)m_traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    if (@available(iOS 12.0, *)) {
        //方法每次都会走多次(测试两次),过滤
        UIWindow *window = (UIWindow *)self;
        if (instance.style == (LightDarkStyle)window.traitCollection.userInterfaceStyle) return;
        instance.style = (LightDarkStyle)window.traitCollection.userInterfaceStyle;
        if (instance.style == (LightDarkStyle)previousTraitCollection.userInterfaceStyle) return;
        
        [instance invokeThemeBlocks];
    }
}

- (void)setThemeBlock:(void (^)(LightDarkStyle style))block observe:(id)object {
    [_mapTable setObject:block forKey:object];
    //调用的同时执行一次，避免写两遍代码
    block(self.style);
}

- (void)invokeThemeBlocks {
    for (id key in _mapTable) {
        void(^block)(LightDarkStyle) = [_mapTable objectForKey:key];
        if (block) block(self.style);
    }
}

@end
