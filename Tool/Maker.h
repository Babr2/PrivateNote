//
//  Maker.h
//  我的日记本
//
//  Created by 周浩 on 16/12/22.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Maker : NSObject

+(UILabel *)makeLabelFrame:(CGRect)frame title:(NSString *)title backColor:(UIColor *)color titileColor:(UIColor *)titleColor font:(UIFont *)font;


+(UIButton *)makeBtnFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor  backgroundColor:(UIColor *)bgColor font:(UIFont *)font target:(id)target action:(SEL)action;
@end
