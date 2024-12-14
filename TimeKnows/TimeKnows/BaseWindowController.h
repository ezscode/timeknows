//
//  BaseWindowController.h
//  ITEffect
//
//  Created by 舒姝 on 2020/4/26.
//  Copyright © 2020 melissashu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, WCStyle) { 
    WCStyle_NoTitleBar = 0,  
    WCStyle_SystemTitleBar,
};


@interface BaseWindowController : NSWindowController

-(instancetype)initWithWCStyle:(WCStyle)style;

@end

NS_ASSUME_NONNULL_END
