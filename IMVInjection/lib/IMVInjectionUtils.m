//
//  IMVInjectionUtils.m
//  IMVInjection
//
//  Created by 陈少华 on 15/7/2.
//  Copyright (c) 2015年 inmovation. All rights reserved.
//
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach-o/ldsyms.h>

#import <IMVLogger.h>

#import "IMVInjectionUtils.h"

@implementation IMVInjectionUtils

+ (NSDictionary *)classInfoWithInjection:(Protocol *)injection
{
    NSMutableDictionary *injectClassInfo = [NSMutableDictionary dictionary];
    
    //only scan classes user created
    unsigned int count;
    const char **classes;
    Dl_info info;
    
    dladdr(&_mh_execute_header, &info);
    classes = objc_copyClassNamesForImage(info.dli_fname, &count);
    
    for (int i = 0; i < count; i++) {
        NSString *clsName = [NSString stringWithCString:classes[i] encoding:NSUTF8StringEncoding];
        Class cls = NSClassFromString (clsName);
        if (class_getClassMethod(cls, @selector(conformsToProtocol:)) && [cls conformsToProtocol:injection]) {
            [injectClassInfo setObject:cls forKey:clsName];
        }
    }
    
    return injectClassInfo;
}

+ (NSDictionary *)propertyInfoForClass:(Class)cls withInjection:(Protocol *)injection
{
    NSMutableDictionary *propertyInfo = [NSMutableDictionary dictionary];
    
    while (cls && [cls conformsToProtocol:injection]) {
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList(cls, &count);
        
        for (int i=0; i<count; i++) {
            objc_property_t property = properties[i];
            NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            
            NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@"\""];
            NSString *propertyClassName = nil;
            if (splitPropertyAttributes.count >= 2) {
                propertyClassName = [splitPropertyAttributes objectAtIndex:1];
            }
            if (propertyClassName) {
                if ([NSClassFromString(propertyClassName) conformsToProtocol:injection]) {
                    [propertyInfo setObject:propertyClassName forKey:propertyName];
                }
            }
            
        }
        
        cls = class_getSuperclass(cls);
        
        free(properties);
    }
    
    return propertyInfo;
}

@end
