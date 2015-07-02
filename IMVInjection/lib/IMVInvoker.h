//
//  IMVInvoker.h
//  IMVInjection
//
//  Created by 陈少华 on 15/7/2.
//  Copyright (c) 2015年 inmovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMVInvoker : NSObject

@property (weak, nonatomic) id target;
@property (nonatomic) SEL selector;

- (instancetype)initWithTarget:(id)target selector:(SEL)selector;

@end
