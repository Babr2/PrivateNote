//
//  ModifyNameViewController.m
//  我的日记本
//
//  Created by 周浩 on 16/12/22.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "ModifyNameViewController.h"

@interface ModifyNameViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField *textField;

@end

@implementation ModifyNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}
-(void)setup{
    
    [super setup];
    self.view.backgroundColor=kBackGround;
    self.title=@"修改昵称";
    [self createTextField];
    UIImage *back=[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:back style:UIBarButtonItemStyleDone target:self action:@selector(backAcion)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
}
-(void)backAcion{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)doneAction{
    
    if (self.doneActionCallBack) {
        self.doneActionCallBack([_textField.text copy]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createTextField{
    
    UITextField *textfield=[[UITextField alloc] initWithFrame:CGRectMake(0, 64, kWidth, 40)];
    [self.view addSubview: textfield];
    textfield.backgroundColor=kWhite;
    textfield.delegate=self;
    textfield.clearButtonMode=UITextFieldViewModeWhileEditing;
    textfield.text=self.name;
    _textField=textfield;
    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
@end
