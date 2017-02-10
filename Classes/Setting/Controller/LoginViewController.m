//
//  LoginViewController.m
//  我的日记本
//
//  Created by 周浩 on 16/12/26.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "LoginViewController.h"
#import "NoteManager.h"
#import "User.h"
#import "PesonalCenterViewController.h"
#import "RegisterViewController.h"
#import "ForgetPwdViewController.h"

@interface LoginViewController ()


kStrongProperty(UITextField, pswField)
kStrongProperty(UIButton,    loginBtn)
kStrongProperty(UIButton,    registerBtn)
kStrongProperty(UIButton,    forgetBtn)
@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setup];
}
-(void)setup{
    
    [super setup];
    self.title=Localizable(@"登录");
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
        
        UITextField *tf=[[UITextField alloc] initWithFrame:CGRectMake(10, 40.5*i, kWidth-10, 40 )];
        [backView addSubview:tf];
        if (i==0) {
            _userField=tf;
        }else{
            _pswField=tf;
        }
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0,40+40.5*i, kWidth, 1)];
        line.backgroundColor=kLightGray;
        [backView addSubview:line];
    }
    _forgetBtn=[[UIButton alloc] initWithFrame:CGRectMake(255,40.5, 60,40)];
    [_forgetBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [_forgetBtn setTitle:Localizable(@"忘记密码") forState:0];
    _forgetBtn.titleLabel.font=kFont(13);
    [_forgetBtn setTitleColor:kgray forState:UIControlStateNormal];
    [backView addSubview:_forgetBtn];
    
    _userField.placeholder=Localizable(@"手机号");
    _userField.text=[UserDefault objectForKey:KUserLoginName];
    _pswField.placeholder=Localizable(@"密码");
    
    _loginBtn=[Tool makeBtnFrame:CGRectMake(30, CGRectGetMaxY(backView.frame)+20, 260, 40) title:Localizable(@"登录") textColor:kWhite imageName:nil backgroundColor:kblue target:self action:@selector(loginClickAction:)];
    _loginBtn.layer.cornerRadius=5;
    [self.view addSubview:_loginBtn];
    
    _registerBtn=[Tool makeBtnFrame:CGRectMake(110, CGRectGetMaxY(_loginBtn.frame)+10, 100, 20) title:Localizable(@"或者，创建账户")
                          textColor:kgray
                          imageName:nil
                    backgroundColor:nil
                             target:self
                             action:@selector(registerClickAction)];
    _registerBtn.titleLabel.font=kFont(12);
    [self.view addSubview:_registerBtn];
    
    _userField.text=[UserDefault objectForKey:KTel];
}
-(void)forgetPassword{
    
    ForgetPwdViewController *forget=[ForgetPwdViewController new];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:forget animated:YES];
    
}
-(void)loginClickAction:(UIButton *)sender{
    
    NSString *userLogin=[_userField.text copy];
    NSString *password=[_pswField.text copy];
    if (userLogin.length==0||!userLogin) {
        
        HUDError(@"请输入手机号")
        return;
    }
    if (password.length==0||!password) {
        
        HUDError(@"请输入密码")
        return;
    }
    if (password.length<6) {
        
        HUDError(@"密码长度至少6位")
        return;
    }
    sender.enabled=NO;
    NSString *param=[NSString stringWithFormat:@"tel=%@&pwd=%@",userLogin,password];
    NSString *url=[NSString stringWithFormat:@"%@?%@",kLoginUrl,param];
    [[ZhRequest request] get:url success:^(NSData *data) {
        
        if (data.length==0||!data) {
            
            HUDError(@"获取不到数据")
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
            HUDError(error)
            sender.enabled=YES;
            return;
        }
        NSString *token=[obj objectForKey:@"token"];
        if (token.length>0) {
            
            [UserDefault setObject:token forKey:kAccessToken];
            NSLog(@"%@",token);
        }
        NSString *lastSyncTime=[obj objectForKey:@"last_sync_time"];
        NSDictionary *info=[obj objectForKey:@"info"];
        NSString *headImageUrl=[info objectForKey:@"img"];
        NSString *nickName=[info objectForKey:@"nick_name"];
        NSString *tel=[info objectForKey:@"tel"];
        
        if (lastSyncTime.length>0) {
            
            [UserDefault setObject:lastSyncTime forKey:kLastSyncTime];
        }
        if (headImageUrl.length>0) {
            
            [UserDefault setObject:headImageUrl  forKey:kHeadimageURL];
        }
        if (nickName.length>0) {
            
            [UserDefault setObject:nickName forKey:kNickName];
        }
        if (tel.length>0) {
            
            [UserDefault setObject:tel forKey:KTel];
        }
        [UserDefault synchronize];
        HUDSuccess(@"登录成功")
        [self.navigationController popViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUerdidLoginNotifaction object:nil];
    } failure:^(NSError *error) {
        
        HUDError(error.localizedDescription)
        sender.enabled=YES;
    }];
}
-(void)registerClickAction{
    
    RegisterViewController *regist=[[RegisterViewController alloc] init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:regist animated:YES];

}
@end
