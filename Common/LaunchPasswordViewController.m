//
//  LaunchPasswordViewController.m
//  PrivateNote
//
//  Created by Babr2 on 17/2/17.
//  Copyright © 2017年 周浩. All rights reserved.
//

#import "LaunchPasswordViewController.h"
#import "WCLPassWordView.h"
#import "Maker.h"

@interface LaunchPasswordViewController ()<WCLPassWordViewDelegate>

@property(nonatomic,copy) void(^vaildateCallBack)(NSString *password);
kAssignProperty(int, length)

@end

@implementation LaunchPasswordViewController

-(instancetype)initWithPasswordLength:(int)length vaildatePasswordCallBack:(void (^)(NSString *password))vaildateCallBack{
    
    if(self=[super init]){
        
        _length=length;
        _vaildateCallBack=[vaildateCallBack copy];
    }
    return self;
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setup];
    [self createPasswordView];
    [_passwordView becomeFirstResponder];
}
-(void)setup{
    
    UILabel *titleLb=[Maker makeLabelFrame:CGRectZero title:Localizable(@"请输入密码") backColor:kWhite titileColor:kBlack font:kFont(16)];
    titleLb.textAlignment=NSTextAlignmentCenter;
    
    [self.view addSubview:titleLb];
    kWeakSelf(wkself)
    [titleLb makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(wkself.view).offset(20);
        make.bottom.equalTo(wkself.view.mas_top).offset(64);
        make.centerX.equalTo(wkself.view);
        make.width.equalTo(@200);
    }];
}
-(void)createPasswordView{
    
    for(UIView *sub in self.view.subviews){
        if([sub isKindOfClass:[WCLPassWordView class]]){
            [sub removeFromSuperview];
        }
    }
    if(_passwordView){
        [_passwordView removeFromSuperview];
        _passwordView=nil;
    }
    kWeakSelf(wkself)
    self.view.backgroundColor=kWhite;
    _passwordView=[[WCLPassWordView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    _passwordView.delegate=self;
    _passwordView.passWordNum=4;
    _passwordView.squareWidth=50;
    _passwordView.pointRadius=5;
    _passwordView.pointColor=kBlack;
    _passwordView.rectColor=kBlack;
    _passwordView.backgroundColor=kWhite;
    [self.view addSubview:_passwordView];
    UIEdgeInsets insets=UIEdgeInsetsMake(64, 0, 0, 0);
    [_passwordView makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(wkself.view).with.insets(insets);
    }];
    _passwordView.titleLb.text=Localizable(@"请输入密码");
}
-(void)passWordCompleteInput:(WCLPassWordView *)passWord{
    
    NSString *pwd=[passWord.textStore copy];
    if(self.vaildateCallBack){
        self.vaildateCallBack(pwd);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
