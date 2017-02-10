//
//  ListViewController.h
//  我的日记本
//
//  Created by 周浩 on 16/11/4.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "BaseViewController.h"

@interface ListViewController : BaseViewController


@property(nonatomic,strong)UITableView          *tbView;
@property(nonatomic,strong)NSMutableArray       *dataArray;
@property(nonatomic,copy) void(^didSelectCallBack)();
@property(nonatomic,strong)UIButton             *folderBtn;
@end
