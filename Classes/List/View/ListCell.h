//
//  ListCell.h
//  我的日记本
//
//  Created by 周浩 on 16/12/5.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Note;

@interface ListCell : UITableViewCell

@property(nonatomic,copy)void (^topActionCallBack)(UIButton *sender);

-(void)configCellWithNote:(Note *)note;

@end
