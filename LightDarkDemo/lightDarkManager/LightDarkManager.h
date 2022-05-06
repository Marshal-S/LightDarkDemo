//
//  LightDarkManager.h
//  LightDarkDemo
//
//  Created by Marshal on 2022/5/6.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface LightDarkManager : NSObject

@property (nonatomic, assign) UIUserInterfaceStyle style;

//appdelegate中注册，需要初始化window后立即调用即可
+ (void)registerByDefalutStyle:(UIUserInterfaceStyle)style;

+ (instancetype)shared;

- (void)setThemeBlock:(void (^)(UIUserInterfaceStyle style))block observe:(id)object;

@end

NS_ASSUME_NONNULL_END
