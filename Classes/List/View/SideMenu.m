//
//  SideMenu.m
//  PrivateNote
//
//  Created by 周浩 on 17/2/12.
//  Copyright © 2017年 周浩. All rights reserved.
//

#import "SideMenu.h"

@interface SideMenu()

@property(nonatomic,strong) UIImageView  *headImageView;
@property(nonatomic,strong) UILabel      *nickNameLab;
@property(nonatomic,strong) UITableView  *tableView;

@end

UIView  *sideView=nil;
BOOL    hasShow=NO;

@implementation SideMenu

+(void)show{
    
    if (!sideView) {
        
        UIView *menu=[[UIView alloc] initWithFrame:CGRectZero];
        menu.backgroundColor=kRed;
        sideView=menu;
        UIWindow *widow=[UIApplication sharedApplication].keyWindow;
        [widow addSubview:menu];
        [menu mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.bottom.equalTo(widow);
            make.width.equalTo(@(kSideWidth));
        }];
        hasShow=YES;
    }else{
        
        if (hasShow) {
            
            [self hide];
            return;
        }
        UIWindow *widow=[UIApplication sharedApplication].keyWindow;
        [sideView updateConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(widow);
        }];
        hasShow=YES;
    }
    
}
+(void)hide{
    
    UIWindow *widow=[UIApplication sharedApplication].keyWindow;
    [sideView updateConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(widow.left);
    }];
    hasShow=NO;
}
@end
