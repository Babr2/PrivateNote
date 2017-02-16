 //
//  PesonalCenterViewController.m
//  我的日记本
//
//  Created by 周浩 on 16/12/21.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "PesonalCenterViewController.h"
#import "ModifyNameViewController.h"

@interface PesonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong) UITableView *tbView;
@property(nonatomic,strong) NSArray     *titles;
@property(nonatomic,strong) UILabel     *timeLab;
kStrongProperty(UILabel, nameLab)
kStrongProperty(UIImageView, headImageView)
kStringProperty(imageURL)
@end

@implementation PesonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self createUI];
    
}
-(void)createUI{
    
    self.title=@"个人中心";
    UIImage *back=[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:back style:UIBarButtonItemStyleDone target:self action:@selector(backAcion)];
    _tbView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, kWidth,kHeight-64) style:UITableViewStylePlain];
    [self.view addSubview:_tbView];
    _tbView.backgroundColor=[UIColor colorWithWhite:0.98 alpha:1.0];
    _tbView.delegate=self;
    _tbView.dataSource=self;
    
    UIView *headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 150)];
    UIImageView *headIMageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    headIMageView.clipsToBounds=YES;
    headIMageView.userInteractionEnabled=YES;
    headIMageView.layer.cornerRadius=40;
    headIMageView.backgroundColor=[UIColor grayColor];
    NSString *imageURLString=[UserDefault objectForKey:kHeadimageURL];
    NSURL *url=[NSURL URLWithString:imageURLString];
    [headIMageView sd_setImageWithURL:url placeholderImage:nil];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addHeadImageAction)];
    [headIMageView addGestureRecognizer:tap];
    _headImageView=headIMageView;
    [headView addSubview:headIMageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@80);
        make.left.equalTo(headView).offset((kWidth-80)/2);
        make.top.equalTo(headView).offset(25);
    }];
    
    UILabel *nameLab=[[UILabel alloc] initWithFrame:CGRectZero  ];
    nameLab.text=[UserDefault objectForKey:kNickName];
    nameLab.font=kFont(12);
    nameLab.textAlignment=NSTextAlignmentCenter;
    nameLab.textColor=kblue;
    _nameLab=nameLab;
    [headView addSubview:nameLab];
    [nameLab makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@80);
        make.height.equalTo(@20);
        make.left.equalTo(headView).offset((kWidth-80)/2);
        make.top.equalTo(headIMageView.mas_bottom).offset(20);
    }];
    
    UIView *footView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight-300)];
    UILabel *timeLab=[[UILabel alloc] initWithFrame:CGRectZero];
    NSString *GMT=[UserDefault objectForKey:kLastSyncTime];
    NSString *lastSyncTime=[Tool dateWithIntervalSince1970:GMT.integerValue];
    timeLab.text=[NSString stringWithFormat:@"上次同步：%@",lastSyncTime];
    timeLab.font=kFont(10);
    timeLab.textAlignment=NSTextAlignmentCenter;
    _timeLab=timeLab;
    [footView addSubview:timeLab];
    [timeLab makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@160);
        make.height.equalTo(@20);
        make.left.equalTo(footView).offset((kWidth-160)/2);
        make.top.equalTo(footView).offset(5);
    }];
    
    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectZero];
    backBtn.backgroundColor=kRed;
    backBtn.titleLabel.font=kFont(14);
    [backBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(quitLoginClickAction:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.layer.cornerRadius=5;
    [footView addSubview: backBtn];
    [backBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@260);
        make.height.equalTo(@40);
        make.left.equalTo(footView).offset((kWidth-260)/2);
        make.top.equalTo(timeLab.mas_bottom).offset(40);
    }];
    
    _tbView.tableFooterView=footView;
    _tbView.tableHeaderView=headView;
    _titles=@[@[@"修改昵称",@"设置头像"],@[@"同步本地便签"]];
}
-(void)backAcion{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}
-(void)quitLoginClickAction:(UIButton *)sender{
    
    sender.enabled=NO;
    [UserDefault removeObjectForKey:kAccessToken];
    [UserDefault removeObjectForKey:kLastSyncTime];
    [UserDefault removeObjectForKey:kNickName];
    [UserDefault removeObjectForKey:kHeadimageURL];
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserdidLoginoutNotfifaction object:nil];
}
-(void)addHeadImageAction{
    
    UIAlertController *sheet=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof (self) wkself=self;
    UIAlertAction *alumbAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"选择照片",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [wkself showImagePickerWitType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *cameraAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"拍摄照片",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [wkself showImagePickerWitType:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:nil];
    
    [sheet addAction:alumbAction];
    [sheet addAction:cameraAction];
    [sheet addAction:cancelAction];
    
    [self presentViewController:sheet animated:YES completion:nil];
}
-(void)showImagePickerWitType:(UIImagePickerControllerSourceType)type{
    
    if(![UIImagePickerController isSourceTypeAvailable:type]){
        
        NSString *msg=@"相册不可用";
        if(type==UIImagePickerControllerSourceTypeCamera){
            
            msg=@"相机不可用";
        }
        UIAlertController *nameAlert=[UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:nameAlert animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [nameAlert dismissViewControllerAnimated:YES completion:nil];
        });
        return;
    }
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.delegate=self;
    picker.sourceType=type;
    picker.allowsEditing=YES;
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    [self uploadHeadImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  [_titles[section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _titles.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cid=@"personal_cell_id";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cid];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
    }
    cell.textLabel.text=_titles[indexPath.section][indexPath.row];
    cell.textLabel.font=kFont(14);
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        
        cell.textLabel.textColor=kblue;
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
    }
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 0;
    }else{
       return 30;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    kWeakSelf(wkself)
    if ([cell.textLabel.text isEqualToString:@"修改昵称"]) {
        
        ModifyNameViewController *modify=[[ModifyNameViewController alloc] init];
        modify.name=[_nameLab.text copy];
        modify.doneActionCallBack=^(NSString *newName){
            
            wkself.nameLab.text=[newName copy];
            [self modifyNickName:newName];
        };
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:modify animated:YES];
    }
    else if([cell.textLabel.text isEqualToString:@"设置头像"]){
        
        [self addHeadImageAction];
    }
    else{
        
        UIAlertController *sync=[UIAlertController alertControllerWithTitle:Localizable(@"同步到") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cloud=[UIAlertAction actionWithTitle:Localizable(@"服务器") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [wkself syncToServerBtn];
        }];
        UIAlertAction *local=[UIAlertAction actionWithTitle:Localizable(@"本地") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [wkself syncToLocalBtn];
        }];
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:Localizable(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [sync dismissViewControllerAnimated: YES completion:nil];
        }];
        [sync addAction:cloud];
        [sync addAction:local];
        [sync addAction:cancel];
        [self presentViewController:sync animated:YES completion:nil];
    }
}
-(void)modifyNickName:(NSString *)newName{
    
    NSString *token=[UserDefault objectForKey:kAccessToken];
    NSString *params=[NSString stringWithFormat:@"token=%@&nick_name=%@",token,newName];
    NSString *url=[NSString stringWithFormat:@"%@?%@",kSetNicknameUrl,params];
    [[ZhRequest request] get:url success:^(NSData *data) {
        
        if (!data||data.length==0) {
            
            HUDError(@"获取不到数据")
            return ;
        }
        id obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (![obj isKindOfClass:[NSDictionary class]]) {
            
            HUDError(@"服务器内部错误")
            return;
        }
        BOOL ret=[[obj objectForKey:@"result"] boolValue];
        NSString *error=[obj objectForKey:@"error"];
        NSString *nickName=[obj objectForKey:@"nick_name"];
        if (!ret) {
            
            HUDError(error)
            return;
        }
        [UserDefault setObject:nickName forKey:kNickName];
        [UserDefault synchronize];
        
    } failure:^(NSError *error) {
        
        HUDError(error.localizedDescription)
        return ;
    }];
}
#pragma mark -上传头像
-(void)uploadHeadImage:(UIImage *)newImage{
    
    kWeakSelf(wkself)
    NSString *token=[UserDefault objectForKey:kAccessToken];
    NSLog(@"%@",token);
    NSString *urlString=[NSString stringWithFormat:@"%@?token=%@",kUploadImageUrl,token];
    [[ZhRequest request] uploadMultiFileToHost:urlString imgs:@[newImage] name:@"file" mimeType:@"image/jpeg" paramaters:nil success:^(NSData *data, NSURLResponse *response) {
        
        if (data.length==0||!data) {
            
            HUDError(@"获取不到数据")
            return ;
        }
        id obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (![obj isKindOfClass:[NSDictionary class]]) {
            
            HUDError(@"服务器内部错误")
            return;
        }
        NSString *imageURL=[[obj objectForKey:@"img"] firstObject];
        [wkself setHeadImageWithUrl:imageURL];
    } failure:^(NSError *error) {
        
        HUDError(error.localizedDescription)
    }];
}
#pragma  mark -设置头像
-(void)setHeadImageWithUrl:(NSString *)imageurl{
    
    kWeakSelf(wkself)
    NSString *token=[UserDefault objectForKey:kAccessToken];
    NSString *parmas=[NSString stringWithFormat:@"token=%@&image_url=%@",token,imageurl];
    NSString *url=[NSString stringWithFormat:@"%@?%@",kSetHeadImgUrl,parmas];
    NSLog(@"%@",url);
    [[ZhRequest request] get:url success:^(NSData *data) {
        
        if (data.length==0||!data) {
            
            HUDError(@"获取不到数据")
            return ;
        }
        id obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (![obj isKindOfClass:[NSDictionary class]]) {
            
            HUDError(@"服务器内部错误")
            return;
        }
        BOOL ret=[[obj objectForKey:@"result"] boolValue];
        NSString *error=[obj objectForKey:@"error"];
        NSString *imgString=[obj objectForKey:@"img"];
        [UserDefault setObject:imgString forKey:kHeadimageURL];
        [UserDefault synchronize];
        if (!ret) {
            
            HUDError(error)
        }
        NSURL *imgURL=[NSURL URLWithString:imgString];
        [wkself.headImageView sd_setImageWithURL:imgURL];
        HUDSuccess(@"设置成功")
    } failure:^(NSError *error) {
        
        HUDError(error.localizedDescription)
        return ;
    }];
}

#pragma mark - 同步到服务器
-(void)syncToServerBtn{
    
//    sender.enabled=NO;
    id obj=[[NoteManager shared] jsonObjectWithAllNotes];
    NSData *data=[NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    NSString *token=[UserDefault objectForKey:kAccessToken];
    NSString *params=[NSString stringWithFormat:@"token=%@&identifier=1",token];
    NSString *urlString=[NSString stringWithFormat:@"%@?%@",kSyncToServerUrl,params];
    HUDShowLoading
    [[ZhRequest request] uploadMultiFileToHost:urlString data:@[data] name:@"file" mimeType:@"application/json" paramaters:nil success:^(NSData *data, NSURLResponse *response) {
        
        if(data.length==0||!data){
            HUDError(@"未知错误")
//            sender.enabled=YES;
            return ;
        }
        id obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",obj);
        if(![obj isKindOfClass:[NSDictionary class]]){
            
            HUDError(@"未知错误")
//            sender.enabled=YES;
            return ;
        }
        BOOL result=[[obj objectForKey:@"result"] boolValue];
        if(!result){
            
            NSString *err=[obj objectForKey:@"error"];
            HUDError(err)
//            sender.enabled=YES;
            return;
        }
        NSInteger interval=[[obj objectForKey:@"last_sync_time"] integerValue];
        NSString *time=[Tool dateWithIntervalSince1970:interval];
        [UserDefault setObject:time forKey:kLastSyncTime];
        [UserDefault synchronize];
        kWeakSelf(wkself)
        HUDSuccess(@"同步成功")
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            sender.enabled=YES;
            wkself.timeLab.text=[NSString stringWithFormat:@"%@：%@",Localizable(@"上次同步"),time];
        });
//        [MobClick event:@"Sync"];
        
    } failure:^(NSError *error) {
        
        HUDError(error.localizedDescription);
//        sender.enabled=YES;
    }];
}

#pragma mark - 同步到本地
-(void)syncToLocalBtn{
    
    NSString *token=[UserDefault objectForKey:kAccessToken];
    NSString *params=[NSString stringWithFormat:@"token=%@&identifier=0",token];
    NSString *urlString=[NSString stringWithFormat:@"%@?%@",kSyncToServerUrl,params];
    NSURL *url=[NSURL URLWithString:urlString];
    HUDShowLoading
    kWeakSelf(wkself)
    dispatch_queue_t task_queue=dispatch_queue_create("sync_queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(task_queue, ^{
        
        NSData *data=[NSData dataWithContentsOfURL:url];
        if(data.length==0||!data){
            HUDError(@"未知错误")
            return ;
        }
        id obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"%@",obj);
        if(![obj isKindOfClass:[NSDictionary class]]){
            
            HUDError(@"未知错误")
            
            return ;
        }
        BOOL result=[[obj objectForKey:@"result"] boolValue];
        if(!result){
            
            NSString *err=[obj objectForKey:@"error"];
            HUDError(err)
            
            return;
        }
        
        [[NoteManager shared] handleSynclizedData:obj completion:^{
            
            NSInteger interval=[[obj objectForKey:@"last_sync_time"] integerValue];
            NSString *time=[Tool dateWithIntervalSince1970:interval];
            
            [UserDefault setObject:time forKey:kLastSyncTime];
            [UserDefault synchronize];
            
            HUDSuccess(@"同步成功")
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                wkself.timeLab.text=[NSString stringWithFormat:@"%@：%@",Localizable(@"上次同步"),time];
            });
            
        } error:^{
            
            HUDDismiss
            
        }];
    });
}

@end
