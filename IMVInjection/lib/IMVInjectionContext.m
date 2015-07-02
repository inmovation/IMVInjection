//
//  IMVInjectContext.m
//  IMVInjection
//
//  Created by 陈少华 on 15/6/17.
//  Copyright (c) 2015年 inmovation. All rights reserved.
//
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach-o/ldsyms.h>

#import <IMVLogger.h>

#import "IMVInjectionContext.h"
#import "IMVInjectionUtils.h"
#import "IMVInvoker.h"

@interface IMVInjectionContext ()

@property (strong, nonatomic) NSMutableDictionary *injectInstanceInfo;
@property (strong, nonatomic) NSDictionary *injectClassInfo;

@property (strong, nonatomic) NSMutableDictionary *invokerInfo;

@end
@implementation IMVInjectionContext

+ (instancetype)sharedInstence
{
    static id sharedInstence = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstence = [[self alloc] init];
    });
    return sharedInstence;
}

- (id)init
{
    self = [super init];
    if (self) {
        _injectClassInfo = [IMVInjectionUtils classInfoWithInjection:@protocol(IMVInjection)];
        _injectInstanceInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSArray *)instancesWithInjection:(Protocol *)injection
{
    NSMutableArray *instances = [NSMutableArray array];
    [_injectClassInfo enumerateKeysAndObjectsUsingBlock:^(id key, id cls, BOOL *stop) {
        
        if ([cls conformsToProtocol:injection]) {
            id instance = [self instanceWithClassName:key];
            [instances addObject:instance];
        }
    }];
    return instances;
}

- (id<IMVInjection>)instanceWithClassName:(NSString *)className
{
    id instance = [_injectInstanceInfo objectForKey:className];
    if (!instance) { // lazy inject
        Class cls = [_injectClassInfo objectForKey:className];
        if (cls) {
            instance = [[cls alloc] init];
            [_injectInstanceInfo setValue:instance forKey:className];
            if ([instance respondsToSelector:@selector(inject)]) {
                [instance inject];
            }
            
            NSDictionary *propertyInfo = [IMVInjectionUtils propertyInfoForClass:cls withInjection:@protocol(IMVInjection)];
            for (NSString *propertyName in propertyInfo.allKeys) {
                NSString *propertyClassName = propertyInfo[propertyName];
                id propertyInstance = [self instanceWithClassName:propertyClassName];
                [instance setValue:propertyInstance forKey:propertyName];
            }
        }
        else
        {
            NSLogWarn(@"injected instance classnamed:%@ not found, check if %@ conforms to IMVInjection", className, className);
        }
    }
    return instance;
}


- (void)injectService:(NSString *)serviceName withTarget:(id)target selector:(SEL)selector
{
    if (!serviceName || !target || ![target respondsToSelector:selector]) {
        NSLogError(@"can't inject service with name:nil, or target:nil");
        return;
    }
    if (![target respondsToSelector:selector]) {
        NSLogWarn(@"injecting service with name:%@, and target not responds to selector", serviceName);
    }
    
    IMVInvoker *invoker = [_invokerInfo objectForKey:serviceName];
    if (!invoker) {
        invoker = [[IMVInvoker alloc] initWithTarget:target selector:selector];
        [_invokerInfo setObject:invoker forKey:serviceName];
    }
    else
    {
        NSLogWarn(@"service named:%@ has been injected with target:%@ selector:%@", serviceName, [invoker.target class], invoker.selector);
    }
}

- (void)invokeService:(NSString *)serviceName withParam:(NSDictionary *)param
{
    if (!serviceName) {
        NSLogError(@"can't invoke service with name:nil");
        return;
    }
    
    IMVInvoker *invoker = [_invokerInfo objectForKey:serviceName];
    if (invoker && invoker.target && [invoker.target respondsToSelector:invoker.selector])
    {
        ((void (*)(id, SEL))[invoker.target methodForSelector:invoker.selector])(invoker.target, invoker.selector);
    }
    else
    {
        NSLogError(@"service named:%@ has not been injected or injected target has been released or the injected target not responds to the selector", serviceName);
    }
}

@end
