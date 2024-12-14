//
//  EventManager.m
//  TimeKnows
//
//  Created by luyi on 2023/7/11.
//

#import "EventManager.h"

@interface EventManager ()

@property (nonatomic, strong) EKEventStore *calendar;
@property (nonatomic, strong) EKEventStore *reminder;

@property (nonatomic, strong) EKCalendar *bestCalendar;  // 如果在 iCloud 上有 webmeeting 日历，则优先使用 iCloud 这个；如果没有 iCloud，则采用本地；

//@property (nonatomic, strong) EKSource *bestSource;  // 优先使用 iCloud source；没有则使用本地 source。
@end


@implementation EventManager


static EventManager *_instance;

+ (instancetype)sharedInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[EventManager alloc] init];
        
        if (_instance.calendar == nil) {
            _instance.calendar = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityTypeEvent];
            _instance.reminder = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityTypeReminder];
        }
    });
    return _instance;
}

 

//获取授权状态
- (EKAuthorizationStatus)getReminderAuthorizationStatus{

    // EKEntityTypeReminder  EKEntityTypeEvent
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];

    NSLog(@"-- status : %ld", (long)status);
    /*
     EKAuthorizationStatusNotDetermined = 0,
     EKAuthorizationStatusRestricted,
     EKAuthorizationStatusDenied,
     EKAuthorizationStatusAuthorized,
     */
    
//    if (status != EKAuthorizationStatusDenied){
//        requestAuthorizationCalaner
//    }

    return status;
}
 

- (NSMutableString *)writeReminder:(EKReminder *)reminder{
    
    NSMutableString *text = [NSMutableString stringWithString:@"\n----------------------\n"];
    
    
    NSString *creationDate = [EZTimeTools getStrFromDate:reminder.creationDate  withStyle:EZTimeStyleWhole];
    NSString *lastModifiedDate = [EZTimeTools getStrFromDate:reminder.lastModifiedDate  withStyle:EZTimeStyleWhole];
    
    
    
    if (reminder.completed) {
        NSString *completionDate = [EZTimeTools getStrFromDate:reminder.completionDate  withStyle:EZTimeStyleWhole];
        [text appendFormat:@"创建时间：%@ | ", creationDate];
        [text appendFormat:@"完成时间：%@\n", completionDate];
    }else{
        if ([lastModifiedDate isEqualToString:creationDate]){
            [text appendFormat:@"创建时间：%@ | 未完成无更新\n", creationDate];
        }else{
            [text appendFormat:@"创建时间：%@\n", creationDate];
            [text appendFormat:@"未完成 | 最近更新时间：%@\n", lastModifiedDate];
        }
    }
    
    [text appendFormat:@"\n%@\n", reminder.title];
    if (reminder.hasNotes){
        [text appendFormat:@"备注：%@\n", reminder.notes];
    }
//    [text appendString:@"\n\n" ];
    
    return text;
    
}


- (NSMutableString *)writeEvent:(EKEvent *)event{
    
    NSMutableString *text = [NSMutableString stringWithString:@"\n----------------------\n\n"];
    
    
    NSString *startDate = [EZTimeTools getStrFromDate:event.startDate  withStyle:EZTimeStyleWhole];
    NSString *endDate = [EZTimeTools getStrFromDate:event.endDate  withStyle:EZTimeStyleWhole];
    
//    NSString *creationDate = [EZTimeTools getStrFromDate:event.creationDate  withStyle:EZTimeStyleWhole];
//    NSString *lastModifiedDate = [EZTimeTools getStrFromDate:event.lastModifiedDate  withStyle:EZTimeStyleWhole];
    
     
    [text appendFormat:@"%@ -- %@\n", startDate, endDate];
//    [text appendFormat:@"创建时间：%@\n", creationDate];
//    [text appendFormat:@"完成日期：%@\n", lastModifiedDate];
    
//    if ([lastModifiedDate isEqualToString:creationDate]){
//        [text appendFormat:@"创建时间：%@\n", creationDate];
//    }else{
//        [text appendFormat:@"创建时间：%@ | 最近更新时间：%@\n", creationDate, lastModifiedDate];
//    }
        
    [text appendFormat:@"\n%@\n", event.title];
    if (event.hasNotes){
        [text appendFormat:@"备注：%@\n", [event.notes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
//    [text appendString:@"\n\n" ];
    
    return text;
    
}
 

//请求授权
- (void)requestAuthorizationCalaner{

    /*
     EKAuthorizationStatusNotDetermined = 0,
     EKAuthorizationStatusRestricted,
     EKAuthorizationStatusDenied,
     EKAuthorizationStatusAuthorized, -- 3
     */
    
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];

    NSLog(@"-- status : %ld", (long)status);
    if (status == EKAuthorizationStatusAuthorized) {
        return;
    }
    

    if ([self.calendar respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        
        // EKEntityTypeEvent  EKEntityTypeReminder
        [self.calendar requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"-- calendar granted : %d, error : %@", granted, error);
                if (error) {
                    NSLog(@"用户授权错误");
                    
                }else if (!granted){
                    NSLog(@"-- not granted");
                    
                    
//                    NSString *path = @"x-apple.systempreferences:com.apple.preference.security?Privacy_Calendar";
//                //    NSString *path = @"x-apple.systempreferences:com.apple.preference.security?Privacy_Reminder";
//                    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:path]];
                    
//                    [self jumpToPrivacy];
                        //这里是用户拒绝授权的返回，这个方法应该给一个block回掉，来更具用户授权状态来处理不同的操作，我这里为方便直接写个跳转到系统设置页
                        //                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }else{
                    NSLog(@"日历 - 用户授权成功");
                }
            });
            
        }];
    }else{
        
        NSLog(@"-- not respond");
        
    }
}



- (void)requestAuthorizationReminder{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];

    NSLog(@"-- status : %ld", (long)status);
    if (status == EKAuthorizationStatusAuthorized) {
        return;
    }
    

    if ([self.reminder respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        
        // EKEntityTypeEvent  EKEntityTypeReminder
        [self.reminder requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"-- reminder granted : %d, error : %@", granted, error);
                if (error) {
                    NSLog(@"用户授权错误");
                    
                }else if (!granted){
                    NSLog(@"-- not granted");
                    
//                    NSString *path = @"x-apple.systempreferences:com.apple.preference.security?Privacy_Reminders";
//                    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:path]];
                    
                }else{
                    NSLog(@"提醒事项 - 用户授权成功");
                }
            });
            
        }];
    }else{
        
        NSLog(@"-- not respond");
    }
}


- (void)jumpToPrivacy{
    NSString *path = @"x-apple.systempreferences:com.apple.preference.security?Privacy_Calendar";
//    NSString *path = @"x-apple.systempreferences:com.apple.preference.security?Privacy_Reminder";
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:path]];

}




@end
