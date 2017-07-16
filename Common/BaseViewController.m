//
//  BaseViewController.m
//  我的日记本
//
//  Created by 周浩 on 16/11/4.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setup];
    
}
-(void)didReceiveMemoryWarning{
    
    
}
-(void)setup{
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.navigationItem.leftBarButtonItem=[Tool barButtomItemWithTitle:nil
                                                               imgName:@"menu"
                                                                target:self
                                                                action:@selector(sideMenuClickAction)];
}


#pragma mark -打开侧边菜单
-(void)sideMenuClickAction{
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app showMenu];
}
@end
