//
//  TabbarController.h
//  IMVInjection
//
//  Created by 陈少华 on 15/7/2.
//  Copyright (c) 2015年 inmovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMVInjectionContext.h"

#define InjectServiceTabbarConfig @"InjectServiceTabbarConfig"

@protocol TabbarControllerInjection <NSObject, IMVInjection>

@optional
- (NSInteger)tabIndex;
- (NSString *)tabTitle;
- (NSString *)tabSelectedImage;
- (NSString *)tabNormalImage;

@end

@interface TabbarController : UITabBarController <IMVInjection>

@end
