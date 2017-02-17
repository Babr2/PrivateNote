//
//  LaunchPasswordViewController.h
//  PrivateNote
//
//  Created by Babr2 on 17/2/17.
//  Copyright © 2017年 周浩. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCLPassWordView;

@interface LaunchPasswordViewController : UIViewController

kStrongProperty(WCLPassWordView, passwordView)

-(instancetype)initWithPasswordLength:(int)length vaildatePasswordCallBack:(void (^)(NSString *password))vaildateCallBack;

-(void)createPasswordView;


@end
