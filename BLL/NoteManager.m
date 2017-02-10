//
//  NoteManager.m
//  SQLite数据库
//
//  Created by 周浩 on 16/11/18.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "NoteManager.h"
#import "FMDB.h"
#import "Note.h"
#import "User.h"
#import "Tool.h"
#import "NSString+Translate.h"

@interface NoteManager()

@property(nonatomic,strong)FMDatabase *database;

@end

static NoteManager *mgr=nil;

@implementation NoteManager

+(instancetype)shared{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        mgr=[[NoteManager alloc] init];
    });
    return mgr;
}
-(instancetype)init{
    
    if(self=[super init]){
        
        //创建数据库
        [self createDatabase];
    }
    return self;
}
//管理类生成数据库
-(void)createDatabase{
    //FMDB通过cache路径来创建
    //数据库需要一个存储路径
    NSString *libCachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath=[libCachePath stringByAppendingPathComponent:@"note"];
    BOOL eixst=[[NSFileManager defaultManager] fileExistsAtPath:dbPath];
    if(!eixst){
        //如不存在，新建一个放数据的文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:dbPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //放数据的文件
    dbPath=[dbPath stringByAppendingPathComponent:@"noteData.zh"];
    _database=[[FMDatabase alloc] initWithPath:dbPath];
    NSLog(@"%@",dbPath);
    BOOL opened=[_database open];
    if(!opened){
        
        NSLog(@"数据库打开失败");
    }
    
    NSString *createNoteTableSQL=@"create table if not exists notes(nid text primary key, title text,content text,date text,imagesArray blob,top bool,folder text)";
    //创建日记管理表
    [_database executeUpdate:createNoteTableSQL];
    //创建文件夹管理表
    NSString *createFolderTableSQL=@"create table if not exists folders(fid text primary key,folderName text)";
    [_database executeUpdate:createFolderTableSQL];
    //创建账户管理表
    NSString *createUserTableSQL=@"create table if not exists users(uid text primary key,userLoginName text,password text,userName text,headImage blob)";
    [_database executeUpdate:createUserTableSQL];
    
}
-(void)insertNoteId:(NSString *)nid title:(NSString *)title content:(NSString *)content date:(NSString *)date folder:(NSString *)folder imagesArray:(NSArray *)imagesArray{

    NSString *insertSQL=@"insert into notes(nid,title,content,date,top,folder,imagesArray) values(?,?,?,?,?,?,?)";
    //array类型转成data类型存入，options 是NSJSONWriting
    NSData *imageInfoDatas=[NSJSONSerialization dataWithJSONObject:imagesArray options:NSJSONWritingPrettyPrinted error:nil];
    BOOL top=NO;//插入bool值要封装成对象
    BOOL ret=[_database executeUpdate:insertSQL,nid,title,content,date,@(top),folder,imageInfoDatas];
    if (!ret) {
        NSLog(@"插入失败");
    }
}
-(void)removeNoteWithNoteId:(NSString *)nid{
    
    NSString *deleteSQL=@"delete from notes where nid=?";
    BOOL ret=[_database executeUpdate:deleteSQL,nid];
    if (!ret) {
        NSLog(@"删除失败");
    }
}
-(void)updateNoteWithTitle:(NSString *)title content:(NSString *)content imagesArray:(NSArray *)imagesArray whereId:(NSString *)nid{
    
    NSString *modifyDate=[Tool createDate];
    NSData *imagesInfo=[NSJSONSerialization dataWithJSONObject:imagesArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *updateSQL=@"update notes set title=?,content=?,date=?,imagesArray=? where nid=?";
    BOOL ret=[_database executeUpdate:updateSQL,title,content,modifyDate,imagesInfo,nid];
    if (!ret) {
        NSLog(@"更新失败");
    }
}
-(void)UpdateNoteTopState:(BOOL)top whereNid:(NSString *)nid{
    
    NSString *sql=@"update notes set top=? where nid=?";
    BOOL ret=[_database executeUpdate:sql,@(top),nid];
    if(!ret){
        
        NSLog(@"变更置顶状态失败");
    }
}
-(void)updateFolderWith:(NSString *)folder whereNoteID:(NSString *)nid{
    
    NSString *sql=@"update notes set folder=? where nid=?";
    BOOL ret=[_database executeUpdate:sql,folder,nid];
    if (!ret) {
        NSLog(@"移动文件夹失败");
    }
}
-(Note *)noteWithId:(NSString *)nid{
    
    NSString *querySQL=@"select * from notes where nid=?";
    FMResultSet *set=[_database executeQuery:querySQL,nid];
    if ([set next]) {
        
        Note *note=[[Note alloc] init];
        note.title=[set stringForColumn:@"title"];
        note.content=[set stringForColumn:@"content"];
        note.date=[set stringForColumn:@"date"];
        note.nid=[set stringForColumn:@"nid"];
        note.top=[set boolForColumn:@"top"];
        note.folder=[set stringForColumn:@"folder"];
        NSData *imageInfoDatas=[set dataForColumn:@"imagesArray"];
        if (imageInfoDatas.length>0) {
            NSArray *imagesInfo=[NSJSONSerialization JSONObjectWithData:imageInfoDatas options:NSJSONReadingMutableContainers error:nil];
            note.imagesArray=imagesInfo;
        }
        [set close];
        return  note;
    }
    return  nil;
}
-(NSArray *)notesWithFolderName:(NSString *)folderName{
    
    if (folderName.length==0||!folderName) {
        
        return [self allNotes];
    }
    NSString *querySQL=@"select * from notes where folder=?";
    FMResultSet *set=[_database executeQuery:querySQL,folderName];
    NSMutableArray *noteArray=[NSMutableArray array];
    while ([set next]) {
        
        Note *note=[[Note alloc] init];
        note.title=[set stringForColumn:@"title"];
        note.content=[set stringForColumn:@"content"];
        note.date=[set stringForColumn:@"date"];
        note.nid=[set stringForColumn:@"nid"];
        note.top=[set boolForColumn:@"top"];
        note.folder=[set stringForColumn:@"folder"];
        NSData *imageInoDatas=[set dataForColumn:@"imagesArray"];
        if(imageInoDatas.length>0){
            
            NSArray *imagesInfoArray=[NSJSONSerialization JSONObjectWithData:imageInoDatas options:NSJSONReadingMutableContainers error:nil];
            note.imagesArray=imagesInfoArray;
        }
        [noteArray addObject:note];
    }
    [set close];
    return  noteArray;
}
-(NSArray<Note *> *)allNotes{
    
    NSString *querySQL=@"select * from notes";
    FMResultSet *set=[_database executeQuery:querySQL];
    NSMutableArray *noteArray=[NSMutableArray array];
    while ([set next]) {
        
        Note *note=[[Note alloc] init];
        note.title=[set stringForColumn:@"title"];
        note.content=[set stringForColumn:@"content"];
        note.date=[set stringForColumn:@"date"];
        note.nid=[set stringForColumn:@"nid"];
        note.top=[set boolForColumn:@"top"];
        note.folder=[set stringForColumn:@"folder"];
        NSData *imageInoDatas=[set dataForColumn:@"imagesArray"];
        if(imageInoDatas.length>0){
            
            NSArray *imagesInfoArray=[NSJSONSerialization JSONObjectWithData:imageInoDatas options:NSJSONReadingMutableContainers error:nil];
            note.imagesArray=imagesInfoArray;
        }
        [noteArray addObject:note];
    }
    [set close];
    return  noteArray;
}
-(NSArray<Note *> *)notesWithKeywords:(NSString *)keywords{
    //转成小写
    keywords=[keywords lowercaseString];
    NSArray *allNotes=[self allNotes];
    NSMutableArray *keyArray=[NSMutableArray array];
    for(Note *note in allNotes){
        
        BOOL ret1=[note.title rangeOfString:keywords].location!=NSNotFound;
        BOOL ret2=[[[note.title translateString] lowercaseString] rangeOfString:keywords].location!=NSNotFound;
        BOOL ret3=[note.content rangeOfString:keywords].location!=NSNotFound;
        BOOL ret4=[[[note.content translateString] lowercaseString] rangeOfString:keywords].location!=NSNotFound;
        if (ret1||ret2||ret3||ret4) {
            
            [keyArray addObject: note];
        }
    }
    return  keyArray;
}
//  folder

-(void)insertFolderWithId:(NSString *)fid name:(NSString *)folderName{
    
    NSString *insertSQL=@"insert into folders(fid,folderName) values(?,?)";
    BOOL ret=[_database executeUpdate:insertSQL,fid,folderName];
    if (!ret) {
        NSLog(@"插入失败");
    }
}
-(void)updateFolderWithName:(NSString *)name whereFolderId:(NSString *)fid{
    
    NSString *updateSQL=@"update folders set folderName=? where fid=?";
    BOOL ret=[_database executeUpdate:updateSQL,fid,name];
    if (!ret) {
        NSLog(@"更新失败");
    }
}
-(void)removeFolderWhereFolderId:(NSString *)fid{
    
    NSString *deleteSQL=@"delete from folders where fid=?";
    BOOL ret=[_database executeUpdate:deleteSQL,fid];
    if (!ret) {
        NSLog(@"删除失败");
    }
}
-(Folder *)folderWithId:(NSString *)fid{
    
    NSString *querySQL=@"select * from folders where fid=?";
    FMResultSet *set=[_database executeQuery:querySQL,fid];
    if ([set next]) {
        
        Folder *folder=[[Folder alloc] init];
        folder.folderName=[set stringForColumn:@"folderName"];
        folder.fid=[set stringForColumn:@"fid"];
        [set close];
        return  folder;
    }
    return  nil;
}
-(Folder *)folderWithName:(NSString *)name{
    
    NSString *querySQL=@"select * from folders where folderName=?";
    FMResultSet *set=[_database executeQuery:querySQL,name];
    if ([set next]) {
        
        Folder *folder=[[Folder alloc] init];
        folder.folderName=[set stringForColumn:@"folderName"];
        folder.fid=[set stringForColumn:@"fid"];
        [set close];
        return folder;
    }
    return  nil;
}
-(NSArray<Folder *> *)allFolders{
    
    
    NSString *querySQL=@"select * from folders";
    FMResultSet *set=[_database executeQuery:querySQL];
    NSMutableArray *array=[NSMutableArray array];
    while([set next]) {
        
        Folder *folder=[[Folder alloc] init];
        folder.folderName=[set stringForColumn:@"folderName"];
        folder.fid=[set stringForColumn:@"fid"];
        [array addObject:folder];
    }
    [set close];
    return array;
}

-(NSArray *)jsonObjectWithAllNotes{
    
    NSMutableArray *array=[NSMutableArray array];
    NSArray *allNotes=[self allNotes];
    for(Note *note in allNotes){
        
        NSString *desc=[note description];
//        NSData *data=[desc dataUsingEncoding:NSUTF8StringEncoding];
//        id obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        if(obj){
//            
//            [array addObject:obj];
//        }
        [array addObject:desc];
    }
    return array;
}
-(void)handleSynclizedData:(id)obj completion:(void (^)())completion error:(void(^)())failure{
    
    if(!obj){
        return;
    }
    id tmp=[obj objectForKey:@"notes"];
    if(![tmp isKindOfClass:[NSArray class]]){
        return;
    }
    NSArray *results=tmp;
    if(!results||results.count==0){
        return;
    }
    for(Note *note in [self allNotes]){
        
        [self removeNoteWithNoteId:note.nid];
    }
    for(Folder *folder in [self allFolders]){
        
        [self removeFolderWhereFolderId:folder.fid];
    }
    for(NSDictionary *dict in results){
        
        NSString *title=[dict objectForKey:@"title"];
        NSString *content=[dict objectForKey:@"content"];
        NSString *folder=[dict objectForKey:@"folder"];
//        NSNumber *top=@([[dict objectForKey:@"top"] intValue]);
        NSString *nid=[dict objectForKey:@"nid"];
        NSData *imgDatas;
        id tmp=[dict objectForKey:@"images"];
        if([tmp isKindOfClass:[NSArray class]]){
            
            NSArray *imginfos=tmp;
            if(imginfos&&imginfos.count>0){
                
                imgDatas=[NSJSONSerialization dataWithJSONObject:imginfos options:NSJSONWritingPrettyPrinted error:nil];
            }
        }
        NSString *date=[dict objectForKey:@"date"];
        
        [self insertNoteId:nid title:title content:content date:date folder:folder imagesArray:tmp];

        NSString *folderName=[folder copy];
        BOOL isDefault=[folderName isEqualToString:@"All Folders"]||
        [folderName isEqualToString:@"全部便签"]||
        [folderName isEqualToString:@"全部便簽"]||
        [folderName isEqualToString:@"全部便箋"];
        if(!isDefault){
            
            [self insertFolderWithId:[Tool createFid] name:folderName];
        }
    }
    if(completion){
        completion();
    }
}
@end
