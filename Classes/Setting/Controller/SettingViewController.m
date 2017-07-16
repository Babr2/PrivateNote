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
#import <MessageUI/MessageUI.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>

@property(nonatomic,strong) NSArray     *dataArray;
@property(nonatomic,strong) UITableView *tbView;
@property(nonatomic,strong) UISwitch    *editSwitch;
@property(nonatomic,strong) UISwitch    *passWordSwitch;

@end

@implementation SettingViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UserDefault setInteger:2 forKey:@"seletedIndex"];
    [UserDefault synchronize];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createUI];
    [self createTableView];
}
-(void)setup{
    
    [super setup];
    _dataArray=@[@[NSLocalizedString(@"云同步",nil)],@[NSLocalizedString(@"启动打开新标签",nil),NSLocalizedString(@"设置密码",nil)],@[NSLocalizedString(@"问题反馈",nil),NSLocalizedString(@"分享应用",nil)]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin) name:kUerdidLoginNotifaction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLoginOut) name:kUserdidLoginoutNotfifaction object:nil];
}
-(void)createUI{

    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    
    _editSwitch=[UISwitch new];
    _passWordSwitch=[UISwitch new];
    BOOL opened1=[[NSUserDefaults standardUserDefaults] boolForKey:@"edit_open"];
    [_editSwitch addTarget:self action:@selector(editChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    _editSwitch.on=opened1;
    BOOL opened2=[[NSUserDefaults standardUserDefaults] boolForKey:@"password_open"];
    [_passWordSwitch addTarget:self action:@selector(passwordChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    _passWordSwitch.on=opened2;
}
-(void)backAction{
    
    [UserDefault setInteger:0 forKey:@"seletedIndex"];
    [UserDefault synchronize];
    [self.navigationController popViewControllerAnimated:YES];
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
        make.edges.equalTo(wkself.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));//上，左，下，右。逆时针顺序
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
        
    }else if(indexPath.section==2){
        
        if (indexPath.row==0) {
            
            MFMailComposeViewController*mail=[[MFMailComposeViewController alloc]init];
            mail.mailComposeDelegate=self;
            [mail setSubject:Localizable(@"问题反馈")];
            [mail setCcRecipients:@[@"332985289@qq.com"]];
            if(mail){
                [self presentViewController:mail animated:YES completion:nil];
            }
            
        }else{
            
            [self shareAction];
        }
    }
}
//分享平台种类
+(SSDKPlatformType)shareTypeWithName:(NSString *)title{
    
    SSDKPlatformType type=SSDKPlatformTypeUnknown;
    if([title isEqualToString:@"微博"]){
        
        type=SSDKPlatformTypeSinaWeibo;
        
    }else if([title isEqualToString:@"微信"]){
        
        type=SSDKPlatformTypeWechat;
        
    }else if([title isEqualToString:@"朋友圈"]){
        
        type=SSDKPlatformSubTypeWechatTimeline;
        
    }else if([title isEqualToString:@"QQ"]){
        
        type=SSDKPlatformTypeQQ;
        
    }else{
        
        type=SSDKPlatformSubTypeQZone;
    }
    return type;
}
-(void)shareAction{
    
    __weak typeof(self) wkself=self;
    UIAlertController *controller=[Tool sheetWithTitle:@"分享至"
                  action:^(UIAlertAction * action) {
                      
                      NSString *title=[action.title copy];
                      //分享到哪个平台
                      SSDKPlatformType type=[SettingViewController shareTypeWithName:title];
                      [wkself shareTo:type];
                      
                  } titleArray:@[@"微博",@"微信",@"朋友圈",@"QQ",@"QQ空间"]];
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)shareTo:(SSDKPlatformType)type{
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    UIImage *shareImage=[UIImage imageNamed:@"share_icon"];
    [dict SSDKSetupShareParamsByText:@"私密记，最安全的云日记"
                              images:@[shareImage]
                                 url:[NSURL URLWithString:@"http://cgpointzero.top"]
                               title:@"私密记"
                                type:SSDKContentTypeAuto];
    [dict SSDKEnableUseClientShare];
    [ShareSDK share:type
         parameters:dict
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
         if(state==SSDKResponseStateSuccess){
             
             HUDSuccess(@"分享成功")
         }else{
             
             HUDSuccess(@"分享失败")
         }
     }];
}
#pragma MFMailComposeViewControllerDelegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    if (result==MFMailComposeResultSent) {
        
        HUDSuccess(@"发送成功")
    }
    else if(result==MFMailComposeResultFailed){
        
        HUDError(error.localizedDescription)
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
