//
//  LightDarkManagerEx.h
//  LightDarkDemo
//
//  Created by Marshal on 2022/5/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LightDarkStyle) {
    LightDarkStyleUnspecified,
    LightDarkStyleLight,
    LightDarkStyleDark,
};

@interface LightDarkManagerEx : NSObject

@property (nonatomic, assign) LightDarkStyle style;

//appdelegate中注册，需要初始化window后立即调用即可
+ (void)registerByDefalutStyle:(LightDarkStyle)style;
+ (void)register;

+ (instancetype)shared;

- (void)setThemeBlock:(void (^)(LightDarkStyle style))block observe:(id)object;

@end

NS_ASSUME_NONNULL_END
