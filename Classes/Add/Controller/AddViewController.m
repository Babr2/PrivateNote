//
//  EditViewController.m
//  我的日记本
//
//  Created by 周浩 on 16/11/4.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "AddViewController.h"
#import "EditViewController.h"
#import "ListViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    EditViewController *edit=[[EditViewController alloc] init];
    kWeakSelf(wkself)
    
    edit.backActionCallback=^{
        
        wkself.tabBarController.selectedIndex=0;
//        UIViewController *ctr=wkself.tabBarController.selectedViewController;
//        ListViewController *list=(ListViewController *)ctr;
//        list.dataArray=(NSMutableArray *)[[NoteManager shared] notesWithFolderName:folderName];
//        [list.tbView reloadData];
    };
    edit.doneActionCallBack=^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTbView" object:nil];
    };
    
    
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:edit animated:YES];
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}



@end
