//
//  Maker.m
//  我的日记本
//
//  Created by 周浩 on 16/12/22.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "Maker.h"

@implementation Maker

+(UILabel *)makeLabelFrame:(CGRect)frame title:(NSString *)title backColor:(UIColor *)color titileColor:(UIColor *)titleColor font:(UIFont *)font{
    
    UILabel  *lab=[[UILabel alloc] initWithFrame:frame];
    lab.text=title;
    lab.textColor=titleColor;
    lab.backgroundColor=color;
    lab.font=font;
    lab.textAlignment=NSTextAlignmentCenter;
    
    return lab;
}
+(UIButton *)makeBtnFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor backgroundColor:(UIColor *)bgColor font:(UIFont *)font target:(id)target action:(SEL)action{
    
    UIButton *button=[[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.backgroundColor=bgColor;
    button.titleLabel.font=font;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end

