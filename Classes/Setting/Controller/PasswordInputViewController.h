//
//  PasswordInputViewController.h
//  我的日记本
//
//  Created by 周浩 on 16/12/22.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "BaseViewController.h"

@class WCLPassWordView;

typedef void(^NOTECancelBalck)();

@interface PasswordInputViewController : BaseViewController

kStringProperty(tipText)
kStrongProperty(WCLPassWordView, passwrodInputViwe)
kAssignProperty(int, length)

@property(nonatomic,copy)void (^vaildatePasswordCallBack)(NSString *password);
@property(nonatomic,copy)void (^cancelCallBack)();
//@property(nonatomic,copy)NOTECancelBalck cancelCallBack;
//@property(nonatomic,copy)NSString *name;

//@property(nonatomic,copy) 返回值类型 (^代码块数姓名)(参数类型1 参数名1， 参数类型2 参数名2);


//作为方法的参数类型
//(返回值类型 (^) (参数1类型 参数1名称，参数2类型 参数2名称,...))


@end
