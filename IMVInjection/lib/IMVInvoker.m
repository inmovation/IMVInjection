//
//  IMVInvoker.m
//  IMVInjection
//
//  Created by 陈少华 on 15/7/2.
//  Copyright (c) 2015年 inmovation. All rights reserved.
//

#import "IMVInvoker.h"

@implementation IMVInvoker

- (instancetype)initWithTarget:(id)target selector:(SEL)selector
{
    self = [super init];
    if (self) {
        _target = target;
        selector = selector;
    }
    return self;
}
@end
