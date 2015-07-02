//
//  TabbarController.m
//  IMVInjection
//
//  Created by 陈少华 on 15/7/2.
//  Copyright (c) 2015年 inmovation. All rights reserved.
//
#import <IMVLogger.h>

#import "TabbarController.h"

@interface TabbarController ()

@end

@implementation TabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)config:(NSDictionary *)config
{
    self.tabBar.backgroundColor = [config objectForKey:@"bgColor"];
}

- (void)setViewControllers:(NSArray *)viewControllers itemTitles:(NSArray *)itemTitles itemNormalImages:(NSArray *)normalImages itemSelectedImages:(NSArray *)selectedImages
{
    self.viewControllers = viewControllers;
    for (int i = 0; i < self.viewControllers.count; i++) {
        UIViewController *vc = [self.viewControllers objectAtIndex:i];
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:[itemTitles objectAtIndex:i] image:[UIImage imageNamed:[normalImages objectAtIndex:i]] tag:i];
        vc.tabBarItem = tabBarItem;
    }
}


#pragma mark - IMVInjection
- (void)inject
{
    [[IMVInjectionContext sharedInstence] injectService:InjectServiceTabbarConfig withTarget:self selector:@selector(config:)];

    NSArray *tabInjectors = [[IMVInjectionContext sharedInstence] instancesWithInjection:@protocol(TabbarControllerInjection)];
    NSMutableArray *vcs = [NSMutableArray arrayWithCapacity:tabInjectors.count];
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:tabInjectors.count];
    NSMutableArray *normalImages = [NSMutableArray arrayWithCapacity:tabInjectors.count];
    NSMutableArray *selectedImages = [NSMutableArray arrayWithCapacity:tabInjectors.count];
    
    [tabInjectors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIViewController class]]) {
            
            UIViewController *vc = obj;
            NSString *title = [obj respondsToSelector:@selector(tabTitle)]?[obj tabTitle]:@"";
            NSString *normalImage = [obj respondsToSelector:@selector(tabNormalImage)]?[obj tabNormalImage]:@"";
            NSString *selectedImage = [obj respondsToSelector:@selector(tabSelectedImage)]?[obj tabSelectedImage]:@"";
            NSInteger index = [obj respondsToSelector:@selector(tabIndex)]?[obj tabIndex]:0;
            
            if (idx == 0) {
                [vcs addObject:vc];
                [titles addObject:title];
                [normalImages addObject:normalImage];
                [selectedImages addObject:selectedImage];
            }
            else
            {
                for (int i=0; i<vcs.count; i++) { //根据tabIndex将ViewController排序
                    id vcTemp = [vcs objectAtIndex:i];
                    if ([vcTemp isKindOfClass:[UINavigationController class]]) {
                        vcTemp = [[vcTemp viewControllers] firstObject];
                    }
                    if ([vcTemp tabIndex]>index) {
                        [vcs insertObject:vc atIndex:i];
                        [titles insertObject:title atIndex:i];
                        [normalImages insertObject:normalImage atIndex:i];
                        [selectedImages insertObject:selectedImage atIndex:i];
                        break;
                    }
                    if (i==vcs.count-1) {
                        [vcs addObject:vc];
                        [titles addObject:title];
                        [normalImages addObject:normalImage];
                        [selectedImages addObject:selectedImage];
                        break;
                    }
                }
            }
        }
        else
        {
            NSLogError(@"%@ can't inject %@, only support UIViewController", obj, @protocol(TabbarControllerInjection));
        }
    }];
    
    [self setViewControllers:vcs itemTitles:titles itemNormalImages:normalImages itemSelectedImages:selectedImages];
}


#pragma mark orientation
- (BOOL)shouldAutorotate
{
    return self.selectedViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return self.selectedViewController.shouldAutorotate;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
