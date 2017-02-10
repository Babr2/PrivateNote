//
//  ModifyNameViewController.h
//  我的日记本
//
//  Created by 周浩 on 16/12/22.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "BaseViewController.h"

@interface ModifyNameViewController : BaseViewController

@property(nonatomic,copy)void (^doneActionCallBack)(NSString *newName);
kStringProperty(name)


@end
