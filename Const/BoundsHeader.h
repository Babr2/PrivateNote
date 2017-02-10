//
//  BoundsHeader.h
//  我的日记本
//
//  Created by 周浩 on 16/11/4.
//  Copyright © 2016年 周浩. All rights reserved.
//
#import <UIKit/UIKit.h>

#ifndef BoundsHeader_h
#define BoundsHeader_h

#define kWeakSelf(x) __weak typeof(self) x=self;
#define kCurrentFolderName @"currentFolderName"

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#define kFont(x)    [UIFont systemFontOfSize:(x)]
#define kWhite      [UIColor whiteColor]
#define kBlack      [UIColor blackColor]
#define kLightGray  [UIColor lightGrayColor]
#define kgray       [UIColor grayColor]
#define kBackGround [UIColor colorWithWhite:0.96 alpha:1.0]
#define kblue       [UIColor colorWithRed:32/255.0 green:140/255.0 blue:255/255.0 alpha:1.0]
#define kRed        [UIColor redColor]
#define kLightGray  [UIColor lightGrayColor]
#endif /* BoundsHeader_h */
