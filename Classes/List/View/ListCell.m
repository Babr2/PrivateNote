//
//  ListCell.m
//  我的日记本
//
//  Created by 周浩 on 16/12/5.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "ListCell.h"


@interface ListCell()

@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UIView *line;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UIButton *starButton;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIImageView *previewImageView;

@end

@implementation ListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.previewImageView.layer.cornerRadius=20;
    [self.starButton addTarget:self action:@selector(changeLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *noImage=[UIImage imageNamed:@"top_no"];
    UIImage *yesImage=[UIImage imageNamed:@"top_yes"];
    [self.starButton setImage:noImage forState:UIControlStateNormal];
    [self.starButton setImage:yesImage forState:UIControlStateSelected];
}

-(void)configCellWithNote:(Note *)note{
    
    self.titleLab.text=note.title;
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    NSDate *date=[formatter dateFromString:note.date];
    NSString *week=[Tool weekFromDate:date];
    _timeLab.text=[NSString stringWithFormat:@"%@ %@",note.date,week];
    if (note.top) {
        
        _starButton.selected=YES;
        _backView.backgroundColor=kRed;
        
    }else{
        
        _starButton.selected=NO;
        _backView.backgroundColor=kLightGray;
    }
    
    NSString *content=[note.content copy];
    NSRange startRange=[content rangeOfString:@"<image>image_key:"];
    if(startRange.location==NSNotFound) {
        
        return;
    }
    NSRange endRange=[content rangeOfString:@":image_key</image>"];
    NSRange imageKeyRange=NSMakeRange(startRange.location, endRange.location+endRange.length-startRange.location);
    NSString *imageKey=[content substringWithRange:imageKeyRange];
    NSString *imageString=[[note.imagesArray firstObject] objectForKey:imageKey];
    NSData *data=[[NSData alloc] initWithBase64EncodedString:imageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image=[[UIImage alloc] initWithData:data];
    _previewImageView.image=image;

}
-(void)changeLikeAction:(UIButton *)sender{
    
    sender.selected=!sender.selected;
    
    if(self.topActionCallBack){
        
        self.topActionCallBack(sender);
    }
}
@end
