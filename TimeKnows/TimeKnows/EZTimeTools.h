//
//  EZTimeTools.h
//  TimeKnows
//
//  Created by luyi on 2023/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


#pragma mark -- 时间格式
typedef NS_ENUM(NSUInteger, EZTimeStyle) {
    
    EZTimeStyleWhole = 0,  //年-月-日 时:分:秒 yyyy-MM-dd HH:mm:ss
    EZTimeStyleYMDHM,  //年-月-日 时：分 yyyy-MM-dd HH:mm
    
    EZTimeStyleYMD,//年-月-日 yyyy-MM-dd
    EZTimeStyleYM,//年-月  yyyy-MM
    EZTimeStyleMD,//月-日 MM-dd
    
    EZTimeStyleHMS,  //时:分:秒 HH:mm:ss
    EZTimeStyleHM, //时:分 HH:mm
    EZTimeStyleWhole2,  //年-月-日 时:分:秒 yyyy-MM-dd-HH-mm-ss
};

@interface NSDateFormatter (PEZ)

- (void)setFormatWithStyle:(EZTimeStyle)style;

@end


@interface EZTimeTools : NSObject

+ (NSString *)getStrFromDate:(NSDate *)date withStyle:(EZTimeStyle)style;
+ (NSDate *)getDateFromStr:(NSString *)str withStyle:(EZTimeStyle)style;


#pragma mark - 获取本月第一天
+ (NSString *)getFirstDayForCurrentMonthWithStyle:(EZTimeStyle)style;

+ (NSDate *)getFirstDateForCurrentMonth;

#pragma  mark －获取今天的日期
+ (NSString *)getTodayWithStyle:(EZTimeStyle)style;

#pragma mark - 获取上个月今天
+ (NSString *)getAMonthAgo;

// 获取本月第一天和最后一天
+ (NSArray *)getMonthBeginAndEndWith:(NSString *)dateStr;

+ (NSArray *)getMonthBeginAndEndWithDate:(NSDate *)newDate;


@end

NS_ASSUME_NONNULL_END
