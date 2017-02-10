//
//  ModifyPwdViewController.m
//  我的日记本
//
//  Created by 周浩 on 17/1/3.
//  Copyright © 2017年 周浩. All rights reserved.
//

#import "ModifyPwdViewController.h"

@interface ModifyPwdViewController ()


kStrongProperty(UITextField, confirmField)
kStrongProperty(UITextField, pwdFiled)
kStrongProperty(UIButton, confirmBtn)

@end

@implementation ModifyPwdViewController

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
        
        UITextField *tf=[[UITextField alloc] initWithFrame:CGRectMake(10, 40.5*i, kWidth, 40 )];
        [backView addSubview:tf];
        if (i==0) {
            _pwdFiled=tf;
            _pwdFiled.placeholder=Localizable(@"新密码");
        }else{
            _confirmField=tf;
            _confirmField.placeholder=Localizable(@"重复新密码");
        }
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0,40+40.5*i, kWidth, 1)];
        line.backgroundColor=kLightGray;
        [backView addSubview:line];
    }
    _confirmBtn=[Maker makeBtnFrame:CGRectMake(30, CGRectGetMaxY(backView.frame)+20, 260, 40) title:Localizable(@"确认修改密码") textColor:kWhite backgroundColor:kblue font:kFont(15) target:self action:@selector(confirmResetPwd:)];
    _confirmBtn.layer.cornerRadius=5;
    [self.view addSubview:_confirmBtn];
}
-(void)confirmResetPwd:(UIButton *)sender{
    
    NSString *newPwd=[_pwdFiled.text copy];
    NSString *confirmPwd=[_confirmField.text copy];
    if (newPwd.length<6) {
    
        HUDError(@"新密码不能少于6位")
        return;
    }
    if (![newPwd isEqualToString:confirmPwd]) {
        
        HUDError(@"两次密码不一致")
        return;
    }
    sender.enabled=NO;
    NSString *params=[NSString stringWithFormat:@"new_pwd=%@&tel=%@",newPwd,[self.tel copy]];
    NSString *url=[NSString stringWithFormat:@"%@?%@",kResetPwdUrl,params];
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
        HUDSuccess(@"密码修改成功")
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserdidLoginoutNotfifaction object:nil];
        
    } failure:^(NSError *error) {
        
        HUDError(error.localizedDescription)
        sender.enabled=YES;
    }];
}
@end
