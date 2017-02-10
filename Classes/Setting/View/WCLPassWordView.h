//
//  WCLPassWordView.h
//  我的日记本
//
//  Created by 周浩 on 16/12/22.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCLPassWordView;

@protocol  WCLPassWordViewDelegate<NSObject>

@optional
/**
 *  监听输入的改变
 */
- (void)passWordDidChange:(WCLPassWordView *)passWord;

/**
 *  监听输入的完成时
 */
- (void)passWordCompleteInput:(WCLPassWordView *)passWord;

/**
 *  监听开始输入
 */
- (void)passWordBeginInput:(WCLPassWordView *)passWord;


@end


@interface WCLPassWordView : UIView<UIKeyInput>


@property (assign, nonatomic)  NSUInteger passWordNum;//密码的位数
@property (assign, nonatomic)  CGFloat squareWidth;//正方形的大小
@property (assign, nonatomic)  CGFloat pointRadius;//黑点的半径
@property (strong, nonatomic)  UIColor *pointColor;//黑点的颜色
@property (strong, nonatomic)  UIColor *rectColor;//边框的颜色
@property (strong, nonatomic)  id<WCLPassWordViewDelegate> delegate;
@property (strong, nonatomic,  readonly) NSMutableString *textStore;//保存密码的字符串
@property (nonatomic,strong) UILabel          *titleLb;
@property(nonatomic,copy)NSString *tipText;


@end
