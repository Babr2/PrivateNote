//
//  SideMenu.m
//  PrivateNote
//
//  Created by 周浩 on 17/2/12.
//  Copyright © 2017年 周浩. All rights reserved.
//

#import "SideMenu.h"
#import "SideView.h"

@interface SideMenu()

@property(nonatomic,strong) UIImageView  *headImageView;
@property(nonatomic,strong) UILabel      *nickNameLab;
@property(nonatomic,strong) UITableView  *tableView;

@end

SideView    *sideView=nil;
BOOL        hasShow=NO;
UIControl   *back;

@implementation SideMenu

+(void)show{
    
    if (!sideView) {
        
        UIWindow *widow=[UIApplication sharedApplication].keyWindow;
        back=[[UIControl alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        back.alpha=0;
        [back addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        back.backgroundColor=[UIColor blackColor];
        [widow addSubview:back];
        
        sideView=[[SideView alloc] initWithFrame:CGRectMake(-kSideWidth,0,kSideWidth,kHeight)];
        [widow addSubview:sideView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidRatated:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        [self showSide];
        
    }else{
        
        if (hasShow) {
            
            [self hide];
            return;
        }
        [self showSide];
    }
}
+(void)showSide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        sideView.frame=CGRectMake(0,0,kSideWidth,kHeight);
        back.alpha=0.3;
    }];
    hasShow=YES;
}
+(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
       
        sideView.frame=CGRectMake(-kSideWidth,0,kSideWidth,kHeight);
        back.alpha=0;
    }];
    hasShow=NO;
}

+(void)screenDidRatated:(NSNotification *)sender{
    
    UIInterfaceOrientation orentation=[UIApplication sharedApplication].statusBarOrientation;
    if(UIInterfaceOrientationIsPortrait(orentation)){
        
        CGRect frm=sideView.frame;
        frm.size=CGSizeMake(kSideWidth, kHeight);
        sideView.frame=frm;
        
    }else if(UIInterfaceOrientationIsLandscape(orentation)){
        
        CGRect frm=sideView.frame;
        frm.size=CGSizeMake(kSideWidth, kWidth);
        sideView.frame=frm;
    }
}

@end
