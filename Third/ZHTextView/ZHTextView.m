//
//  ZHTextView.m
//  带placeholder的UITextView
//
//  Created by 周浩 on 16/10/21.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "ZHTextView.h"

@implementation ZHTextView{
    
    UILabel *_placeHolderLabel;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self=[super initWithFrame:frame]){
        
        [self addPlaceHolderLabel];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textChangeActioon:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
        
    }
    return self;
}
-(void)textChangeActioon:(NSNotification *)sender{
    //假如通知中心通知的是此textview
    if(sender.object!=self){
        
        return;
    }
    if(self.text.length>0){
        
        _placeHolderLabel.hidden=YES;
    }
    else{
        
        _placeHolderLabel.hidden=NO;
    }
}
//重写textview的text set方法
-(void)setText:(NSString *)text{
    
    [super setText:text];
    if(text.length>0){
        
        _placeHolderLabel.hidden=YES;
    }
    else{
        _placeHolderLabel.hidden=NO;
    }
}
-(void)addPlaceHolderLabel{
    
    CGRect frm=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height>30?30:self.bounds.size.height);
    _placeHolderLabel=[[UILabel alloc] initWithFrame:frm];
    [self addSubview:_placeHolderLabel];
    _placeHolderLabel.textColor=[UIColor lightGrayColor];
}
-(void)setFont:(UIFont *)font{
    
    [super setFont:font];
    _placeHolderLabel.font=font;
    if(self.placeHolder.length>0){
     
        CGFloat fixValue=4.0;
        CGFloat placeHolderTextHeight=[self.placeHolder boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height+fixValue;
        placeHolderTextHeight=placeHolderTextHeight>self.bounds.size.width?self.bounds.size.width:placeHolderTextHeight;
        CGRect frm=_placeHolderLabel.frame;
        frm.size.height=placeHolderTextHeight;
        _placeHolderLabel.frame=frm;
    }
}
//为self添加placeholder属性
-(void)setPlaceHolder:(NSString *)placeHolder{
    
    _placeHolder=placeHolder;
    _placeHolderLabel.text=[placeHolder copy];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
