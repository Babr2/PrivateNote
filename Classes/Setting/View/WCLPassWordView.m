//
//  WCLPassWordView.m
//  我的日记本
//
//  Created by 周浩 on 16/12/22.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "WCLPassWordView.h"

@interface WCLPassWordView ()

@property (strong, nonatomic) NSMutableString *textStore;//保存密码的字符串

@end

@implementation WCLPassWordView

static NSString  * const MONEYNUMBERS = @"0123456789";

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self=[super initWithFrame:frame]){
        
        self.textStore = [NSMutableString string];
        //[self becomeFirstResponder];
        _titleLb=[[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2-125, frame.size.height/5, 250, 20)];
        _titleLb.text=self.tipText;
        _titleLb.font=[UIFont systemFontOfSize:15];
        _titleLb.textColor=[UIColor blackColor];
        _titleLb.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_titleLb];
    }
    return self;
}
/**
 *  设置正方形的边长
 */
- (void)setSquareWidth:(CGFloat)squareWidth {
    _squareWidth = squareWidth;
    [self setNeedsDisplay];
}

/**
 *  设置键盘的类型
 */
- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}

/**
 *  设置密码的位数
 */
- (void)setPassWordNum:(NSUInteger)passWordNum {
    _passWordNum = passWordNum;
    [self setNeedsDisplay];
}

- (BOOL)becomeFirstResponder {
    
    if ([self.delegate respondsToSelector:@selector(passWordBeginInput:)]) {
        
        [self.delegate passWordBeginInput:self];
    }
    return [super becomeFirstResponder];
}

/**
 *  是否能成为第一响应者
 */
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}

#pragma mark - UIKeyInput
/**
 *  用于显示的文本对象是否有任何文本
 */
- (BOOL)hasText {
    
    return self.textStore.length > 0;
}

/**
 *  插入文本
 */
- (void)insertText:(NSString *)text {
    
    if (self.textStore.length < self.passWordNum) {
        //判断是否是数字
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:MONEYNUMBERS] invertedSet];
        NSString*filtered = [[text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [text isEqualToString:filtered];
        if(basicTest) {
            [self.textStore appendString:text];
            if ([self.delegate respondsToSelector:@selector(passWordDidChange:)]) {
                [self.delegate passWordDidChange:self];
            }
            if (self.textStore.length == self.passWordNum) {
                
                if ([self.delegate respondsToSelector:@selector(passWordCompleteInput:)]) {
                    [self resignFirstResponder];
                    __weak typeof(self) wkself=self;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [wkself.delegate passWordCompleteInput:wkself];
                    });
                }
            }
            [self setNeedsDisplay];
        }
    }
}

/**
 *  删除文本
 */
- (void)deleteBackward {
    
    if (self.textStore.length > 0) {
        [self.textStore deleteCharactersInRange:NSMakeRange(self.textStore.length - 1, 1)];
        if ([self.delegate respondsToSelector:@selector(passWordDidChange:)]) {
            [self.delegate passWordDidChange:self];
        }
    }
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
- (void)drawRect:(CGRect)rect {
    
    CGFloat width = rect.size.width;
    CGFloat x = (width - self.squareWidth*self.passWordNum)/2.0;
    CGFloat y =_titleLb.frame.origin.y+_titleLb.frame.size.height;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3);
    CGFloat gap=30;
    for(int i=(int)self.textStore.length;i<self.passWordNum;i++){
        
        CGContextMoveToPoint(context, gap/2+x+i*self.squareWidth, y+self.squareWidth);
        CGContextAddLineToPoint(context, x+(i+1)*self.squareWidth-gap/2, y+self.squareWidth);
        CGContextClosePath(context);
    }
    /*
     //画外框
     
     CGContextAddRect(context, CGRectMake( x, y, self.squareWidth*self.passWordNum, self.squareWidth));
     CGContextSetLineWidth(context, 1);
     CGContextSetStrokeColorWithColor(context, self.rectColor.CGColor);
     CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
     //画竖条
     for (int i = 1; i <= self.passWordNum; i++) {
     CGContextMoveToPoint(context, x+i*self.squareWidth, y);
     CGContextAddLineToPoint(context, x+i*self.squareWidth, y+self.squareWidth);
     CGContextClosePath(context);
     }
     */
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextSetFillColorWithColor(context, self.pointColor.CGColor);
    //画黑点
    for (int i=1; i<=self.textStore.length; i++) {
        CGContextAddArc(context, x+i*self.squareWidth-self.squareWidth/2.0, y+self.squareWidth, self.pointRadius, 0, M_PI*2, YES);
        CGContextDrawPath(context, kCGPathFill);
    }
}
@end
