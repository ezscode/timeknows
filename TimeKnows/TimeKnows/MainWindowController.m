//
//  MainWindowController.m
//  ITEffect
//
//  Created by Shu Shu on 2020/4/15.
//  Copyright © 2020 melissashu. All rights reserved.
//

#import "MainWindowController.h"
#import "ExportTypeView.h"
 
#import "ExportTypeView.h"

@interface MainWindowController ()<NSWindowDelegate, NSTabViewDelegate>

@property (nonatomic, strong) ExportTypeView *reminderView;
@property (nonatomic, strong) ExportTypeView *calendarView;

@property (nonatomic, strong) NSTabView *tabView;

@end

@implementation MainWindowController

- (instancetype)init {
    
    self = [super initWithWCStyle:WCStyle_NoTitleBar];
    
    [self.window setFrame:NSMakeRect(0, 0, 500, 680) display:YES];
    self.window.minSize = NSMakeSize(400, 400);
    
    self.window.title = kAppName;
    self.window.titleVisibility = NSWindowTitleVisible;
    
    return self;
}

 
-(void)windowWillClose:(NSNotification *)notification{
    
    NSLog(@"-- will close ");
}

-(BOOL)windowShouldClose:(NSWindow *)sender{
    
    NSLog(@"-- should close ");
    return NO;
}


- (void)windowDidLoad {
    [super windowDidLoad];
      
    [self setupViews];
    
    [self.reminderView refreshReminderList];
     
    [self.window center];
}



- (void)setupViews{
    
    NSTabView *tabView = [[NSTabView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)]; //如果尺寸较小，而item长度容纳不下，会被挤出去
    //默认是透明色
    tabView.delegate = self;
    tabView.tabPosition = NSTabPositionLeft; //显示位置：显示在左侧
    tabView.tabViewBorderType = NSTabViewBorderTypeBezel;//边框样式：bezel类型边框
    [self.window.contentView addSubview:tabView];

     

    NSTabViewItem *item0 = [[NSTabViewItem alloc]init];
     [item0 setView:self.reminderView];
    item0.identifier = 0;
    
    NSTabViewItem *item1 = [[NSTabViewItem alloc]init];
    [item1 setView:self.calendarView];
    item1.identifier = 0;
 
    
    item0.label = @"提醒事项";
    item1.label = @"日历";
     
    [tabView addTabViewItem:item0];
    [tabView addTabViewItem:item1];
    
    [tabView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.leading.mas_equalTo(15);
        make.top.mas_equalTo(34);
        make.leading.mas_equalTo(16);
        make.bottom.trailing.mas_equalTo(4);
    }];

}

-(void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem{
    
    NSLog(@"didSelect id : %@", tabViewItem.identifier);
    
    [self.reminderView refreshReminderList];
    
}



#pragma mark - NSWindowDelegate

- (void)windowDidBecomeKey:(NSNotification *)notification{
    
}
  
#pragma mark - Lazy

-(ExportTypeView *)calendarView{
    if(!_calendarView){
        _calendarView = [[ExportTypeView alloc] initWithType:TKTypeCalendar];
//        _calendarView.type = EKEntityTypeEvent;
    }
    return _calendarView;
}

-(ExportTypeView *)reminderView{
    if (!_reminderView){
        _reminderView = [[ExportTypeView alloc] initWithType:TKTypeReminder];
//        _calendarView.type = EKEntityTypeReminder;
    }
    return _reminderView;
}
@end
