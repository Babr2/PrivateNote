//
//  DefineHeader.h
//  我的日记本
//
//  Created by 周浩 on 16/12/22.
//  Copyright © 2016年 周浩. All rights reserved.
//

#ifndef DefineHeader_h
#define DefineHeader_h

#define kStrongProperty(class,name) @property(nonatomic,strong)class *name;
#define kStringProperty(name) @property(nonatomic,copy)NSString *name;
#define kAssignProperty(type,name) @property(nonatomic,assign)type name;
#define kCopyProperty(class,name) @property(nonatomic,copy)class *name;

#define HudShow(string)                 [ProgressHUD showError:string];
#define UserDefault                     [NSUserDefaults standardUserDefaults]
#define Localizable(x)                  NSLocalizedString(x,nil)

#define LoginState                      @"login_state_key"
#define kLuanchedPassword               @"kLuanchPassword"
#define KUserLoginName                  @"login_name_key"
#define kAccessToken                    @"kAccessToken"
#define kLastSyncTime                   @"last_sync_time"
#define kHeadimageURL                   @"headImageURL"
#define kNickName                       @"nickName"
#define KTel                            @"userphoneNumber"
#define kPwd                            @"pwd"
#define kUerdidLoginNotifaction         @"kUerdidLoginNotifaction"
#define kUserdidLoginoutNotfifaction    @"kUserdidLoginoutNotfifaction"
#endif /* DefineHeader_h */
