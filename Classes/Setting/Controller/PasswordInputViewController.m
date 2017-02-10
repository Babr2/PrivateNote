//
//  PasswordInputViewController.m
//  我的日记本
//
//  Created by 周浩 on 16/12/22.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "PasswordInputViewController.h"
#import "WCLPassWordView.h"

@interface PasswordInputViewController ()<WCLPassWordViewDelegate>




@end

@implementation PasswordInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self createView];
}


-(void)setup{
    
    [super setup];
    UIButton *cancelBtn=[Tool makeBtnFrame:CGRectMake(0, 0, 60, 64) title:Localizable(@"取消") textColor:nil imageName:nil backgroundColor:nil target:self action:@selector(cancelBtnDidClickAction)];
    cancelBtn.titleLabel.font=kFont(14);
    self.title=Localizable(@"设置密码");
    //[self.view addSubview:cancelBtn];
    [cancelBtn setTitleColor:kblue forState:UIControlStateNormal];
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.rightBarButtonItem=item;
    self.navigationItem.hidesBackButton=YES;
}
-(void)cancelBtnDidClickAction{
    
    if(self.cancelCallBack){
        self.cancelCallBack();
    }
    [self.view endEditing:YES];
}
-(void)createView{
    
    kWeakSelf(wkself)
    
    WCLPassWordView *passwordInputView=[[WCLPassWordView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    passwordInputView.tipText=[self.tipText copy];
    passwordInputView.delegate=self;
    passwordInputView.passWordNum=4;
    passwordInputView.squareWidth=50;
    passwordInputView.pointRadius=5;
    passwordInputView.pointColor=kBlack;
    passwordInputView.rectColor=kBlack;
    passwordInputView.backgroundColor=kWhite;
    [self.view addSubview:passwordInputView];
    
    UIEdgeInsets insets=UIEdgeInsetsMake(64, 0, 0, 0);
    [passwordInputView makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(wkself.view).with.insets(insets);
    }];
    [passwordInputView becomeFirstResponder];
    self.passwrodInputViwe=passwordInputView;
}
-(void)passWordDidChange:(WCLPassWordView *)passWord{
    
}
-(void)passWordBeginInput:(WCLPassWordView *)passWord{
    
    
}
-(void)passWordCompleteInput:(WCLPassWordView *)passWord{
    
    NSString *pwd=[passWord.textStore copy];
    if(self.vaildatePasswordCallBack){
        self.vaildatePasswordCallBack(pwd);
    }
}
@end
