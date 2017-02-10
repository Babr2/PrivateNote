//
//  EditViewController.h
//  我的日记本
//
//  Created by 周浩 on 16/11/7.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "BaseViewController.h"
@class Note;
@class ZHTextView;

@interface EditViewController : BaseViewController

@property(nonatomic,strong) ZHTextView  *contentView;
@property(nonatomic,strong)Note *note;
@property(nonatomic,copy)void (^backActionCallback)();
@property(nonatomic,copy)void (^doneActionCallBack)();

-(instancetype)initWithNote:(Note *)note;

@end
