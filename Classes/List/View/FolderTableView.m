//
//  FolderTableView.m
//  我的日记本
//
//  Created by 周浩 on 16/12/8.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "FolderTableView.h"
#import "ListViewController.h"
@implementation FolderTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self=[super initWithFrame:frame style:style]) {
        
        _foldersArray=[NSMutableArray arrayWithArray:[[NoteManager shared] allFolders]];
        self.tableFooterView=[self createFooterView];
    }
    return  self;
}

-(UIView *)createFooterView{
    
    UIView *contenView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 35)];
    
    NSArray *titles=@[@"编辑",@"新建"];
    CGFloat width=40;
    CGFloat height=20;
    CGFloat marginx=10;
    CGFloat gapx=30;
    CGFloat marginy=5;
    for(int i=0;i<titles.count;i++){
        
        CGFloat xpos=marginx+(width+gapx)*i;
        CGFloat ypos=marginy;
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(xpos, ypos, width, height)];
        if (i==0) {
            self.editBtn=btn;
        }else{
            self.addBtn=btn;
        }
        btn.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        btn.layer.borderWidth=1;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius=5;
        [contenView addSubview:btn];
    }
    return contenView;
}


@end
