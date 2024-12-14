//
//  EZTimeTools.m
//  TimeKnows
//
//  Created by luyi on 2023/7/11.
//

#import "EZTimeTools.h"


@implementation NSDateFormatter (PEZ)

- (void)setFormatWithStyle:(EZTimeStyle)style{
    
    switch (style) {
        case EZTimeStyleWhole:
            [self setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
            
        case EZTimeStyleYMDHM:
            [self setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
            
        case EZTimeStyleYMD:
            [self setDateFormat:@"yyyy-MM-dd"];
            break;
            
        case EZTimeStyleYM:
            [self setDateFormat:@"yyyy-MM"];
            break;
            
        case EZTimeStyleMD:
            [self setDateFormat:@"MM-dd"];
            break;
            
        case EZTimeStyleHMS:
            [self setDateFormat:@"HH:mm:ss"];
            break;
            
        case EZTimeStyleHM:
            [self setDateFormat:@"HH:mm"];
            break;
        case EZTimeStyleWhole2:
            [self setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
            break;
            
            
            
        default:
            break;
    }
    
}

@end

@implementation EZTimeTools

+ (NSString *)getStrFromDate:(NSDate *)date withStyle:(EZTimeStyle)style{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setFormatWithStyle:style];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSDate *)getDateFromStr:(NSString *)str withStyle:(EZTimeStyle)style{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setFormatWithStyle:style];
    
    NSDate *date =[dateFormatter dateFromString:str];
    
    return date;
}



#pragma  mark －获取今天的日期
+ (NSString *)getTodayWithStyle:(EZTimeStyle)style{
    
    NSDate * senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setFormatWithStyle:style];
    
    return [dateformatter stringFromDate:senddate];
}


#pragma mark - 获取本月第一天
+ (NSString *)getFirstDayForCurrentMonthWithStyle:(EZTimeStyle)style{
     
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:comps.year];
    [adcomps setMonth:comps.month];
    [adcomps setDay:1];
    
    NSDate *newdate = [calendar dateFromComponents:adcomps];
    
    NSString *dateString = [EZTimeTools getStrFromDate:newdate withStyle:style];
    NSLog(@"dateString : %@",dateString);
    return dateString;
}

+ (NSDate *)getFirstDateForCurrentMonth{
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:comps.year];
    [adcomps setMonth:comps.month];
    [adcomps setDay:1];
    [adcomps setHour:0];
    [adcomps setMinute:0];
    [adcomps setSecond:0];
    
    NSDate *newdate = [calendar dateFromComponents:adcomps];
     
    return newdate;
}


#pragma mark - 获取上个月今天
+ (NSString *)getAMonthAgo{
    NSDate *oneData = [NSDate dateWithTimeInterval:-60 * 60 * 24 *30 sinceDate:[NSDate date]];
    
    return [EZTimeTools getStrFromDate:oneData withStyle:EZTimeStyleYMD];
}



+ (NSArray *)getMonthBeginAndEndWith:(NSString *)dateStr{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit
                          startDate:&beginDate
                           interval:&interval
                            forDate:newDate];
    
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @[];
    }
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
//    NSString *s = [NSString stringWithFormat:@"%@-%@",beginString,endString];
    return @[beginString, endString];
}


+ (NSArray *)getMonthBeginAndEndWithDate:(NSDate *)newDate{
    
//    NSDateFormatter *format=[[NSDateFormatter alloc] init];
//    [format setDateFormat:@"yyyy-MM"];
//    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit
                          startDate:&beginDate
                           interval:&interval
                            forDate:newDate];
    
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @[];
    }
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
//    NSString *s = [NSString stringWithFormat:@"%@-%@",beginString,endString];
    return @[beginString, endString];
}

@end
