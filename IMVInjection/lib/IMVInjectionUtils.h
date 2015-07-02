//
//  IMVInjectionUtils.h
//  IMVInjection
//
//  Created by 陈少华 on 15/7/2.
//  Copyright (c) 2015年 inmovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMVInjectionUtils : NSObject

+ (NSDictionary *)classInfoWithInjection:(Protocol *)injection;

+ (NSDictionary *)propertyInfoForClass:(Class)cls withInjection:(Protocol *)injection;

@end
