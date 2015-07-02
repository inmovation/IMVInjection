//
//  TestInjectObject.h
//  IMVInjection
//
//  Created by 陈少华 on 15/7/2.
//  Copyright (c) 2015年 inmovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMVInjection.h"

@interface TestInjectObject : NSObject <IMVInjection>

@property (strong, nonatomic) NSString *message;

@end
