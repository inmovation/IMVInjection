//
//  IMVInjectContext.h
//  IMVInjection
//
//  Created by 陈少华 on 15/6/17.
//  Copyright (c) 2015年 inmovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMVInjection.h"

@interface IMVInjectionContext : NSObject

+ (instancetype)sharedInstence;

- (NSArray *)instancesWithInjection:(Protocol *)injection;

- (id<IMVInjection>)instanceWithClassName:(NSString *)className;

- (void)injectService:(NSString *)serviceName withTarget:(id)target selector:(SEL)selector;

- (void)invokeService:(NSString *)serviceName withParam:(NSDictionary *)param;

@end