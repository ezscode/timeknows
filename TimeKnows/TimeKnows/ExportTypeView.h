//
//  ExportTypeView.h
//  TimeKnows
//
//  Created by luyi on 2023/7/14.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TKType) {
    TKTypeReminder,
    TKTypeCalendar
};

@interface ExportTypeView : NSView

- (void)refreshReminderList;

@property (nonatomic, assign) TKType type;


-(instancetype)initWithType:(TKType)type;



@end

NS_ASSUME_NONNULL_END
