

//
//  SideView.m
//  PrivateNote
//
//  Created by 风过的夏 on 17/2/15.
//  Copyright © 2017年 周浩. All rights reserved.
//

#import "SideView.h"
#import "AppDelegate.h"
#import "ListViewController.h"
#import "EditViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"

@interface SideView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView                      *tbView;
@property(nonatomic,strong)NSArray                              *dataArray;

@property(nonatomic,strong)UINavigationController   *addNavi;
@property(nonatomic,strong)UINavigationController   *settingNavi;
@property(nonatomic,strong)UIButton                         *signOutBtn;
@property(nonatomic,strong)UILabel                          *nickNameLb;
@property(nonatomic,strong)UIImageView                  *headImageView;
@end

@implementation SideView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self=[super initWithFrame:frame]){
        
        [self setup];
        [self createUI];
        [self refreshUI];
    }
    return self;
}
-(void)setup{
    
    _dataArray=@[@"日记列表",@"写日记",@"设置"];
    self.backgroundColor=[UIColor whiteColor];
    _settingNavi=[[UINavigationController alloc] initWithRootViewController:[SettingViewController new]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:kUerdidLoginNotifaction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:kUserdidLoginoutNotfifaction object:nil];
}
-(void)createUI{
    
    _tbView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self addSubview:_tbView];
    _tbView.delegate=self;
    _tbView.dataSource=self;
    __weak typeof(self) wkself=self;
    [_tbView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(wkself).insets(UIEdgeInsetsMake(0, 0, 60, 0));
    }];
    _tbView.tableHeaderView=[self createTableHeaderView];
    _tbView.tableFooterView=[self createTableFooterView];
    UIButton *signOutBtn=[Tool makeBtnFrame:CGRectZero
                                      title:Localizable(@"退出登录")
                                  textColor:kWhite
                                  imageName:nil
                            backgroundColor:kWhite
                                     target:self
                                     action:@selector(signOutClickAction:)];
    signOutBtn.backgroundColor=[UIColor redColor];
    signOutBtn.layer.cornerRadius=4;
    [self addSubview:signOutBtn];
    _signOutBtn=signOutBtn;
    [signOutBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(wkself).offset(20);
        make.right.equalTo(wkself).offset(-20);
        make.bottom.equalTo(wkself).offset(-10);
        make.height.equalTo(@40);
    }];
}
-(void)refreshUI{
    
    NSString *token=[UserDefault objectForKey:kAccessToken];
    if (!token||token.length==0 ) {
        
        _headImageView.image=nil;
        _nickNameLb.text=nil;
        _signOutBtn.hidden=YES;
        
    }else{
        
        NSString *imageURLString=[UserDefault objectForKey:kHeadimageURL];
        NSURL *url=[NSURL URLWithString:imageURLString];
        [_headImageView sd_setImageWithURL:url];
        _nickNameLb.text=[[UserDefault objectForKey:kNickName] copy];
        _signOutBtn.hidden=NO;
    }
}
-(UIView *)createTableHeaderView{
    
    UIView *header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSideWidth, 140)];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    [header addSubview:imageView];
    imageView.backgroundColor=kLightGray;
    imageView.clipsToBounds=YES;
    imageView.layer.cornerRadius=40;// 这种是低效率的圆角实现，高效率实现圆形图片
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.equalTo(@(80));
        make.centerX.equalTo(header);
        make.top.equalTo(header).offset(25);
    }];
    _headImageView=imageView;
    
    UILabel *nickLab=[[UILabel alloc] initWithFrame:CGRectZero];
    [header addSubview:nickLab];
    nickLab.textColor=kblue;
    
    nickLab.font=kFont(14);
    nickLab.textAlignment=NSTextAlignmentCenter;
   [nickLab makeConstraints:^(MASConstraintMaker *make) {
       
       make.left.equalTo(header).offset(10);
       make.right.equalTo(header).offset(-10);
       make.top.equalTo(imageView.mas_bottom).offset(5);
       make.height.equalTo(@15);
   }];
    _nickNameLb=nickLab;
    
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
-(void)signOutClickAction:(UIButton *)sender{
    
    sender.enabled=NO;
    [UserDefault removeObjectForKey:kAccessToken];
    [UserDefault removeObjectForKey:kLastSyncTime];
    [UserDefault removeObjectForKey:kNickName];
    [UserDefault removeObjectForKey:kHeadimageURL];
    [self refreshUI];
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
    UINavigationController  *navi=(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    NSInteger seletedIndex=[UserDefault integerForKey:@"seletedIndex"];
    if(indexPath.row==0){
        
        [navi popToRootViewControllerAnimated:YES];
        
    }else if(indexPath.row==1){
        
        if(seletedIndex!=indexPath.row){
            
            EditViewController *edit=[EditViewController new];
            edit.doneActionCallBack=^{
              
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTbView" object:nil];
            };
            [navi pushViewController:edit animated:YES];
        }
        
    }else{
        
        if(seletedIndex!=indexPath.row){
            
            SettingViewController *setting=[SettingViewController new];
            [navi pushViewController:setting animated:YES];
        }
    }
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app hideMenu];
    //记录按下侧边栏某个选项后的ListViewController选项
    [UserDefault setInteger:indexPath.row forKey:@"seletedIndex"];
    [UserDefault synchronize];
}


@end
