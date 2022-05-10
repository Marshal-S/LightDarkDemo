//
//  LightDarkManagerRepair.h
//  LightDarkDemo
//
//  Created by Marshal on 2022/5/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LightDarkRepairStyle) {
    LightDarkRepairStyleUnspecified,
    LightDarkRepairStyleLight,
    LightDarkRepairStyleDark,
};

@interface LightDarkManagerRepair : NSObject

@property (nonatomic, assign, readonly) LightDarkRepairStyle style;

//appdelegate中注册，初始化window后立即调用即可
+ (void)registerByWindow:(UIWindow *)window;

+ (instancetype)shared;

- (void)setThemeBlock:(void (^)(LightDarkRepairStyle style))block observe:(id)object;
- (void)invokeThemeBlocks;

@end

@interface UIWindow (LightDarkExtersion)

- (void)m_traitCollectionDidChange:(UITraitCollection *)previousTraitCollection;

@end

NS_ASSUME_NONNULL_END
