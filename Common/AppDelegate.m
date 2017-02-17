//
//  AppDelegate.m
//  我的日记本
//
//  Created by 周浩 on 16/11/4.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTabBarController.h"
#import <SMS_SDK/SMSSDK.h>
#import "ListViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "LaunchPasswordViewController.h"
#import "WCLPassWordView.h"
#import "SideView.h"

//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
@interface AppDelegate ()

kStrongProperty(ListViewController,             list)
kStrongProperty(LaunchPasswordViewController,   lp)
kStrongProperty(UINavigationController,         navi)

kStrongProperty(SideView,                       sideView)
kStrongProperty(UIControl,                      back)
@property(nonatomic,assign)BOOL                 hasShow;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self configThirdSDK];
    
    [UserDefault setInteger:0 forKey:@"seletedIndex"];
    [UserDefault synchronize];
    [self shareToPlatform];
    [self createRootViewController];
    return YES;
}

-(void)shareToPlatform{
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"私密记"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeRenren),
                            @(SSDKPlatformTypeGooglePlus)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:kSinaAppkey
                                           appSecret:kSinaAppsecret
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:kWechatAppid
                                       appSecret:kWechatSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeRenren:
                 [appInfo        SSDKSetupRenRenByAppId:@"226427"
                                                 appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                                              secretKey:@"f29df781abdd4f49beca5a2194676ca4"
                                               authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeGooglePlus:
                 [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
                                           clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
                                            redirectUri:@"http://localhost"];
                 break;
             default:
                 break;
         }
     }];
}

-(UINavigationController *)navi{//懒加载
    
    if(!_navi){
        
        ListViewController *list=[[ListViewController alloc] init];
        _navi=[[UINavigationController alloc] initWithRootViewController:list];
    }
    return _navi;
}
-(void)createRootViewController{
    
    kWeakSelf(wkself)
    NSString *launchPassword=[UserDefault objectForKey:kLuanchedPassword];
    if(launchPassword||launchPassword.length!=0){
        
        self.lp=[[LaunchPasswordViewController alloc] initWithPasswordLength:4 vaildatePasswordCallBack:^(NSString *password) {
            
            if([password isEqualToString:launchPassword]){
                

                wkself.window.rootViewController=wkself.navi;
            
            }else{
                
                [wkself.lp.passwordView resignFirstResponder];
                [wkself.lp createPasswordView];
                HUDError(@"密码错误")
            }
        }];
        
        self.window.rootViewController=self.lp;
        
    }else{
        
        wkself.window.rootViewController=self.navi;
        
    }
}
-(void)configThirdSDK{
    
    [SMSSDK registerApp:kSMSSDKAppkey
             withSecret:kSMSSDKAppSecret];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    
    kWeakSelf(wkself)
    NSString *launchPassword=[UserDefault objectForKey:kLuanchedPassword];
    
    if(launchPassword||launchPassword.length!=0){
        
        self.lp=[[LaunchPasswordViewController alloc] initWithPasswordLength:4 vaildatePasswordCallBack:^(NSString *password) {
            
            if([password isEqualToString:launchPassword]){
                
            
                wkself.window.rootViewController=wkself.navi;
                
            }else{
                
                [wkself.lp.passwordView resignFirstResponder];
                [wkself.lp createPasswordView];
                HUDError(@"密码错误")
            }
        }];
        self.window.rootViewController=self.lp;
    }

}
-(UIControl *)back{
    
    if(!_back){
        
        _back=[[UIControl alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        _back.alpha=0;
        [_back addTarget:self action:@selector(hideMenu) forControlEvents:UIControlEventTouchUpInside];
        _back.backgroundColor=[UIColor blackColor];
    }
    return _back;
}
-(SideView *)sideView{
    
    if(!_sideView){
        
        _sideView=[[SideView alloc] initWithFrame:CGRectMake(-kSideWidth,0,kSideWidth,kHeight)];
        _sideView.backgroundColor=[UIColor whiteColor];
    }
    return _sideView;
}
-(void)showMenu{
    
    kWeakSelf(wkself)
    [self.window addSubview:self.back];
    [self.window addSubview:self.sideView];
    [UIView animateWithDuration:0.3 animations:^{
        
        wkself.sideView.frame=CGRectMake(0,0,kSideWidth,kHeight);
        wkself.back.alpha=0.3;
    }];
    _hasShow=YES;
}
-(void)hideMenu{
    
    kWeakSelf(wkself)
    [UIView animateWithDuration:0.3 animations:^{
        
        wkself.sideView.frame=CGRectMake(-kSideWidth,0,kSideWidth,kHeight);
        wkself.back.alpha=0;
    }];
    _hasShow=NO;
}



@end
