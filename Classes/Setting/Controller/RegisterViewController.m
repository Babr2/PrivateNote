//
//  RegisterViewController.m
//  我的日记本
//
//  Created by 周浩 on 16/12/26.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "RegisterViewController.h"
#import <SMS_SDK/SMSSDK.h>

@interface RegisterViewController ()

kStrongProperty(UITextField, phoneField)
kStrongProperty(UITextField, verifyField)
kStrongProperty(UITextField, pwdField)
kStrongProperty(UIButton, getRegeistBtn)
kStrongProperty(UIButton, registerBtn)
kStrongProperty(UIButton, loginBtn)
@property(nonatomic,strong)NSTimer *timer;//用来倒计时的
@property(nonatomic,assign)int sumTime;//倒计时用的总时间

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}
-(void)setup{
    
    [super setup];
    self.title=Localizable(@"注册");
    UIImage *back=[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:back style:UIBarButtonItemStyleDone target:self action:@selector(backAcion)];
    [self createUI];
    _sumTime=60;
}
-(void)createUI{
    
    self.view.backgroundColor=kBackGround;
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 89, kWidth, 120.6)];
    backView.backgroundColor=kWhite;
    [self.view addSubview:backView];
    
    for (int i=0; i<3; i++) {
        
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0,40+40.2*i, kWidth, 1)];
        line.backgroundColor=kLightGray;
        [backView addSubview:line];
        
        UITextField *textField=[[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(line.frame)-40, kWidth-15, 40)];
        [backView addSubview:textField];
        if (i==0) {
            _phoneField=textField;
            
            UIButton *getVerifyBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,0, 70, 25)];
            getVerifyBtn.backgroundColor=kLightGray;
            [getVerifyBtn setTitle:Localizable(@"获取验证码") forState:UIControlStateNormal];
            getVerifyBtn.titleLabel.font=kFont(12);
            getVerifyBtn.layer.cornerRadius=2;
            _getRegeistBtn=getVerifyBtn;
            [getVerifyBtn addTarget:self action:@selector(getVerifyClickAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *zoneLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            zoneLab.text=[NSString stringWithFormat:@"+%@",[Tool countryCode]];
            zoneLab.textColor=kblue;
            textField.leftView=zoneLab;
            textField.leftViewMode=UITextFieldViewModeAlways;
            textField.rightView=getVerifyBtn;
            textField.rightViewMode=UITextFieldViewModeAlways;
        }
        else if(i==1){
            
            _verifyField=textField;
        }else{
            
            _pwdField=textField;
        }
    };
    kWeakSelf(wkself)
    _phoneField.placeholder=Localizable(@"手机号");
    _phoneField.keyboardType=UIKeyboardTypeNumberPad;
    _verifyField.placeholder=Localizable(@"验证码");
    _pwdField.placeholder=Localizable(@"密码");
    
    _registerBtn=[Tool makeBtnFrame:CGRectZero
                              title:Localizable(@"注册")textColor:kWhite imageName:nil backgroundColor:kblue target:self action:@selector(registerClickAction:)];
    _registerBtn.layer.cornerRadius=5;
    [self.view addSubview:_registerBtn];
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.width.equalTo(@260);
        make.height.equalTo(@40);
        make.left.equalTo(wkself.view).offset((kWidth-260)/2);
        make.top.equalTo(backView.mas_bottom).offset(20);
    }];
    _loginBtn=[Tool makeBtnFrame:CGRectMake(110, CGRectGetMaxY(_registerBtn.frame)+10, 100, 20) title:Localizable(@"或者，登录账户") textColor:kgray imageName:nil backgroundColor:nil target:self action:@selector(backToLoginClickAction)];
    _loginBtn.titleLabel.font=kFont(12);
    [self.view addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@100);
        make.height.equalTo(@20);
        make.left.equalTo(wkself.view).offset((kWidth-100)/2);
        make.top.equalTo(wkself.registerBtn.mas_bottom).offset(10);
    }];
}
//获取验证码的方法
-(void)getVerifyClickAction:(UIButton *)sender{
    
    if (_phoneField.text.length!=11) {
        
        HUDError(@"请输入正确手机号")
        return;
    }
    NSString *tel=[_phoneField.text copy];
    sender.enabled=NO;
    //打开计时器
    [self.timer setFireDate:[NSDate distantPast]];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:tel zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (error) {
            HUDError(@"请检查手机号码是否正确")
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
        
        [_getRegeistBtn setTitle:[NSString stringWithFormat:@"%ds",self.sumTime] forState:UIControlStateNormal];
    } else {

        [_getRegeistBtn setTitle:@"再次发送" forState:UIControlStateNormal];
        _getRegeistBtn.enabled = YES;
        
        [self.timer invalidate];
        self.timer = nil;
    }
    
}

-(void)registerClickAction:(UIButton *)sender{
    
    NSString *tel=[_phoneField.text copy];
    NSString *code=[_verifyField.text copy];
    NSString *zone=[Tool countryCode];
    NSString *pwd=[_pwdField.text copy];
    if (tel.length==0) {
        HUDError(@"请输入手机号")
        return;
    }
    if (code.length==0) {
        HUDError(@"请输入验证码")
        return;
    }
    if (pwd.length<6) {
        
        HUDError(@"密码不能小于6位")
        return;
    }
    sender.enabled=NO;
    [SMSSDK commitVerificationCode:code phoneNumber:tel zone:zone result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        
        if (error) {
            
            HUDError(@"验证码或手机号有误");
            [_getRegeistBtn setTitle:@"再次发送" forState:UIControlStateNormal];
            _getRegeistBtn.enabled = YES;
            [self.timer invalidate];
            self.timer = nil;
        } else {
            NSLog(@"验证成功");
        }
    }];
    NSString *param=[NSString stringWithFormat:@"tel=%@&pwd=%@",tel,pwd];
    NSString *url=[NSString stringWithFormat:@"%@?%@",kRegisterUrl,param];
    [[ZhRequest request] get:url success:^(NSData *data) {
       
        if (data.length==0||!data) {
            
            HUDError(@"服务器获取不到数据")
            sender.enabled=YES;
            return ;
        }
        id obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (![obj isKindOfClass:[NSDictionary class]]) {
            
            HUDError(@"服务器内部错误")
            sender.enabled=YES;
            return;
        }
        BOOL ret=[[obj objectForKey:@"result"] boolValue];
        if (!ret) {
            
            NSString *error=[obj objectForKey:@"error"];
            HUDError(error);
            sender.enabled=YES;
            return;
        }
        [UserDefault setObject:tel forKey:KTel];
        [UserDefault setObject:pwd forKey:kPwd];
        [UserDefault synchronize];
        HUDSuccess(@"注册成功")
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        HUDError(error.localizedDescription);
        sender.enabled=YES;
    }];
    
}
-(void)backAcion{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backToLoginClickAction{
    
    [self backAcion];
}



@end
