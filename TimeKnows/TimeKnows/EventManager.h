//
//  EventManager.h
//  TimeKnows
//
//  Created by luyi on 2023/7/11.
//

#import <Foundation/Foundation.h>

#import <EventKit/EventKit.h>
#import <AppKit/AppKit.h>
#import "EZTimeTools.h"


NS_ASSUME_NONNULL_BEGIN

@interface EventManager : NSObject

+ (instancetype)sharedInstance;


- (EKAuthorizationStatus)getReminderAuthorizationStatus;

- (void)requestAuthorizationReminder;
- (void)requestAuthorizationCalaner;

- (void)jumpToPrivacy;

- (void)getReminders;


- (NSMutableString *)writeReminder:(EKReminder *)reminder;

- (NSMutableString *)writeEvent:(EKEvent *)event;

@end

NS_ASSUME_NONNULL_END
