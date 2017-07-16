 //
//  SearchController.m
//  我的日记本
//
//  Created by 周浩 on 16/12/10.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "SearchController.h"
#import "ListCell.h"
#import "EditViewController.h"
@interface SearchController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UIButton    *cancelBtn;
@property(nonatomic,strong)UITableView *tbView;
@property(nonatomic,strong)NSMutableArray *resultArray;

@end

@implementation SearchController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self setup];
}
-(void)createUI{
    
    [self createSearchBar];
    [self createTableView];
}
-(void)setup{
    
    self.view.backgroundColor=[UIColor colorWithWhite:0.98 alpha:1.0];
    NSString *keywords=[_searchBar.text copy];
    _resultArray=[NSMutableArray arrayWithArray:[[NoteManager shared] notesWithKeywords:keywords]];
}
-(void)createSearchBar{

    _searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, kWidth, 40)];
    _searchBar.barStyle=UISearchBarStyleDefault;
    _searchBar.placeholder=@"搜索关键字";
    _searchBar.delegate=self;
    [self.view addSubview:_searchBar];
    for(UIView *view in [[_searchBar subviews] firstObject].subviews){
        
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            
            [view removeFromSuperview];
        }
//        if ([view isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
//            
//            UIButton *btn=(UIButton *)view;
//            [btn setTitle:@"取消" forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            btn.titleLabel.font=[UIFont systemFontOfSize:14];
//            [btn addTarget:self action:@selector(cancelClickAction) forControlEvents:UIControlEventTouchUpInside];
//        }
    }
    _searchBar.showsCancelButton=YES;
    [self searchBarShouldBeginEditing:_searchBar];
}
-(void)cancelClickAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createTableView{
    
    __weak typeof(self) wkself=self;
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, 64, kWidth, 0.5)];
    [self.view addSubview:line];
    line.backgroundColor=[UIColor grayColor];
    _tbView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tbView];
    [_tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wkself.view);
        make.bottom.equalTo(wkself.view).offset(-44);
        make.top.equalTo(@64.5);
    }];
    _tbView.backgroundColor=[UIColor colorWithWhite:0.96 alpha:1.0];
    _tbView.tableFooterView=[UIView new];
    _tbView.delegate=self;
    _tbView.dataSource=self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _resultArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self)wkself=self;
    static NSString *sid=@"search_cell_id";
    ListCell *cell=[tableView dequeueReusableCellWithIdentifier:sid];
    if (!cell) {
        
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:nil options:nil] lastObject];
    }
    Note *note=_resultArray[indexPath.row];
    [cell configCellWithNote:note];
    cell.topActionCallBack=^(UIButton *sender){
        
        [[NoteManager shared] UpdateNoteTopState:sender.selected whereNid:note.nid];
        NSString *keywords=[_searchBar.text copy];
        wkself.resultArray=[NSMutableArray arrayWithArray:[[NoteManager shared] notesWithKeywords:keywords]];
        [wkself.resultArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            Note *n1=obj1;
            Note *n2=obj2;
            if(n1.top>n2.top){
                
                return NSOrderedAscending;
                
            }else if(n1.top<n2.top){
                
                return NSOrderedDescending;
                
            }else{
                
                return [n2.date compare:n1.date];
            }
        }];
        [wkself.tbView reloadData];//resultArray有更改 就要reloadData
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    Note *note=_resultArray[indexPath.row];
    EditViewController *edit=[[EditViewController alloc] init];
    edit.note=note;
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:edit animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}
#pragma  mark -搜索代理方法
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    [_searchBar resignFirstResponder];
    for(UIView *view in [[_searchBar subviews] firstObject].subviews){
        
        if ([view isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            
            UIButton *btn=(UIButton *)view;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(cancelClickAction) forControlEvents:UIControlEventTouchUpInside];
            btn.enabled=YES;
        }
    }
    return YES;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [_resultArray removeAllObjects];
    [_resultArray addObjectsFromArray:[[NoteManager shared] notesWithKeywords:searchText]];
    [_tbView reloadData];
}

@end
