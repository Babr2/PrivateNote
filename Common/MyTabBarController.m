//
//  MyTabBarController.m
//  我的日记本
//
//  Created by 周浩 on 16/11/4.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "MyTabBarController.h"
#import "ListViewController.h"
#import "AddViewController.h"
#import "SettingViewController.h"
#import "EditViewController.h"

@interface MyTabBarController ()<UITabBarControllerDelegate>

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    
    [self setup];
    [super viewDidLoad];
    [self createControllers];
}
-(void)setup{
    
    self.delegate=self;
}
-(void)createControllers{
    
    NSArray *names=@[@"ListViewController",@"AddViewController",@"SettingViewController"];
    NSArray *titles=@[NSLocalizedString(@"列表",nil),@"",NSLocalizedString(@"设置",nil)];
    NSMutableArray *array=[NSMutableArray array];
    for (int i=0; i<names.count; i++) {
        
        Class cls=NSClassFromString(names[i]);
        UIViewController *controller=[[cls alloc] init];
        UINavigationController *navi=[[UINavigationController alloc] initWithRootViewController:controller];
        controller.title=titles[i];
        [array addObject:navi];
        
        //randeringMode＝ UIImageRenderingModeAutomatic   根据图片的使用环境和所处的绘图上下文自动调整渲染模式。系统默认这种
        NSString *name=[NSString stringWithFormat:@"tab%d",i+1];
        UIImage *image=[[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        controller.tabBarItem.image=image;
    
        NSString *name_s=[NSString stringWithFormat:@"tab%d_s",i+1];
        UIImage *image_s=[[UIImage imageNamed:name_s] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        controller.tabBarItem.selectedImage=image_s;
        if(i==1){
            
            controller.tabBarItem.imageInsets=UIEdgeInsetsMake(6, 0, -6, 0);
        }
    }
    self.viewControllers=array;
    BOOL open=[[NSUserDefaults standardUserDefaults] boolForKey:@"edit_open"];
    if (open) {
        
        self.selectedIndex=1;
    }else{
        
        self.selectedIndex=0;
    }
}

@end
