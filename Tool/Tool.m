//
//  Tool.m
//  我的日记本
//
//  Created by 周浩 on 16/11/7.
//  Copyright © 2016年 周浩. All rights reserved.
//

#import "Tool.h"


@implementation Tool


+(UIBarButtonItem *)barButtomItemWithTitle:(NSString *)title imgName:(NSString *)name target:(id)target action:(SEL)action{
    
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}
+(UITableView *)tabViewWithFrame:(CGRect)frame style:(UITableViewStyle)style delegate:(id<UITableViewDelegate>)delegate datasouce:(id<UITableViewDataSource>)datasouce{
    
    UITableView *tbView=[[UITableView alloc] initWithFrame:frame style:style];
    tbView.delegate=delegate;
    tbView.dataSource=datasouce;
    return tbView;
}

+(NSString *)createDate{
    
    NSDateFormatter *fmt=[NSDateFormatter new];
    fmt.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    return [fmt stringFromDate:[NSDate date]];
}
+(NSString *)createNid{
    
    NSString *timeString=[self createDate];
    NSMutableString *idString=[NSMutableString string];
    for (int i=0; i<10; i++) {
        
        int random=arc4random_uniform(10)+11;
        [idString appendFormat:@"%d",random];
    }
    return [NSString stringWithFormat:@"%@%@",timeString,idString];
}
+(NSString *)createFid{
    
    NSString *timeString=[self createDate];
    NSMutableString *idString=[NSMutableString string];
    for (int i=0; i<5; i++) {
        
        int random=arc4random_uniform(10)+11;
        [idString appendFormat:@"%d",random];
    }
    return [NSString stringWithFormat:@"%@%@",timeString,idString];

}

+(NSString *)createImageKey{
    
    NSDateFormatter *fmt=[NSDateFormatter new];
    fmt.dateFormat=@"yyyy-MM-dd HH:mm:ss:SSS";
    NSString *dateString=[fmt stringFromDate:[NSDate date]];
    NSString *imagekey=[NSString stringWithFormat:@"<image>image_key:%@:image_key</image>",dateString];
    return  imagekey;
}
+(BOOL)isImageKey:(NSString *)string{
    
    NSString *reg=@"(?=:<image>image_key:).+(?<=:image_key</image>)";
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    return [predicate evaluateWithObject:string];
}
+(UIButton *)makeBtnFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)textColor imageName:(NSString *)imageName backgroundColor:(UIColor *)bgColor target:(id)target action:(SEL)action{
    
    UIButton *btn=[[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.backgroundColor=bgColor;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
+(UIAlertController *)AlertWithTitle:(NSString *)titile
                                     msg:(NSString *)msg
                                   style:(UIAlertControllerStyle)style
                         leftActionTitle:(NSString *)leftActionTitle
                         leftActionStyle:(UIAlertActionStyle)leftActionStyle
                               leftAction:(void (^)(UIAlertAction*))leftAlertAction
                         rightActionTitle:(NSString *)rightActionTitle
                         rightActionStyle:(UIAlertActionStyle)rightActionStyle
                              rightaction:(void (^)(UIAlertAction*))rightAlertAction
{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:titile message:msg preferredStyle:style];
    UIAlertAction *action=[UIAlertAction actionWithTitle:rightActionTitle style:rightActionStyle handler:rightAlertAction];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:leftActionTitle style:leftActionStyle handler:leftAlertAction];
    [alert addAction:action];
    [alert addAction:cancel];
    return  alert;
}
+(UIAlertController *)sheetWithTitle:(NSString *)title action:(void (^)(UIAlertAction *))action titleArray:(NSArray<NSString *> *)titleArray{
 
    UIAlertController *sheet=[UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *titles=titleArray;
    for (int i=0; i<titles.count; i++) {
        
        UIAlertAction *sheetAction=[UIAlertAction actionWithTitle:titleArray[i] style:UIAlertActionStyleDefault handler:action];
        [sheet addAction:sheetAction];
    };
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [sheet dismissViewControllerAnimated:YES completion:nil];
    }];
    [sheet addAction:cancel];
    return  sheet;
}
+(void)asyncInGlobalQueueWithBlock:(void (^)())block{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if(block){
            block();
        }
    });
}
+(NSString *)countryCode{
    
    NSLocale *locale = [NSLocale currentLocale];
    
    NSDictionary *dictCodes = [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
                               @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
                               @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
                               @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
                               @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
                               @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
                               @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
                               @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                               @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                               @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                               @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                               @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                               @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                               @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                               @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                               @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                               @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                               @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                               @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                               @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                               @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                               @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                               @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                               @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                               @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                               @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                               @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                               @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                               @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                               @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                               @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                               @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                               @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                               @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                               @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                               @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                               @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                               @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                               @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                               @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                               @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                               @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                               @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                               @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                               @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                               @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                               @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                               @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                               @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                               @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                               @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                               @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                               @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                               @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                               @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                               @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                               @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                               @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                               @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
                               @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
                               @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
    
    NSString* tt = [locale objectForKey:NSLocaleCountryCode];
    NSString* defaultCode = [dictCodes objectForKey:tt];
    return defaultCode;
}
+(NSString *)dateWithIntervalSince1970:(NSInteger)interval{
    
    NSInteger seconds=interval;
    if(seconds==0){
        return @"";
    }
    NSDateFormatter *fmt=[NSDateFormatter new];
    fmt.dateFormat=@"yyyy-MM-dd HH:mm";
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:seconds];
    return [fmt stringFromDate:date];
}
+(NSString *)weekFromDate:(NSDate *)date{
    
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSUInteger unit=NSCalendarUnitWeekday;
    NSDateComponents *cmp=[calendar components:unit fromDate:date];
    NSUInteger week=cmp.weekday;
    NSArray *array=@[Localizable(@"星期天"), Localizable(@"星期一"),Localizable(@"星期二"),Localizable(@"星期三"),Localizable(@"星期四"),Localizable(@"星期五"),Localizable(@"星期六")];
    NSInteger index=week-1;
    if(index<-1){
        
        return @"";
    }
    return array[index];
}
@end
