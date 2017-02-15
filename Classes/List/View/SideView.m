

//
//  SideView.m
//  PrivateNote
//
//  Created by 风过的夏 on 17/2/15.
//  Copyright © 2017年 周浩. All rights reserved.
//

#import "SideView.h"
#import "SideMenu.h"
#import "ListViewController.h"
#import "EditViewController.h"
#import "SettingViewController.h"

@interface SideView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView  *tbView;
@property(nonatomic,strong)NSArray      *dataArray;

@property(nonatomic,strong)UINavigationController *addNavi;
@property(nonatomic,strong)UINavigationController *settingNavi;

@end

@implementation SideView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self=[super initWithFrame:frame]){
        
        [self setup];
        [self createUI];
    }
    return self;
}
-(void)setup{
    
    _dataArray=@[@"日记列表",@"写日记",@"设置"];
    _addNavi=[[UINavigationController alloc] initWithRootViewController:[EditViewController new]];
    _settingNavi=[[UINavigationController alloc] initWithRootViewController:[SettingViewController new]];
}
-(void)createUI{
    
    _tbView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self addSubview:_tbView];
    _tbView.delegate=self;
    _tbView.dataSource=self;
    __weak typeof(self) wkself=self;
    [_tbView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(wkself);
    }];
    _tbView.tableHeaderView=[self createTableHeaderView];
    _tbView.tableFooterView=[self createTableFooterView];
}
-(UIView *)createTableHeaderView{
    
    UIView *header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSideWidth, 120)];
    
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor=[UIColor colorWithWhite:0.2 alpha:1];
    [header addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.right.equalTo(header);
        make.bottom.equalTo(header);
        make.height.equalTo(@1);
    }];
    
    return header;
}
-(UIView *)createTableFooterView{
    
    UIView *footer=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSideWidth, 60)];
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor=[UIColor colorWithWhite:0.2 alpha:1];
    [footer addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(footer);
        make.top.equalTo(footer);
        make.height.equalTo(@1);
    }];
    
    
    return footer;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cid=@"side_menu_cell_id";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cid];
    if(!cell){
        
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
        cell.textLabel.font=kFont(15);
    }
    cell.textLabel.text=[_dataArray[indexPath.row] copy];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger seletedIndex=[UserDefault integerForKey:@"seletedIndex"];
    if(indexPath.row==0){
        
        if(seletedIndex==1){
            
            [_addNavi dismissViewControllerAnimated:YES completion:nil];
            
        }else if(seletedIndex==2){
            
            [_settingNavi dismissViewControllerAnimated:YES completion:nil];
        }
        
    }else if(indexPath.row==1){
        
        if(seletedIndex==0){
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:_addNavi animated:YES completion:nil];
            
        }else if(seletedIndex==2){
            
            [_settingNavi dismissViewControllerAnimated:NO completion:nil];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:_addNavi animated:YES completion:nil];
        }
        
    }else{
        
        if(seletedIndex==0){
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:_settingNavi animated:YES completion:nil];
            
        }else if(seletedIndex==1){
            
            [_addNavi dismissViewControllerAnimated:NO completion:nil];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:_settingNavi animated:YES completion:nil];
        }
    }
    [SideMenu show];
    [UserDefault setInteger:indexPath.row forKey:@"seletedIndex"];
    [UserDefault synchronize];
}


@end
