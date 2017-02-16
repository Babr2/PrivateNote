//
//  ForgetPwdViewController.m
//  我的日记本
//
//  Created by 周浩 on 17/1/3.
//  Copyright © 2017年 周浩. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "ModifyPwdViewController.h"

@interface ForgetPwdViewController ()

kStrongProperty(UITextField, telField)
kStrongProperty(UITextField, verifyField)
kStrongProperty(UIButton, verifyBtn)
kStrongProperty(UIButton, nextBtn)
kStrongProperty(NSTimer, timer)
kAssignProperty(int, sumTime)

@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}
-(void)setup{
    
    [super setup];
    self.title=Localizable(@"忘记密码");
    self.view.backgroundColor=kBackGround;
    UIImage *back=[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:back style:UIBarButtonItemStyleDone target:self action:@selector(backAcion)];
    [self createUI];
}
-(void)backAcion{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createUI{
    
    self.view.backgroundColor=kBackGround;
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 89, kWidth, 81)];
    backView.backgroundColor=kWhite;
    [self.view addSubview:backView];
    for (int i=0; i<2; i++) {
        
        UITextField *tf=[[UITextField alloc] initWithFrame:CGRectMake(10, 40.5*i, kWidth-15, 40 )];
        [backView addSubview:tf];
        if (i==0) {
            _telField=tf;
            _telField.placeholder=Localizable(@"手机号");
            NSString *zone=[NSString stringWithFormat:@"+%@",[Tool countryCode]];
            UILabel *zoneLab=[Maker makeLabelFrame:CGRectMake(0, 0, 30, 40) title:zone backColor:kWhite titileColor:kblue font:kFont(14)];
            _telField.leftView=zoneLab;
            _telField.leftViewMode=UITextFieldViewModeAlways;
        }else{
            _verifyField=tf;
            _verifyField.placeholder=Localizable(@"验证码");
            _verifyBtn=[Maker makeBtnFrame:CGRectMake(0, 0, 70, 25) title:Localizable(@"获取验证码") textColor:kBlack backgroundColor:kLightGray font:kFont(12) target:self action:@selector(sendVerifyCodeClickAction:)];
            _verifyBtn.layer.cornerRadius=2;
            _verifyField.rightView=_verifyBtn;
            _verifyField.rightViewMode=UITextFieldViewModeAlways;
        }
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0,40+40.5*i, kWidth, 1)];
        line.backgroundColor=kLightGray;
        [backView addSubview:line];
    }
    _nextBtn=[Maker makeBtnFrame:CGRectMake(30, CGRectGetMaxY(backView.frame)+20, 260, 40) title:Localizable(@"下一步") textColor:kWhite backgroundColor:kblue font:kFont(15) target:self action:@selector(nextTepClickAction:)];
    _nextBtn.layer.cornerRadius=5;
    [self.view addSubview:_nextBtn];
    kWeakSelf(wkself)
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@260);
        make.height.equalTo(@40);
        make.left.equalTo(wkself.view).offset((kWidth-260)/2);
        make.top.equalTo(backView.mas_bottom).offset(20);
    }];
    _telField.text=[UserDefault objectForKey:KTel];
}
-(void)sendVerifyCodeClickAction:(UIButton *)sender{
    
    if (_telField.text.length!=11) {
        
        HUDError(@"请输入正确手机号")
        return;
    }
    NSString *tel=[_telField.text copy];
    NSString *zone=[Tool countryCode];
    sender.enabled=NO;
    //打开计时器
    [self.timer setFireDate:[NSDate distantPast]];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:tel zone:zone customIdentifier:nil result:^(NSError *error) {
        if (error) {
            HUDError(error.localizedDescription)
            sender.enabled=YES;
            
        } else {
            HUDSuccess(@"验证码已发送")
        }
    }];
}
- (NSTimer*)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        //暂停
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}
- (void)timerAction {
    
    self.sumTime--;
    if (self.sumTime >= 0) {
        
        [_verifyBtn setTitle:[NSString stringWithFormat:@"%ds",self.sumTime] forState:UIControlStateNormal];
    } else {
        
        [_verifyBtn setTitle:@"再次发送" forState:UIControlStateNormal];
        _verifyBtn.enabled = YES;
        
        [self.timer invalidate];
        self.timer = nil;
    }
}
-(void)nextTepClickAction:(UIButton *)sender{
    
    NSString *tel=[_telField.text copy];
    NSString *code=[_verifyField.text copy];
    if (tel.length==0) {
        HUDError(@"请输入手机号")
        return;
    }
    if (code.length==0) {
        HUDError(@"请输入验证码")
        return;
    }
    sender.enabled=NO;
    //验证验证码或者手机号码的正确性
    NSString *zone=[Tool countryCode];
    [SMSSDK commitVerificationCode:code phoneNumber:tel zone:zone result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        
        if (error) {
            
            HUDError(@"验证码或手机号有误");
            [_verifyBtn setTitle:@"再次发送" forState:UIControlStateNormal];
            _verifyBtn.enabled = YES;
            [self.timer invalidate];
            self.timer = nil;
        } else {
            NSLog(@"验证成功");
            ModifyPwdViewController *modify=[ModifyPwdViewController new];
            self.hidesBottomBarWhenPushed=YES;
            modify.tel=[_telField.text copy];
            [self.navigationController pushViewController:modify animated:YES];
        }
    }];
    
}
@end
