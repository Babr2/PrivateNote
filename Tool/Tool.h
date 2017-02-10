//
//  Tool.h
//  我的日记本
//
//  Created by 周浩 on 16/11/7.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject

+(UIBarButtonItem *)barButtomItemWithTitle:(NSString *)title imgName:(NSString *)name target:(id)target action:(SEL)action;

+(UITableView *)tabViewWithFrame:(CGRect)frame style:(UITableViewStyle)style delegate:(id<UITableViewDelegate>)delegate datasouce:(id<UITableViewDataSource>)datasouce;
+(NSString *)createDate;
+(NSString *)createNid;
+(NSString *)createFid;
+(NSString *)createImageKey;
+(BOOL)isImageKey:(NSString *)string;

+(UIButton *)makeBtnFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor imageName:(NSString *)imageName backgroundColor:(UIColor *)bgColor target:(id)target action:(SEL)action;
+(UIAlertController *)AlertWithTitle:(NSString *)titile
                                 msg:(NSString *)msg
                               style:(UIAlertControllerStyle)style
                     leftActionTitle:(NSString *)leftActionTitle
                     leftActionStyle:(UIAlertActionStyle)leftActionStyle
                          leftAction:(void (^)(UIAlertAction*))leftAlertAction
                    rightActionTitle:(NSString *)rightActionTitle
                    rightActionStyle:(UIAlertActionStyle)rightActionStyle
                         rightaction:(void (^)(UIAlertAction*))rightAlertAction;
+(UIAlertController *)sheetWithTitle:(NSString *)title action:(void (^)(UIAlertAction*))action titleArray:(NSArray<NSString *>*)titleArray ;
+(void)asyncInGlobalQueueWithBlock:(void (^)())block;

+(NSString *)countryCode;
+(NSString *)dateWithIntervalSince1970:(NSInteger)interval;
+(NSString *)weekFromDate:(NSDate *)date;
@end
