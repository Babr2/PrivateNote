//
//  Note.m
//  我的日记本
//
//  Created by 周浩 on 16/11/23.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "Note.h"

@implementation Note

-(NSString *)description{
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:self.title forKey:@"title"];
    [dict setObject:self.nid forKey:@"nid"];
    [dict setObject:self.content forKey:@"content"];
    [dict setObject:@(self.top) forKey:@"top"];
    [dict setObject:self.folder forKey:@"folder"];
    [dict setObject:self.date forKey:@"date"];
    if(self.imagesArray){
        
        [dict setObject:self.imagesArray forKey:@"images"];
    }
    NSData *resultData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *resultString=[[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    return resultString;
}

@end
