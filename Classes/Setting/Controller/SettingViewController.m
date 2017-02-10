//
//  SettingViewController.m
//  我的日记本
//
//  Created by 周浩 on 16/11/4.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "SettingViewController.h"
#import "Tool.h"
#import "Masonry.h"
#import "PesonalCenterViewController.h"
#import "PasswordInputViewController.h"
#import "WCLPassWordView.h"
#import "LoginViewController.h"
#import "User.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSArray     *dataArray;
@property(nonatomic,strong) UITableView *tbView;
@property(nonatomic,strong) UISwitch    *editSwitch;
@property(nonatomic,strong) UISwitch    *passWordSwitch;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
}
-(void)setup{
    
    [super setup];
    _dataArray=@[@[NSLocalizedString(@"云同步",nil)],@[NSLocalizedString(@"启动打开新标签",nil),NSLocalizedString(@"设置密码",nil)],@[NSLocalizedString(@"问题反馈",nil),NSLocalizedString(@"分享应用",nil)]];
    _editSwitch=[UISwitch new];
    _passWordSwitch=[UISwitch new];
    BOOL opened1=[[NSUserDefaults standardUserDefaults] boolForKey:@"edit_open"];
    [_editSwitch addTarget:self action:@selector(editChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    _editSwitch.on=opened1;
    BOOL opened2=[[NSUserDefaults standardUserDefaults] boolForKey:@"password_open"];
    [_passWordSwitch addTarget:self action:@selector(passwordChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    _passWordSwitch.on=opened2;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kUerdidLoginNotifaction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLoginOut) name:kUserdidLoginoutNotfifaction object:nil];
}
-(void)userDidLogin{
    
    PesonalCenterViewController *personal=[[PesonalCenterViewController alloc] init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:personal animated:NO];
    self.hidesBottomBarWhenPushed=NO;
}
-(void)userDidLoginOut{
    
    LoginViewController *login=[[LoginViewController alloc] init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:login animated:NO];
    self.hidesBottomBarWhenPushed=NO;
}
-(void)editChooseAction:(UISwitch *)sender{
    
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"edit_open"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)passwordChooseAction:(UISwitch *)sender{
    
    //关闭密码：此时是开的，点击一下sender在此时变成关闭状态，所以判断应该是判断关闭状态的情况
    if(!sender.isOn){//关闭操作 1次
        
        PasswordInputViewController *psw=[[PasswordInputViewController alloc] init];
        UINavigationController *navi=[[UINavigationController alloc] initWithRootViewController:psw];
        psw.cancelCallBack=^{
          
            [navi dismissViewControllerAnimated:YES completion:nil];
            sender.on=YES;
        };
        psw.vaildatePasswordCallBack=^(NSString *pwd){
            
            NSString *corrent=[[NSUserDefaults standardUserDefaults] objectForKey:@"kLuanchPassword"];
            if(![pwd isEqualToString:corrent]){
                
                HUDError(@"密码不正确")
                return ;
            }
            sender.on=NO;
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kLuanchPassword"];
            [navi dismissViewControllerAnimated:YES completion:nil];
        };
        
        [self presentViewController:navi animated:YES completion:nil];
        
    }else{//设置密码操作 2次
       
        PasswordInputViewController *psw=[[PasswordInputViewController alloc] init];
        UINavigationController *navi=[[UINavigationController alloc] initWithRootViewController:psw];
        psw.cancelCallBack=^{
            
            [navi dismissViewControllerAnimated:YES completion:nil];
            sender.on=!sender.isOn;
        };
        psw.vaildatePasswordCallBack=^(NSString *password){
            
            PasswordInputViewController *again=[[PasswordInputViewController alloc] init];
            again.title=Localizable(@"再输一遍");
            again.vaildatePasswordCallBack=^(NSString *verfyPassword){
            
                if([password isEqualToString:verfyPassword]){
                    
                    [navi dismissViewControllerAnimated:YES completion:nil];
                    //保存密码
                    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"kLuanchPassword"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    sender.on=YES;
                    
                }else{
                    
                    HUDError(@"前后密码不一致")
                    return;
                }
            };
            again.cancelCallBack=^{
                
                sender.on=NO;
                [navi dismissViewControllerAnimated:YES completion:nil];
            };
            [navi pushViewController:again animated:YES];
        };
        
        [self presentViewController:navi animated:YES completion:nil];
    }
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:@"password_open"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)createTableView{

    _tbView=[Tool tabViewWithFrame:CGRectZero style:UITableViewStylePlain delegate:self datasouce:self];
    [self.view addSubview:_tbView];
    _tbView.tableFooterView=[UIView new];
    __weak typeof (self) wkself=self;
    [_tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.left.right.equalTo(wkself.view);
//        make.top.equalTo(wkself.view).offset(64);
//        make.bottom.equalTo(wkself.view).offset(-44);
        make.edges.equalTo(wkself.view).insets(UIEdgeInsetsMake(64, 0, 44, 0));//上，左，下，右。逆时针顺序
    }];
    _tbView.backgroundColor=[UIColor colorWithWhite:0.98 alpha:1.0];
    
}
#pragma datasouce
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArray[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cid=@"cell_id";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cid];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    
    cell.textLabel.text=_dataArray[indexPath.section][indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    if (indexPath.section==1) {
        
        if (indexPath.row==0) {
            
            cell.accessoryView=_editSwitch;
        }else{
            
            cell.accessoryView=_passWordSwitch;
        }
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return  cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 20;
    }
    return  30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        
        NSString *token=[UserDefault objectForKey:kAccessToken];
        BaseViewController *controller=nil;
        if (!token||token.length==0) {
            
            controller=[[LoginViewController alloc] init];
        }else{
            
            controller=[[PesonalCenterViewController alloc] init];
        }
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:controller animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
