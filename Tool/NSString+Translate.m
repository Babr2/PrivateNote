//
//  NSString+Translate.m
//  我的日记本
//
//  Created by 周浩 on 16/12/10.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "NSString+Translate.h"

@implementation NSString (Translate)

-(NSString *)translateString{
    
    NSMutableString *string=[[NSMutableString alloc] initWithString:[self copy]];
    CFStringTransform((CFMutableStringRef)string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)string, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *result=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    return result;
}

@end
