//
//  NoteManager.h
//  SQLite数据库
//
//  Created by 周浩 on 16/11/18.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Note;

@class User;
@interface NoteManager : NSObject

+(instancetype)shared;

//增
-(void)insertNoteId:(NSString *)nid title:(NSString *)title content:(NSString *)content date:(NSString *)date folder:(NSString *)folder imagesArray:(NSArray *)imagesArray;
//删
-(void)removeNoteWithNoteId:(NSString *)noteId;
//改
-(void)updateNoteWithTitle:(NSString *)title content:(NSString *)content imagesArray:(NSArray *)imagesArray  whereId:(NSString *)nid;
//查
-(Note *)noteWithId:(NSString *)nid;
-(NSArray<Note *> *)allNotes;
-(NSArray<Note *> *)notesWithKeywords:(NSString *)keywords;
//更新置顶
-(void)UpdateNoteTopState:(BOOL)top whereNid:(NSString *)nid;

//选定文件夹得到的notes
-(NSArray *)notesWithFolderName:(NSString *)folderName;

// folder
-(void)updateFolderWith:(NSString *)folder whereNoteID:(NSString *)nid;
-(void)insertFolderWithId:(NSString *)fid name:(NSString *)folderName;
//-(void)updateFolderWithName:(NSString *)name whereFolderId:(NSString *)fid;
-(void)removeFolderWhereFolderId:(NSString *)fid;
-(Folder *)folderWithId:(NSString *)fid;
-(Folder *)folderWithName:(NSString *)name;
-(NSArray<Folder *> *)allFolders;



-(NSArray *)jsonObjectWithAllNotes;
-(void)handleSynclizedData:(id)obj completion:(void (^)())completion error:(void(^)())failure;
@end

