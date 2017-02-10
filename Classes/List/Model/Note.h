//
//  Note.h
//  我的日记本
//
//  Created by 周浩 on 16/11/23.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property(nonatomic,copy)NSString       *title;
@property(nonatomic,copy)NSString       *content;
@property(nonatomic,copy)NSString       *nid;
@property(nonatomic,copy)NSString       *date;
@property(nonatomic,strong)NSArray      *imagesArray;
@property(nonatomic,assign)BOOL         top;
@property(nonatomic,copy)NSString       *folder;

@end
