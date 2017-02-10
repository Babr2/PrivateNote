//
//  FolderTableView.h
//  我的日记本
//
//  Created by 周浩 on 16/12/8.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderTableView : UITableView 

@property(nonatomic,strong) UIButton *editBtn;
@property(nonatomic,strong) UIButton *addBtn;
@property(nonatomic,strong) NSMutableArray *foldersArray;

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end
