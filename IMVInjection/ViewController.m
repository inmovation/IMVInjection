//
//  ViewController.m
//  IMVInjection
//
//  Created by 陈少华 on 15/7/2.
//  Copyright (c) 2015年 inmovation. All rights reserved.
//

#import <IMVLogger.h>


#import "ViewController.h"


@interface ViewController ()
//property conforms to protocol IMVInjection will be auto injected, weak is recommended.
@property (weak, nonatomic) TestInjectObject *injectedObject;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLogInfo(@"haha, injectedObject is injected with message%@", _injectedObject.message);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark TabbarControllerInjection
- (void)inject
{
    
}
- (NSString *)tabTitle
{
    return @"我";
}

- (NSString *)tabNormalImage
{
    return @"tabbarcontroller_icon_me_normal";
}

- (NSString *)tabSelectedImage
{
    return @"tabbarcontroller_icon_me_press";
}

- (NSInteger)tabIndex
{
    return 100;
}

@end
