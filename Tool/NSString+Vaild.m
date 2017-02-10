//
//  NSString+Vaild.m
//  我的日记本
//
//  Created by 周浩 on 16/12/6.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "NSString+Vaild.h"

@implementation NSString (Vaild)

-(BOOL)isImageNode{
    
    //正则表达式
    //@"<image>image_key:2016-10-20-21-44-45-125:image_key</image>";
    NSString *reg=@"(?=<image>image_key:).+(?<=:image_key</image>)";
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    return [predicate evaluateWithObject:[self copy]];
}

@end
