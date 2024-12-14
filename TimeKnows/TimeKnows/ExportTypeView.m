//
//  ExportTypeView.m
//  TimeKnows
//
//  Created by luyi on 2023/7/14.
//

#import "ExportTypeView.h"
#import "RFOverlayScrollView.h"

#import <Masonry/Masonry.h>



typedef void (^BlockDidSelectPath)(NSString *path);
typedef void (^BlockAction)(void);

@interface ExportTypeView ()<NSTableViewDelegate,NSTableViewDataSource>


@property (nonatomic, strong) NSDatePicker *startPicker;
@property (nonatomic, strong) NSDatePicker *endPicker;
@property (nonatomic, strong) NSDatePicker *monthPicker;

@property (nonatomic, strong) NSArray *btnArray;

@property (nonatomic, strong) NSButton *exportBtn;

@property (nonatomic, strong) RFOverlayScrollView *reminderScrollView;
@property (nonatomic, strong) NSTableView *reminderListTable;

@property (nonatomic, strong) NSArray *reminders;
//@property (nonatomic, strong) NSButton *exportBtn;



@end

@implementation ExportTypeView



-(instancetype)init{
    self = [super init];
//    [self setupViews];
    
    return self;
}

 
-(instancetype)initWithType:(TKType)type{
    self = [super init];
    
    self.type = type;
    [self setupViews];
    
    return self;
}

- (void)setupViews{
    
//    self.wantsLayer = YES;
//    self.layer.backgroundColor = [NSColor whiteColor].CGColor;
    
    NSButton *btn0 = [[NSButton alloc] init];
    [btn0 setButtonType:NSButtonTypeRadio];
    [self addSubview:btn0];
    btn0.state = 1;
    
    
    
    NSButton *btn1 = [[NSButton alloc] init];
    [btn1 setButtonType:NSButtonTypeRadio];
    [self addSubview:btn1];
    
    
    btn0.imagePosition = NSImageLeft;
    btn1.imagePosition = NSImageLeft;
    
    CGFloat btnGap = 12;
    
    [btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(2);
        make.top.mas_equalTo(12);
        make.size.mas_equalTo(NSMakeSize(36, 36));
    }];
    
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(btn0);
        make.size.equalTo(btn0);
        make.top.equalTo(btn0.mas_bottom).with.offset(btnGap);
    }];
     
    
    NSTextField *label0 = [[NSTextField alloc] init];
    label0.stringValue = @"选择年月：";
    [label0 ezLabelStyle];
    [self addSubview:label0];


   NSTextField *label1 = [[NSTextField alloc] init];
   label1.stringValue = @"选择起始日期：";
    [label1 ezLabelStyle];
   [self addSubview:label1];

    
   NSTextField *label11 = [[NSTextField alloc] init];
   label11.stringValue = @" 至 ";
    [label11 ezLabelStyle];
   [self addSubview:label11];
     
    
    
    [label0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn0);
        make.leading.equalTo(btn0.mas_trailing).mas_offset(2);
    }];

    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(label0);
        make.centerY.equalTo(btn1);
    }];
    
   [self addSubview:self.startPicker];
   [self addSubview:self.endPicker];
   [self addSubview:self.monthPicker];
    
    [self.monthPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(label0.mas_trailing).mas_offset(25);
        make.centerY.equalTo(btn0);
    }];
    
    [self.startPicker mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(label1.mas_trailing).mas_offset(25);
        make.leading.equalTo(self.monthPicker);
        make.centerY.equalTo(btn1);
    }];
    
    [self.endPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.startPicker.mas_trailing).mas_offset(25);
        make.centerY.equalTo(self.startPicker);
    }];
    
    [label11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn1);
        make.leading.equalTo(self.startPicker.mas_trailing).with.offset(5);
    }];
    
    
    
    NSButton *exportBtn = [[NSButton alloc] init];
    self.exportBtn = exportBtn;
//    [exportBtn setButtonType:NSButtonTypeRadio];
//    [exportBtn setBezelStyle:NSBezelStyleRoundRect];
//    [exportBtn setFocusRingType:NSFocusRingTypeNone];
    [exportBtn ezCommonSetting];
    [exportBtn ezSetCornerRadius:6];
//    exportBtn.layer.backgroundColor = [NSColor blueColor].CGColor;
    exportBtn.layer.backgroundColor = RGB(155, 155, 225).CGColor;
     
    [self addSubview:exportBtn];
   
    exportBtn.bordered = NO;
    exportBtn.imagePosition = NSNoImage;
    [exportBtn setTitle:@"开始导出"];
    [exportBtn setContentTintColor:[NSColor whiteColor]];
    
    [exportBtn setTarget:self];
    [exportBtn setAction:@selector(onExport)];
    
    [exportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.mas_equalTo(-20);
        make.size.mas_equalTo(NSMakeSize(120, 44));
    }];
    
    
    
    
    if (self.type == TKTypeCalendar){
        self.btnArray = @[btn0, btn1];
    }else{
        
        NSButton *btn2 = [[NSButton alloc] init];
        [btn2 setButtonType:NSButtonTypeRadio];
        [self addSubview:btn2];
        
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(btn0);
            make.size.equalTo(btn0);
            make.top.equalTo(btn1.mas_bottom).with.offset(btnGap);
        }];
//        btn2.title = @"选择提醒事项列表：";
        self.btnArray = @[btn0, btn1, btn2];
        
        NSTextField *label2 = [[NSTextField alloc] init];
        label2.stringValue = @"选择提醒事项列表：";
        [label2 ezLabelStyle];
        [self addSubview:label2];
        
//        NSButton *lastBtn = (NSButton *)self.btnArray[-1];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(label0);
            make.centerY.equalTo(btn2);
//            make.top.mas_equalTo(200);
        }];
         
        [self reminderListTable];
        [self.reminderScrollView ezSetLayerColor:[NSColor systemPinkColor]];
        [self.reminderScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(label2);
            make.top.equalTo(label2.mas_bottom).with.offset(15);
            make.trailing.mas_equalTo(-15);
            make.bottom.equalTo(exportBtn.mas_top).with.offset(-15);
        }];

    }
    
    
    int i = 0;
    for (NSButton *btn in self.btnArray){
        
        btn.tag = i;
        [btn setTarget:self];
        [btn setAction:@selector(btnOnClick:)];
        [btn setTitle:@""];
        
        btn.imagePosition = NSImageOnly;
//        btn.imagePosition = NSImageLeft;
//        btn.title = @"123";
        i++;
    }
    
    // 日历不显示列表
    if (self.type == TKTypeCalendar){return;}
    

    
    
}
 


- (void)refreshReminderList{
    
    NSLog(@"-- refreshReminderList type : %ld", self.type);
    
    if (self.type == TKTypeReminder){
        EKEventStore *store = [[EKEventStore alloc] init];
        NSArray<EKCalendar *> *array = [store calendarsForEntityType:EKEntityTypeReminder];
        
        NSLog(@"-- reminder lists : %ld", [array count]);
        self.reminders = array;
        [self.reminderListTable reloadData];
    }
//    }else{
//        EKEventStore *store = [[EKEventStore alloc] init];
//        NSArray<EKCalendar *> *array = [store calendarsForEntityType:EKEntityTypeEvent];
//
//        self.reminders = array;
//        [self.reminderListTable reloadData];
//    }
     
    
    
}


#pragma mark - Alert


- (void)showAlert:(NSString *)text{
    
   NSAlert *alert = [[NSAlert alloc] init];
   alert.alertStyle = NSAlertStyleInformational;
   
   alert.icon = nil;
   alert.messageText = text;
//   alert.informativeText = @"---";
    
    [alert addButtonWithTitle:@"确定"]; // 1000
    [alert addButtonWithTitle:@"取消"]; // 1001
     
   
//    NSUInteger action = [alert runModal];
   
   [alert beginSheetModalForWindow:self.superview.window completionHandler:^(NSModalResponse returnCode) {
      
       // NSModalResponse
       NSLog(@"-- returnCode : %d", returnCode);
       
       if(returnCode == NSAlertFirstButtonReturn) { // 确定

           NSLog(@"OK");
           
       }else if(returnCode == NSAlertSecondButtonReturn ) { //取消

//           NSLog(@"Cancel");

       }
   }];
    
}


- (void)showAlertAuth{
    
   NSAlert *alert = [[NSAlert alloc] init];
   alert.alertStyle = NSAlertStyleInformational;
   
//   alert.icon = nil;
   alert.messageText = @"授权提醒";
    
    [alert addButtonWithTitle:@"确定"]; // 1000
    [alert addButtonWithTitle:@"取消"]; // 1001
     
    NSString *path;
    if (self.type == TKTypeReminder){
        
        path = @"x-apple.systempreferences:com.apple.preference.security?Privacy_Reminder";
        alert.informativeText = @"历知检测到您尚未授权提醒事项，请点击确定，前往 偏好设置 --> 安全与隐私 --> 隐私 --> 提醒事项，给历知授权";
    }else{
        
        path = @"x-apple.systempreferences:com.apple.preference.security?Privacy_Calendar";
        alert.informativeText = @"历知检测到您尚未授权日历，请点击确定，前往 偏好设置 --> 安全与隐私 --> 隐私 --> 日历，给历知授权";
    }
   
//    NSUInteger action = [alert runModal];
   
   [alert beginSheetModalForWindow:self.superview.window completionHandler:^(NSModalResponse returnCode) {
      
       // NSModalResponse
       NSLog(@"-- returnCode : %d", returnCode);
       
       if(returnCode == NSAlertFirstButtonReturn) { // 确定
            
           [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:path]];
           
       }else if(returnCode == NSAlertSecondButtonReturn ) { //取消
 
       }
   }];
}


- (void)showAlertStart:(NSString *)info blockAction:(BlockAction)blockAction{
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSAlertStyleInformational;

    alert.icon = nil;
    alert.messageText = [NSString stringWithFormat:@"准备导出"];
    alert.informativeText = info;

    [alert addButtonWithTitle:@"开始"]; // 1000
    [alert addButtonWithTitle:@"取消"]; // 1001
 
   
//    NSUInteger action = [alert runModal];
   
   [alert beginSheetModalForWindow:self.superview.window completionHandler:^(NSModalResponse returnCode) {
      
       // NSModalResponse
       NSLog(@"-- returnCode : %d", returnCode);
       
       if(returnCode == NSAlertFirstButtonReturn) { // 确定
           blockAction();
//           NSLog(@"OK");
//           [[NSWorkspace sharedWorkspace] openURL:[NSURL fileURLWithPath:filePath]];
           
       }else if(returnCode == NSAlertSecondButtonReturn ) { //取消

//           NSLog(@"Cancel");

       }
   }];
    
}



- (void)showAlertComplete:(NSString *)filePath{
    
   NSAlert *alert = [[NSAlert alloc] init];
   alert.alertStyle = NSAlertStyleInformational;
   
   alert.icon = nil;
   alert.messageText = [NSString stringWithFormat:@"保存成功"];
    alert.informativeText = [NSString stringWithFormat:@"保存地址：%@", filePath];
    
    [alert addButtonWithTitle:@"打开文件所在位置"]; // 1000
    [alert addButtonWithTitle:@"知道了"]; // 1001
      
   [alert beginSheetModalForWindow:self.superview.window completionHandler:^(NSModalResponse returnCode) {
      
       // NSModalResponse
       NSLog(@"-- returnCode : %ld", returnCode);
       
       if(returnCode == NSAlertFirstButtonReturn) { // 确定

//           NSLog(@"OK");
//           [[NSWorkspace sharedWorkspace] openURL:[NSURL fileURLWithPath:filePath]];
           [[NSWorkspace sharedWorkspace] selectFile:filePath inFileViewerRootedAtPath:nil];
           
       }else if(returnCode == NSAlertSecondButtonReturn ) { //取消

//           NSLog(@"Cancel");

       }
   }];
    
}

#pragma mark - Export


- (void)onExport{
    
    if (self.type == TKTypeReminder){
        EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
        if (status == EKAuthorizationStatusDenied){
            [self showAlertAuth];
            return;
        }
    }else{
        EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
        if (status == EKAuthorizationStatusDenied){
            [self showAlertAuth];
            return;
        }
    }
    
//    [self showAlert];
//    [self showAlert2];
//    return;
    
//    [self.reminderListTable reloadData];
//    [self refreshReminderList];
    
    NSInteger exportType = 0;
    for (NSButton *btn in self.btnArray){
        
//        NSLog(@"%ld status ： %ld", btn.tag, btn.state);
        if (btn.state == YES){
            exportType = btn.tag;
            break;
        }
    }
    
    NSLog(@"-- exportType : %ld, %ld", exportType, self.type);
    
    
    if (exportType == 0){
        NSDate *date = self.monthPicker.dateValue;
        [self exportByMonth:date];
        return;
    }
    
    
    if (exportType == 1){
        NSDate *startDate = self.startPicker.dateValue;
        NSDate *endDate = self.endPicker.dateValue;
        
        if (self.type == TKTypeReminder){
            [self exportReminderByDuration:startDate endDate:endDate fileName:@""];
        }else{
            [self exportCalendarByDuration:startDate endDate:endDate fileName:@""];
        }
        return;
    }
    

    
    if (exportType == 2){
         
        NSInteger reminderIdx = self.reminderListTable.selectedRow;
        NSLog(@"reminderIdx : %ld", reminderIdx);
        
        [self exportReminderByIdx:reminderIdx];
        
        return;
    }
    
}



- (void)exportByMonth:(NSDate *)date{
    NSLog(@"-- %@ ", date);
    
    NSArray *days = [EZTimeTools getMonthBeginAndEndWithDate:date];
    NSString *day0 = [NSString stringWithFormat:@"%@ 00:00:00", days[0]];
    NSString *day1 = [NSString stringWithFormat:@"%@ 23:59:59", days[1]];
    NSLog(@"-- %@ - %@", day0, day1);
    
    NSDate *date0 = [EZTimeTools getDateFromStr:day0 withStyle:EZTimeStyleWhole];
    NSDate *date1 = [EZTimeTools getDateFromStr:day1 withStyle:EZTimeStyleWhole];
    
    
    NSString *month = [EZTimeTools getStrFromDate:date withStyle:EZTimeStyleYM];
    
//    NSString *info  = [NSString stringWithFormat:@"确认导出 %@ 的提醒事项项目？", month];
  
    if (self.type == TKTypeReminder){
        
        NSString *fileName = [NSString stringWithFormat:@"%@-提醒事项.txt", month];
        [self exportReminderByDuration:date0 endDate:date1 fileName:fileName];
        
    }else if(self.type == TKTypeCalendar){
        NSString *fileName = [NSString stringWithFormat:@"%@-日历.txt", month];
        [self exportCalendarByDuration:date0 endDate:date1 fileName:fileName];
    }
//    WS(weakSelf);
//    [self showAlertStart:info blockAction:^{
        
   
//    }];
    
}

- (void)exportCalendarByDuration:(NSDate *)startDate endDate:(NSDate *)endDate fileName:(NSString *)fileName{
    
    EKEventStore *store = [[EKEventStore alloc] init];
    NSArray<EKCalendar *> *calendars = [store calendarsForEntityType:EKEntityTypeEvent];
    NSPredicate *pred0 = [store predicateForEventsWithStartDate:startDate endDate:endDate calendars:calendars];
    
    NSArray *events = [store eventsMatchingPredicate:pred0];
    NSLog(@"-- events : %ld", [events count]);
      
    
    if ([fileName isEqualToString:@""]){
        NSString *day0 = [EZTimeTools getStrFromDate:startDate withStyle:EZTimeStyleWhole2];
        NSString *day1 = [EZTimeTools getStrFromDate:endDate withStyle:EZTimeStyleWhole2];
        fileName = [NSString stringWithFormat:@"%@--%@-日历.txt", day0, day1];
        
        NSLog(@"-- %@ - %@", day0, day1);
    }
    
    NSSortDescriptor* sortByA = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
      
        NSMutableArray *records1 = [[NSMutableArray alloc]initWithArray:[events  sortedArrayUsingDescriptors: [NSArray arrayWithObject:sortByA]]];
        
        
        [self saveFileWithFileName:fileName blockDidSelectPath:^(NSString *filePath) {
            
            NSLog(@"-- filePath : %@", filePath);
            
            NSFileHandle *fileHandle = [self getFileHandle:filePath];
               
            for (EKEvent *event in records1){
                if ([event.calendar.title isEqualToString:@"中国大陆节假日"]){
                    continue;
                }
                
//                       NSString *text = [NSString stringWithFormat:@"%d -- \n", i];
                NSString *text = [[EventManager sharedInstance] writeEvent:event];
                NSData *writer = [text dataUsingEncoding:NSUTF8StringEncoding];
                   
           //        [writer writeToFile:filePath atomically:YES];
                [fileHandle writeData:writer];
            }
               
            [fileHandle closeFile];
              
        }];
        
    
}

- (NSFileHandle *)getFileHandle:(NSString *)filePath{
    
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
//        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
//        [NSThread sleepForTimeInterval:2.0f];
//    }else{
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:[@"" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
//    }
     
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
     
    NSData *read = [fileHandle availableData];
    NSString *text2 = [[NSString alloc] initWithData:read encoding:NSUTF8StringEncoding];
    NSLog(@"avail : %@ (%lu) ", text2, (unsigned long)read.length );
    
    return fileHandle;
}


- (void)exportReminderByDuration:(NSDate *)startDate endDate:(NSDate *)endDate fileName:(NSString *)fileName{
    
//    NSLog(@"-- %@ - %@", startDate, endDate);
    
    EKEventStore *store = [[EKEventStore alloc] init];
    
    NSPredicate *pred0 = [store predicateForIncompleteRemindersWithDueDateStarting:startDate ending:endDate calendars:self.reminders];
    NSPredicate *pred1 = [store predicateForCompletedRemindersWithCompletionDateStarting:startDate ending:endDate calendars:self.reminders];
     
    if ([fileName isEqualToString:@""]){
        NSString *day0 = [EZTimeTools getStrFromDate:startDate withStyle:EZTimeStyleWhole2];
        NSString *day1 = [EZTimeTools getStrFromDate:endDate withStyle:EZTimeStyleWhole2];
        fileName = [NSString stringWithFormat:@"%@--%@-提醒事项.txt", day0, day1];
        
        NSLog(@"-- %@ - %@", day0, day1);
        
        NSString *info = [NSString stringWithFormat:@"确认导出 %@ 到 %@ 的提醒事项项目？",
                          [EZTimeTools getStrFromDate:startDate withStyle:EZTimeStyleWhole],
                          [EZTimeTools getStrFromDate:endDate withStyle:EZTimeStyleWhole] ];
        WS(weakSelf);
//        [self showAlertStart:info blockAction:^{
            
            [self exportWithStartPre:pred0 endPred:pred1 fileName:fileName];
//        }];
        
    }else{
        [self exportWithStartPre:pred0 endPred:pred1 fileName:fileName];
    }
    
    
    
    
}

- (void)exportWithStartPre:(NSPredicate *)pred0 endPred:(NSPredicate *)pred1 fileName:(NSString *)fileName{
    
    EKEventStore *store = [[EKEventStore alloc] init];
    NSMutableArray *records = [NSMutableArray array];
    // lastModifiedDate   creationDate
    NSSortDescriptor* sortByA = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES];
    
    WS(weakSelf);
    [store fetchRemindersMatchingPredicate:pred0 completion:^(NSArray<EKReminder *> * _Nullable reminders0) {
       
//        for (EKReminder *reminder in reminders0) {
//            NSLog(@"reminder title 0 : %@", reminder.title);
//        }
        [records addObjectsFromArray:reminders0];
        
        [store fetchRemindersMatchingPredicate:pred1 completion:^(NSArray<EKReminder *> * _Nullable reminders1) {
//            for (EKReminder *reminder in reminders1) {
//                NSLog(@"reminder title 1 : %@", reminder.title);
//            }
            
            [records addObjectsFromArray:reminders1];
            NSMutableArray *records1 = [[NSMutableArray alloc]initWithArray:[records  sortedArrayUsingDescriptors: [NSArray arrayWithObject:sortByA]]];
            
            [weakSelf saveFileWithFileName:fileName blockDidSelectPath:^(NSString *filePath) {
                
                NSLog(@"-- filePath : %@", filePath);
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                    // 需要创建文件，否则无法创建句柄
                    [[NSFileManager defaultManager] createFileAtPath:filePath contents:[@"" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
                }
                
                
                NSFileHandle *fileHandle = [self getFileHandle:filePath];
                   
                for (EKReminder *reminder in records1){
//                       NSString *text = [NSString stringWithFormat:@"%d -- \n", i];
                    NSString *text = [[EventManager sharedInstance] writeReminder:reminder];
                    NSData *writer = [text dataUsingEncoding:NSUTF8StringEncoding];
                       
               //        [writer writeToFile:filePath atomically:YES];
                    [fileHandle writeData:writer];
                }
                   
                [fileHandle closeFile];
                  
            
            }];
            
            
        }];
        
    }];
    
}


- (void)exportReminderByIdx:(NSInteger)idx{
    
    if (idx == -1){
        
        NSModalResponse *ret;
        NSAlert *alert = [[NSAlert alloc] init];
        alert.alertStyle = NSAlertStyleWarning;
        
        alert.icon = nil;
        alert.messageText = @"请选择清单中的列表项";
//        alert.informativeText = @"---";
         
        
        NSUInteger action = [alert runModal];
        
        if(action == NSAlertFirstButtonReturn) { //1000

            NSLog(@"OK");
            
        }else if(action == NSAlertSecondButtonReturn ) { //1001
 
            NSLog(@"Cancel");

        } else if(action == NSAlertThirdButtonReturn) { //1002
 
            NSLog(@"Abort");
        }
        
        return;
    }
    
    EKCalendar *calendar = self.reminders[idx];
    
    NSString *info = [NSString stringWithFormat:@"确认导出 %@ 列表的项目？", calendar.title];
    
    WS(weakSelf);
//    [self showAlertStart:info blockAction:^{
        [self exportReminderByCalendar:calendar];
//    }];
    
    
    
}


- (void)exportReminderByCalendar:(EKCalendar *)calendar{
    
    NSString *fileName = [NSString stringWithFormat:@"%@.txt", calendar.title];
    
    EKEventStore *store = [[EKEventStore alloc] init];
    NSPredicate *pred0 = [store predicateForRemindersInCalendars:@[calendar]];
    
    NSSortDescriptor* sortByA = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES];
    
    WS(weakSelf);
    [store fetchRemindersMatchingPredicate:pred0 completion:^(NSArray<EKReminder *> * _Nullable reminders1) {
        
        NSMutableArray *records = [[NSMutableArray alloc]initWithArray:[reminders1  sortedArrayUsingDescriptors: [NSArray arrayWithObject:sortByA]]];
        
        [weakSelf saveFileWithFileName:fileName blockDidSelectPath:^(NSString *filePath) {
            
            NSLog(@"-- filePath : %@", filePath);
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
                // 需要创建文件，否则无法创建句柄
                [[NSFileManager defaultManager] createFileAtPath:filePath contents:[@"" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
            }
            
            NSFileHandle *fileHandle = [self getFileHandle:filePath];
            
            for (EKReminder *reminder in records){
//                       NSString *text = [NSString stringWithFormat:@"%d -- \n", i];
                NSString *text = [[EventManager sharedInstance] writeReminder:reminder];
                NSData *writer = [text dataUsingEncoding:NSUTF8StringEncoding];
                   
           //        [writer writeToFile:filePath atomically:YES];
                [fileHandle writeData:writer];
            }
               
            [fileHandle closeFile];
        
        }];
        
    }];
}

#pragma mark - Export Calendar

//- (void){
//
//}


#pragma mark - 保存文件
- (void)saveFileWithFileName:(NSString *)fileName blockDidSelectPath:(BlockDidSelectPath)blockDidSelectPath;{
   
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
         
       NSSavePanel *panel = [NSSavePanel savePanel];
       panel.title = @"保存文件";
       [panel setMessage:@"选择文本保存地址"];//提示文字
       
    //    [panel setDirectoryURL:[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Pictures"]]];//设置默认打开路径
       [panel setDirectoryURL:[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]]];//设置默认打开路径
       
    //    NSString *fileName = @"1001.txt";
       [panel setNameFieldStringValue:fileName];
       [panel setAllowsOtherFileTypes:YES];
       [panel setAllowedFileTypes:@[@"txt",@"md"]];
       [panel setExtensionHidden:NO];
       [panel setCanCreateDirectories:YES];

       [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
           if (result == NSModalResponseOK)
           {
               NSString *path = [[panel URL] path];
               blockDidSelectPath(path);
               
           [self showAlertComplete:path];
                   
        //            NSData *tiffData = [self.imgView.image TIFFRepresentation];
        //        NSString *content = @"你好";
        //        NSData *data = [NSData da]
        //            [data writeToFile:path atomically:YES];
           }
       }];
        
    }];
    
   
    
}

#pragma mark - reminder NSTableViewDelegate,NSTableViewDataSource

//返回行数
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    NSLog(@"-- numberOfRows : %d", [self.reminders count]);
    return [self.reminders count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return self.reminders[row];
}

-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    
    //获取表格列的标识符
    NSString *columnID = tableColumn.identifier;
    NSLog(@"columnID : %@ ,row : %ld",columnID, row);
    
    NSString *strIdt = @"123";
    NSTableCellView *cell = [tableView makeViewWithIdentifier:strIdt owner:self];
    if (!cell) {
        cell = [[NSTableCellView alloc]init];
        cell.identifier = strIdt;
        
        NSTextField *field = [[NSTextField alloc] init];
        [field ezLabelStyle];
        cell.textField = field;
        [cell addSubview:field];
        
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(5);
            make.centerY.equalTo(cell);
            make.trailing.mas_equalTo(-1);
        }];
        
        [field ezLabelStyle];
//        cell.textField.bordered = YES;
         
//        NSLog(@"textField : %@", cell.textField);
//        cell.textField.frame = NSMakeRect(5, 5, 100, 30);
//        NSLog(@"textField.frame : %@", NSStringFromRect(cell.textField.frame));
        
    }
    
//    cell.wantsLayer = YES;
//    cell.layer.backgroundColor = [NSColor yellowColor].CGColor;
//
//    cell.imageView.image = [NSImage imageNamed:@"swift"];
    EKCalendar *calendar = self.reminders[row];
    
    cell.textField.stringValue = [NSString stringWithFormat:@"%ld : %@ ",(long)(row + 1), calendar.title];
//    cell.textField.backgroundColor = [NSColor whiteColor];
//    cell.textField.textColor = [NSColor blueColor];
    
    
    return cell;
    
}

#pragma mark - 行高
-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 44;
}

#pragma mark - 是否可以选中单元格
-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    
    //设置cell选中高亮颜色
    NSTableRowView *myRowView = [tableView rowViewAtRow:row makeIfNecessary:NO];
    
    [myRowView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleRegular];
    [myRowView setEmphasized:NO];
    
    NSLog(@"shouldSelect : %ld", row);
    return YES;
}

//选中的响应
-(void)tableViewSelectionDidChange:(nonnull NSNotification *)notification{
    
    NSTableView* tableView = notification.object;
    
//    NSLog(@"-- didSelect：%@",notification.userInfo);
    
    NSLog(@"-- selection row %ld", tableView.selectedRow);
    NSButton *btn = self.btnArray[2];
    btn.state = 1;
//    NSPopUpMenuWindowLevel
    
}





- (void)btnOnClick:(NSButton *)sender{
    
//    NSLog(@"-- %ld status ： %ld", sender.tag, sender.state);
    
    for (NSButton *btn in self.btnArray){
        
        NSLog(@"%ld status ： %ld", btn.tag, btn.state);
    }
    
}

- (void)setupViews1{
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor yellowColor].CGColor;
    
    NSDatePicker *datePicker = [[NSDatePicker alloc] initWithFrame:NSMakeRect(0, 0, 300, 300)];
    [datePicker setDatePickerStyle:NSDatePickerStyleClockAndCalendar];

    datePicker.wantsLayer = YES;
    datePicker.layer.backgroundColor = [NSColor cyanColor].CGColor;

    // 设置日期选择控件的类型为“时钟和日历”。其他类型有如，NSTextField文本框

    [datePicker setDateValue: [NSDate date]];     // 初始化选中当前日期

    [datePicker setTarget:self];
    [datePicker setAction:@selector(updateDateResult:)];    // 绑定每次选择日期触发的action
    
    [self addSubview:self.endPicker];
    
    
    
    self.startPicker = datePicker;
    // NSYearMonthDatePickerElementFlag NSYearMonthDayDatePickerElementFlag
    self.startPicker.datePickerElements = NSYearMonthDatePickerElementFlag;
    [self addSubview:self.startPicker];
    
    
    self.endPicker = [[NSDatePicker alloc] initWithFrame:NSMakeRect(300, 0, 300, 300)];
    self.endPicker.datePickerStyle = NSDatePickerStyleTextFieldAndStepper;
    self.endPicker.datePickerElements = NSYearMonthDayDatePickerElementFlag;
    
    [self.endPicker setDateValue: [NSDate date]];
    [self addSubview:self.endPicker];
    
    
    self.endPicker.wantsLayer = YES;
    self.endPicker.layer.backgroundColor = [NSColor cyanColor].CGColor;
    
//    self.endPicker.frame = NSMakeRect(300, 0, 300, 300);
    
    self.startPicker.nextResponder = self.endPicker;
    
    
}


- (void)updateDateResult:(NSDatePicker *)datePicker{
   
    // 拿到当前选择的日期
    NSDate *theDate = [datePicker dateValue];
   
    NSLog(@"日期：%@", theDate);
    
    
    if (theDate) {
        
        // 把选择的日期格式化成想要的形式
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        NSString *dateString = [EZTimeTools getStrFromDate:theDate withStyle:EZTimeStyleWhole];
         
        NSLog(@"%d ：%@", datePicker.tag, dateString);
        NSLog(@"monthPicker ：%@", self.monthPicker.dateValue);
        NSLog(@"startPicker ：%@", self.startPicker.dateValue);
        NSLog(@"endPicker ：%@", self.endPicker.dateValue);
         
    }
}
 
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

#pragma mark - Lazy

-(NSTableView *)reminderListTable{
    if (!_reminderListTable) {
        
        RFOverlayScrollView *scrollView = [[RFOverlayScrollView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [scrollView ezCommonStyle];
        scrollView.hasVerticalScroller = YES;

        scrollView.layer.cornerRadius = 6;
        scrollView.layer.masksToBounds = YES;

        [self addSubview:scrollView];
        self.reminderScrollView =scrollView;
        
        NSTableView *tableView = [[NSTableView alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
        //第一列
        NSTableColumn *column1 = [[NSTableColumn alloc] initWithIdentifier:@"columnFrist"];
        column1.title = @"columnFrist";
        [column1 setWidth:100];
        [tableView addTableColumn:column1];
  
        tableView.headerView = nil;
        
        [scrollView setDocumentView:tableView];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        _reminderListTable = tableView;
    }
    return _reminderListTable;
}


-(NSDatePicker *)startPicker{
    if (!_startPicker){
        NSDatePicker *datePicker = [[NSDatePicker alloc] initWithFrame:NSMakeRect(0, 100, 100, 40)];
        datePicker.datePickerStyle = NSDatePickerStyleTextFieldAndStepper;
        datePicker.datePickerElements = NSDatePickerElementFlagYearMonthDay;
        [datePicker setDateValue: [NSDate date]];
        
//        datePicker.wantsLayer = YES;
//        datePicker.layer.backgroundColor = [NSColor cyanColor].CGColor;
      
        [datePicker setTarget:self];
        [datePicker setAction:@selector(updateDateResult:)];
        
        [datePicker setDateValue:[EZTimeTools getFirstDateForCurrentMonth]];
        
        _startPicker = datePicker;
        _startPicker.tag = 1;
    }
    return _startPicker;
}

-(NSDatePicker *)endPicker{
    if (!_endPicker){
        NSDatePicker *datePicker = [[NSDatePicker alloc] initWithFrame:NSMakeRect(0, 200, 100, 40)];
        datePicker.datePickerStyle = NSDatePickerStyleTextFieldAndStepper;
        datePicker.datePickerElements = NSDatePickerElementFlagYearMonthDay;
        [datePicker setDateValue: [NSDate date]];
        
//        datePicker.wantsLayer = YES;
//        datePicker.layer.backgroundColor = [NSColor cyanColor].CGColor;
     

        [datePicker setTarget:self];
        [datePicker setAction:@selector(updateDateResult:)];
        
        _endPicker = datePicker;
        _endPicker.tag = 2;
    }
    return _endPicker;
}


-(NSDatePicker *)monthPicker{
    
    if (!_monthPicker){
        NSDatePicker *datePicker = [[NSDatePicker alloc] initWithFrame:NSMakeRect(0, 500, 200, 50)];
        datePicker.datePickerStyle = NSDatePickerStyleTextFieldAndStepper;
        datePicker.datePickerElements = NSDatePickerElementFlagYearMonth;
        [datePicker setDateValue: [NSDate date]];
        
//        datePicker.wantsLayer = YES;
//        datePicker.layer.backgroundColor = [NSColor cyanColor].CGColor;
     

        [datePicker setTarget:self];
        [datePicker setAction:@selector(updateDateResult:)];
        _monthPicker = datePicker;
        _monthPicker.tag = 0;
    }
    return  _monthPicker;
}

@end
