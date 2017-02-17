//
//  ListViewController.m
//  我的日记本
//
//  Created by 周浩 on 16/11/4.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "ListViewController.h"
#import "EditViewController.h"
#import "ListCell.h"
#import "FolderTableView.h"
#import "SearchController.h"
#import "ZHTextView.h"
#import <MessageUI/MessageUI.h>
#import "SideMenu.h"

@interface ListViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>


@property(nonatomic,strong)FolderTableView      *folderTableView;
@property(nonatomic,assign)BOOL                 isShowFolderView;
@property(nonatomic,strong)UIControl            *backView;

@end

@implementation ListViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UserDefault setInteger:0 forKey:@"seletedIndex"];
    [UserDefault synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self creteBarButtonItem];
}

-(void)setup{
    
    [super setup];
    [self createNoteTableView];
    _isShowFolderView=NO;
    [self sortTbView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTbViewAction:) name:@"refreshTbView" object:nil];
    [_tbView reloadData];
}

//tbview排序
-(void)sortTbView{
    
    NSString *folderName=[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentFolderName];
    if (folderName.length==0||!folderName) {
        folderName=@"";
    }
    NSArray *array=[[NoteManager shared] notesWithFolderName:folderName];
    _dataArray=[NSMutableArray arrayWithArray:array];
    [_dataArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
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
}
-(void)refreshTbViewAction:(NSNotification *)sender{
    
    [self sortTbView];
    [_tbView reloadData];
}
-(FolderTableView *)folderTableView{
    
    if (!_folderTableView) {
        
        NSArray *array=[[NoteManager shared] allFolders];
        NSInteger count=array.count+1;
        _folderTableView=[[FolderTableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, count*44+35) style:UITableViewStylePlain];
        _folderTableView.delegate=self;
        _folderTableView.dataSource=self;
    }
    [_folderTableView.editBtn addTarget:self action:@selector(editFolderTableClickAction) forControlEvents:UIControlEventTouchUpInside];
    [_folderTableView.addBtn addTarget:self action:@selector(addFolderClickAction) forControlEvents:UIControlEventTouchUpInside];
    return  _folderTableView;
}
-(void)editFolderTableClickAction{
    
    if ([_folderTableView.editBtn.currentTitle isEqualToString:@"编辑"]) {
        
        [_folderTableView setEditing:YES animated:YES];
        [_folderTableView.editBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
    else{
        
        [_folderTableView setEditing:NO animated:YES];
        [_folderTableView.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    
}
#pragma mark- 添加文件夹 的按钮方法
-(void)addFolderClickAction{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"新建文件夹" preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *field;
    //alert添加输入框的方法
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       
        field=textField;
        field.placeholder=@"输入文件夹名称";
        field.clearButtonMode=UITextFieldViewModeWhileEditing;
    }];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    kWeakSelf(wkself)
    UIAlertAction *confirm=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *name=field.text;
        if (name.length==0||!name) {
            
            [ProgressHUD showError:@"请输入文件夹名"];
            return ;
        }
        Folder *folder=[[NoteManager shared] folderWithName:name];
        if (folder) {
            
            [ProgressHUD showError:@"该文件夹已存在"];
            return;
        }
        [[NoteManager shared] insertFolderWithId:[Tool createFid] name:name];
        NSArray *folders=[[NoteManager shared] allFolders];
        [wkself.folderTableView.foldersArray removeAllObjects];
        wkself.folderTableView.foldersArray=[NSMutableArray arrayWithArray:folders];
        CGRect frm=wkself.folderTableView.frame;
        frm.size.height+=44;
        wkself.folderTableView.frame=frm;
        [wkself.folderTableView reloadData];
    }];
    [alert addAction:cancel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma  mark -添加导航栏按钮
-(void)creteBarButtonItem{
    
     
    self.navigationItem.rightBarButtonItem=[Tool barButtomItemWithTitle:nil
                                                               imgName:@"nav_search"
                                                                target:self
                                                                action:@selector(searchBtnClickAction)];
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0,0 ,84,40)];
    UIImageView *arrowDownImv=[[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 13, 7.5)];
    arrowDownImv.image=[UIImage imageNamed:@"arrow_down"];
    UIButton *folderBtn=[[UIButton alloc] initWithFrame:CGRectMake(13, 0, 71, 40)];
    NSString *title=[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentFolderName];
    if (title.length==0||!title) {
        title=@"全部便签";
    }
    [folderBtn setTitle:title forState:UIControlStateNormal];
    [folderBtn setTitleColor:kBlack forState:UIControlStateNormal];
    folderBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [topView addSubview:arrowDownImv];
    [topView addSubview:folderBtn];
    [self.navigationItem setTitleView:topView];//设置顶部视图
    [folderBtn addTarget:self action:@selector(folderBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    _folderBtn=folderBtn;
}



-(void)addBtnClickAction{
    
    kWeakSelf(wkself)
    EditViewController *edit=[[EditViewController alloc] init];
    NSString *folderName=[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentFolderName];
    if (!folderName||folderName.length==0) {
        folderName=@"";
    }
    edit.doneActionCallBack=^{
        
        [wkself.dataArray removeAllObjects];
        NSArray *array=[[NoteManager shared] notesWithFolderName:folderName];
        wkself.dataArray=[NSMutableArray arrayWithArray:array];
        [wkself.tbView reloadData];
    };
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:edit animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}
#pragma mark -点击顶部按钮方法
-(void)folderBtnClickAction:(UIButton *)sender{
    
    if (_isShowFolderView) {
        
        [_folderTableView removeFromSuperview];
        [_backView removeFromSuperview];
        _isShowFolderView=NO;
        return;
    }
    if (!_backView) {
        
        _backView=[[UIControl alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight)];
        _backView.backgroundColor=kBlack;
        _backView.alpha=0.3;
        [_backView addTarget:self action:@selector(dismissBackView) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:_backView];
    [self.view addSubview:self.folderTableView];
}
-(void)dismissBackView{
    
    [_backView removeFromSuperview];
    [_folderTableView removeFromSuperview];
    _isShowFolderView=NO;
}
#pragma mark -搜索
-(void)searchBtnClickAction{
    
    SearchController *search=[[SearchController alloc] init];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:search animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}
#pragma mark -Note表视图
-(void)createNoteTableView{
    
    __weak typeof(self) wkself=self;
    _tbView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tbView];
    [_tbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(wkself.view);
        make.top.equalTo(@64);
    }];
    _tbView.backgroundColor=[UIColor colorWithWhite:0.96 alpha:1.0];
    _tbView.tableFooterView=[UIView new];
    _tbView.delegate=self;
    _tbView.dataSource=self;
    
}

#pragma  mark -表视图代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==_tbView) {
        
       return _dataArray.count;
    }else{
        
        return self.folderTableView.foldersArray.count+1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    kWeakSelf(wkself)
    if (tableView==_tbView) {
        static NSString *cid=@"list_cell_id";
        ListCell *cell=[tableView dequeueReusableCellWithIdentifier:cid];
        if (!cell) {
            
            cell=[[[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:nil options:nil] lastObject];
        }
        Note *note=_dataArray[indexPath.row];
        [cell configCellWithNote:note];
        //置顶的代码块定义
        cell.topActionCallBack=^(UIButton *sender){
            
            [[NoteManager shared] UpdateNoteTopState:sender.selected whereNid:note.nid];
            wkself.dataArray=[NSMutableArray arrayWithArray:[[NoteManager shared] allNotes]];
            [wkself.dataArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
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
            [wkself.tbView reloadData];
        };
        return cell;
    }else{
        
        static NSString *fid=@"folder_cell_id";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:fid];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fid];
        }
        UILabel *countLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        countLab.font=kFont(13);
        countLab.tintColor=kBlack;
        cell.accessoryView=countLab;
        if (indexPath.row==0) {
            
            cell.textLabel.text=@"全部便签";
            cell.imageView.image=[UIImage imageNamed:@"allNotes"];
        }else{
            
            Folder *folder=wkself.folderTableView.foldersArray[indexPath.row-1];
            cell.textLabel.text=folder.folderName;
            cell.imageView.image=[UIImage imageNamed:@"customlized"];
        }
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        return  cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==_tbView) {
        
        return 75;
    }else{
        
        return 44;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    kWeakSelf(wkself)
    if (tableView==_tbView) {
        
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        Note *note=_dataArray[indexPath.row];
        EditViewController *edit=[[EditViewController alloc] init];
        edit.note=note;
        edit.doneActionCallBack=^{
            
            [wkself.dataArray removeAllObjects];
            NSString *foldName=[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentFolderName];
            if (foldName.length==0||!foldName) {
                foldName=@"";
            }
            wkself.dataArray=[NSMutableArray arrayWithArray:[[NoteManager shared] notesWithFolderName:foldName]];
            [wkself.tbView reloadData];
        };
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:edit animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }else{
        
        [wkself dismissBackView];
        NSArray *selectedNotes;
        NSString *tmp=nil;
        if (indexPath.row==0) {
            
            [_folderBtn setTitle:@"全部便签" forState:UIControlStateNormal];
            selectedNotes=[[NoteManager shared] allNotes];
            tmp=@"";
        }else{
            
            Folder *folder=_folderTableView.foldersArray[indexPath.row-1];
            [_folderBtn setTitle:folder.folderName forState:UIControlStateNormal];
            selectedNotes=[[NoteManager shared] notesWithFolderName:folder.folderName];
            tmp=folder.folderName;
        }
        [[NSUserDefaults standardUserDefaults] setObject:tmp forKey:kCurrentFolderName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_dataArray removeAllObjects];
        _dataArray=[NSMutableArray arrayWithArray:selectedNotes];
        [self sortTbView];
        [_tbView reloadData];
    }
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    kWeakSelf(wkself)
    if (tableView==_tbView) {
        
        Note *note=_dataArray[indexPath.row];
        
        UITableViewRowAction *deleteAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            [[NoteManager shared] removeNoteWithNoteId:note.nid];
            [wkself.dataArray removeObjectAtIndex:indexPath.row];
            [wkself.tbView reloadData];
        }];
        
        NSMutableArray *names=[NSMutableArray array];
        NSArray *folders=[[NoteManager shared] allFolders];
        for(Folder *folder in folders){
            
            [names addObject:folder.folderName];
        }
        UITableViewRowAction *topAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"移动至" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            UIAlertController *sheet=[Tool sheetWithTitle:@"移动至" action:^(UIAlertAction *action) {
                
                NSString *nid=note.nid;
                [[NoteManager shared] updateFolderWith:action.title whereNoteID:nid];
                [wkself.dataArray removeAllObjects];
                NSString *folderName=[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentFolderName];
                if (!folderName||folderName.length==0) {
                    folderName=@"";
                }
                NSArray *array=[[NoteManager shared] notesWithFolderName:folderName];
                wkself.dataArray=[NSMutableArray arrayWithArray:array];
                [sheet dismissViewControllerAnimated:YES completion:nil];
                [wkself.tbView reloadData];
            } titleArray:names];
            [wkself presentViewController:sheet animated:YES completion:nil];
        }];
        topAction.backgroundColor=[UIColor orangeColor];
        
        UITableViewRowAction *shareAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"分享" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            UIImage *image=[self renderingImageWithNote:note];//把note输出成图片
            UIAlertController *sheet=[UIAlertController alertControllerWithTitle:@"分享至" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *picture=[UIAlertAction actionWithTitle:@"输出成图片保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
                HUDSuccess(@"保存成功")
            }];
            UIAlertAction *mail=[UIAlertAction actionWithTitle:Localizable(@"发送邮件") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self sendEmailWithImage:image title:Localizable(@"发送邮件")];
            }];
            UIAlertAction *share=[UIAlertAction actionWithTitle:@"其他平台" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self socialActionWithImage:image title:Localizable(@"")];
            }];
            UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [sheet dismissViewControllerAnimated:YES completion:nil];
            }];
            [sheet addAction:picture];
            [sheet addAction:mail];
            [sheet addAction:share];
            [sheet addAction:cancel];
            [wkself presentViewController:sheet animated:YES completion:nil];
        }];
        return @[deleteAction,topAction,shareAction];
    }else{
        
        UITableViewRowAction *deleteAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            CGRect frm=wkself.folderTableView.frame;
            frm.size.height-=44;
            wkself.folderTableView.frame=frm;
            Folder *folder=wkself.folderTableView.foldersArray[indexPath.row-1];
            NSString *deleteFolder=folder.folderName;
            if ([_folderBtn.currentTitle isEqualToString:deleteFolder]) {
                
                [_folderBtn setTitle:@"全部便签" forState:UIControlStateNormal];
            }
            //删掉 已删文件夹里的文件
            NSArray *deleteArray=[[NoteManager shared] notesWithFolderName:deleteFolder];
            for(Note *note in deleteArray){
                
                [wkself.dataArray removeObject:note];
                [[NoteManager shared] removeNoteWithNoteId:note.nid];
            }
            [wkself.tbView reloadData];
            
            [[NoteManager shared] removeFolderWhereFolderId:folder.fid];
            [wkself.folderTableView.foldersArray removeObjectAtIndex:indexPath.row-1];
            [wkself.folderTableView reloadData];
        }];
        return @[deleteAction];
    }
}
//加上此方法修复真机无法左滑的bug
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==_tbView) {
        
        return UITableViewCellEditingStyleDelete;
    }else{
        
        if(indexPath.row==0){
            
            return UITableViewCellEditingStyleNone;
        }
        return UITableViewCellEditingStyleDelete;
    }
}
#pragma mark -渲染成图片
-(UIImage *)renderingImageWithNote:(Note *)note{
    
    EditViewController *edit=[[EditViewController alloc] initWithNote:note];
    edit.view.backgroundColor=kWhite;//不设置颜色保存不成功，得不到图片
     ZHTextView*textView=edit.contentView;
    CGFloat totalHeight=edit.view.frame.size.height;
    [textView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(totalHeight));
    }];
    UIGraphicsBeginImageContext(CGSizeMake(kWidth, totalHeight+40));
    [edit.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef ref=CGImageCreateWithImageInRect(image.CGImage, CGRectMake(10, 64, kWidth-20,totalHeight+40));
    image=[UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    return image;
}
#pragma mark - 发邮件
-(void)sendEmailWithImage:(UIImage *)image title:(NSString *)title{


    MFMailComposeViewController*mail=[[MFMailComposeViewController alloc]init];
    mail.mailComposeDelegate=self;
    [mail setSubject:title];
    [mail addAttachmentData:UIImagePNGRepresentation(image) mimeType:@"image/png" fileName:@"file1"];
    
//    [mail setCcRecipients:@[@"332985289@qq.com"]];设置收件人
//    [mail setCcRecipients:@[@"1196110740@qq.com"]];设置抄送人
    if(mail){
        
        [self presentViewController:mail animated:YES completion:nil];
    }
}

#pragma mark - 其他平台
-(void)socialActionWithImage:(UIImage *)image title:(NSString *)title{
    
    if(!image){
        return;
    }
    UIActivityViewController *activity=[[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    [self presentViewController:activity animated:YES completion:nil];
}
#pragma MFMailComposeViewControllerDelegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    if (result==MFMailComposeResultSent) {
        
        HUDSuccess(@"发送成功")
    }
    else if(result==MFMailComposeResultFailed){
        
        HUDError(error.localizedDescription)
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
