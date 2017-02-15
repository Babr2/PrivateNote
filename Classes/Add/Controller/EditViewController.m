//
//  EditViewController.m
//  我的日记本
//
//  Created by 周浩 on 16/11/7.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "EditViewController.h"
#import "ZHTextView.h"
#import "ListViewController.h"


@interface EditViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>

@property(nonatomic,strong) UITextField *titleField;

@property(nonatomic,assign) BOOL        isChanged;

@end

@implementation EditViewController

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
    [self setup];
    [self createUI];
    [self parse];
}
-(instancetype)initWithNote:(Note *)note{
    
    if (self=[super init]) {
        
        self.note=note;
    }
    return  self;
}
-(void)setup{

    [super setup];
    _isChanged=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboarChangeAction:) name:UIKeyboardDidChangeFrameNotification object:nil];
}
-(void)keyboarChangeAction:(NSNotification *)sender{
    
    kWeakSelf(wkself)
    CGRect frm=[[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [_contentView updateConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(wkself.view).offset(frm.origin.y-self.view.frame.size.height);
    }];
}
-(void)createUI{
    
    //自定义导航栏
    UIView *naviView=[[UIView alloc] init];
    naviView.backgroundColor=[UIColor colorWithWhite:0.96 alpha:1];
    [self.view addSubview:naviView];
    __weak typeof(self) wkself=self;
    [naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(wkself.view);
        make.top.equalTo(wkself.view);
        make.height.equalTo(@64);
    }];
    //添加自定义返回按钮（隐藏系统自带的）
    UIButton *btn=[[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(wkself.view);
        make.top.equalTo(@20);
        make.size.mas_equalTo(CGSizeMake(60, 44));
    }];
    //添加导航栏存储按钮
    UIButton *storageBtn=[[UIButton alloc] init];
    [storageBtn setTitle:NSLocalizedString(@"存储", nil) forState:UIControlStateNormal];
    [storageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    storageBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [storageBtn addTarget:self action:@selector(storageArticleAction) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:storageBtn];
    [storageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(wkself.view).offset(-10);
        make.top.equalTo(@20);
        make.size.mas_equalTo(CGSizeMake(40, 44));
    }];
    //添加导航栏上传按钮
    UIButton *mediaBtn=[[UIButton alloc] init];
    [mediaBtn setImage:[UIImage imageNamed:@"add_image"] forState:0];
    [mediaBtn addTarget:self action:@selector(pickMediaAction) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:mediaBtn];
    [mediaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(storageBtn.mas_left);
        make.top.equalTo(@20);
        make.size.mas_equalTo(CGSizeMake(40, 44));
    }];
    //添加标题 输入框
    _titleField=[[UITextField alloc] init];
    [self.view addSubview:_titleField];
    _titleField.placeholder=NSLocalizedString(@"请输入标题", nil);
    [_titleField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wkself.view).offset(10);
        make.top.equalTo(naviView.mas_bottom);
        make.width.equalTo(wkself.view);
        make.height.equalTo(@40);
    }];
    //添加分割线
    UIView *line=[[UIView alloc] init];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(wkself.view);
        make.top.equalTo(wkself.titleField.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    line.backgroundColor=[UIColor grayColor];
    //添加内容 输入框
    _contentView=[[ZHTextView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_contentView];
    _contentView.delegate=self;
    [_contentView makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(wkself.view).offset(5);
        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(wkself.view);
    }];
    _contentView.placeHolder=NSLocalizedString(@"请输入内容",nil);
    _contentView.font=[UIFont systemFontOfSize:15];
    
    UIToolbar *toolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    UIBarButtonItem *spaceItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *hideItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeyboard)];
    toolbar.items=@[spaceItem,hideItem];
    _contentView.inputAccessoryView=toolbar;
    _titleField.inputAccessoryView=toolbar;
}
-(void)hideKeyboard{
    
    [self.view endEditing:YES];
}
#pragma mark -键盘顶起contentView方法
-(void)keyboardWillShow:(NSNotification *)sender{
    
    kWeakSelf(wkself)
    CGRect keybordFrame=[[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [_contentView updateConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(wkself.view).offset(-keybordFrame.size.height);
    }];
}
-(void)keyboardWillHide:(NSNotification *)sender{
    
    kWeakSelf(wkself)
    [_contentView updateConstraints:^(MASConstraintMaker *make) {
       
       make.bottom.equalTo(wkself.view);
    }];
}
#pragma  mark -contentView代理
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    [_contentView resignFirstResponder];
//}

#pragma  mark -解析
-(void)parse{
    
    if(!self.note){
        
        return;
    }
    NSString *content=self.note.content;
    _titleField.text=self.note.title;
    //把content转化成attributeString
    NSMutableArray *substrings=[NSMutableArray array];
    NSRange range=[content rangeOfString:@"<image>image_key:"];
    while (range.location!=NSNotFound) {
        
        NSString *sub=[content substringWithRange:NSMakeRange(0, range.location)];
        if(sub.length>0){
            [substrings addObject:sub];
        }
        NSRange end=[content rangeOfString:@":image_key</image>"];
        NSRange imageKeyRange=NSMakeRange(range.location, end.location+end.length-range.location);
        NSString *imagekey=[content substringWithRange:imageKeyRange];
        [substrings addObject:imagekey];
        //重新赋值剩余的content和range
        content=[content substringFromIndex:end.location+end.length];
        range=[content rangeOfString:@"<image>image_key:"];
    }
    //此时最后一张图片之后，content必然是文字或者空白
    if(content.length>0){
        
        [substrings addObject:content];
    }
    //NSLog(@"%@",substrings);
    NSMutableAttributedString *attributeString=[[NSMutableAttributedString alloc] init];
    for(NSString *sub in substrings){
        
        //BOOL isImageNode=[Tool isImageKey:sub];
        if(sub.isImageNode){
            
            NSString *imageString;
            for(NSDictionary *dict in self.note.imagesArray){
                
                if([dict.allKeys.firstObject isEqualToString:sub]){
                    
                    imageString=[dict objectForKey:sub];
                    
                }
            }
            NSData *imageData=[[NSData alloc] initWithBase64EncodedString:imageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *image=[[UIImage alloc] initWithData:imageData];
            NoteTextAttachment *attach=[[NoteTextAttachment alloc] init];
            attach.imageKey=sub;
            attach.image=image;
            attach.bounds=CGRectMake(10, 0, kWidth-20, image.size.height/image.size.width*(kWidth-20));
            NSAttributedString *imagePart=[NSAttributedString attributedStringWithAttachment:attach];
            [attributeString appendAttributedString:imagePart];
            
        }else{
            
            NSAttributedString *a=[[NSAttributedString alloc] initWithString:sub];
            [attributeString appendAttributedString:a];
        }
    }
    _contentView.attributedText=attributeString;
//    [_contentView layoutSubviews];
    _contentView.font=kFont(15);
}
-(void)backAction{
    //若改变了内容或标题，提示是否保存
    kWeakSelf(wkself)
    if(self.backActionCallback){
        
        self.backActionCallback();
    }
    if (_isChanged==NO) {
        
        [UserDefault setInteger:0 forKey:@"seletedIndex"];
        [UserDefault synchronize];
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        UIAlertController *alert=[Tool AlertWithTitle:@"提示" msg:@"是否放弃编辑" style:UIAlertControllerStyleAlert leftActionTitle:@"放弃" leftActionStyle:UIAlertActionStyleCancel leftAction:^(UIAlertAction *backAction) {
        
            [alert dismissViewControllerAnimated:YES completion:nil];
            [UserDefault setInteger:0 forKey:@"seletedIndex"];
            [UserDefault synchronize];
            [wkself.navigationController popViewControllerAnimated:YES];
            [wkself.navigationController dismissViewControllerAnimated:YES completion:nil];
            
        } rightActionTitle:@"存储" rightActionStyle:UIAlertActionStyleDefault rightaction:^(UIAlertAction *doneAction) {
        
            [wkself storageArticleAction];
            [alert dismissViewControllerAnimated:YES completion:nil];
            
            [UserDefault setInteger:0 forKey:@"seletedIndex"];
            [UserDefault synchronize];
            
            [wkself.navigationController popViewControllerAnimated:YES];
            [wkself.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    
    _isChanged=YES;
}
#pragma mark - 存储
-(void)storageArticleAction{
    
    NSString *title=[_titleField.text copy];
    
    if (title.length==0||!title) {
        [ProgressHUD showError:NSLocalizedString(@"标题不能为空", nil)];
        return;
    }
    if (!_contentView.attributedText||_contentView.attributedText.length==0||!_contentView.text||_contentView.text.length==0) {
        
        [ProgressHUD showError:NSLocalizedString(@"内容不能为空", nil)];
        return;
    }
    NSMutableArray *imagesInfo=[NSMutableArray array];
    NSMutableString *contentString=[NSMutableString string];
    kWeakSelf(wkself)
    [_contentView.attributedText enumerateAttributesInRange:NSMakeRange(0,_contentView.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
            NoteTextAttachment *attach=[attrs objectForKeyedSubscript:NSAttachmentAttributeName];
            if (!attach) {
                
                NSAttributedString *tmp=[wkself.contentView.attributedText attributedSubstringFromRange:range];
                [contentString appendString:tmp.string];
            }else{
                
                UIImage *image=attach.image;
                NSString *imagekey=attach.imageKey;
                NSData *data=UIImagePNGRepresentation(image);
                NSString *imageString=[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
                NSDictionary *dict=@{imagekey:imageString};
                [imagesInfo addObject:dict];
                [contentString appendString:imagekey];
            }
        }];
    if (!self.note) {
        
        NSString *folder=[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentFolderName];
        if (folder.length==0||!folder) {
            folder=@"";
        }
        [[NoteManager shared] insertNoteId:[Tool createNid] title:title content:contentString date:[Tool createDate] folder:folder imagesArray:imagesInfo];
    }else{
        
        [[NoteManager shared] updateNoteWithTitle:title content:contentString imagesArray:imagesInfo whereId:self.note.nid];
    }
    if(self.backActionCallback){
        
        self.backActionCallback();
    }
    if (self.doneActionCallBack) {
        
        self.doneActionCallBack();
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)pickMediaAction{
    
    UIAlertController *mediaAlert=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof (self) wkself=self;
    UIAlertAction *alumbAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"相册",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [wkself showImagePickerWitType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *cameraAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"相机",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [wkself showImagePickerWitType:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"取消",nil) style:UIAlertActionStyleCancel handler:nil];
    
    [mediaAlert addAction:alumbAction];
    [mediaAlert addAction:cameraAction];
    [mediaAlert addAction:cancelAction];
    [self presentViewController:mediaAlert animated:YES completion:nil];
}
//判断资源是否可用
-(void)showImagePickerWitType:(UIImagePickerControllerSourceType)type{
    
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
    CGFloat rate=image.size.height/image.size.width;
    NoteTextAttachment *attach=[[NoteTextAttachment alloc] init];
    //设置附件的尺寸，宽度与contentView保持一致
    attach.bounds=CGRectMake(0, 0,_contentView.frame.size.width , _contentView
                             .frame.size.width*rate);
    //为附件完成属性设置
    attach.image=image;
    attach.imageKey=[Tool createImageKey];
    //用附件生成图片的属性字符串
    NSAttributedString *imageString=[NSAttributedString attributedStringWithAttachment:attach];
    //获取光标位置
    NSRange selectRange=_contentView.selectedRange;
    //全局属性字符串
    NSMutableAttributedString *attributeText=[[NSMutableAttributedString alloc] initWithAttributedString:_contentView.attributedText];
    //判断插入图片的位置，最前面或者中间（最后面）
    if (selectRange.location==0) {
        //将不可变转为可变，便于后面添加
        NSMutableAttributedString *mutableImageString=[[NSMutableAttributedString alloc] initWithAttributedString:imageString];
        //添加换行
        NSAttributedString *returnAttributeString=[[NSAttributedString alloc] initWithString:@"\n"];
        [mutableImageString appendAttributedString:returnAttributeString];
        //添加此附件属性字符串到全局AtrributeText ，注意是insert
        [attributeText insertAttributedString:mutableImageString atIndex:selectRange.location];
    }else{
        
        NSMutableAttributedString *firstReturn=[[NSMutableAttributedString alloc] initWithString:@"\n"];
        [firstReturn appendAttributedString:imageString];
        NSMutableAttributedString *lastReturn=[[NSMutableAttributedString alloc] initWithString:@"\n"];
        [firstReturn appendAttributedString:lastReturn];
        [attributeText insertAttributedString:firstReturn atIndex:selectRange.location];
    }
    //给添加图片后的atrributeText赋值
    _contentView.attributedText=attributeText;
    //更新后一定记得重新布局
//    [_contentView layoutSubviews];
    _contentView.font=[UIFont systemFontOfSize:15];

    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
