    //
    //  BaseWindowController.m
    //  ITEffect
    //
    //  Created by 舒姝 on 2020/4/26.
    //  Copyright © 2020 melissashu. All rights reserved.
    //

#import "BaseWindowController.h"
  
@interface BaseWindowController ()

@property (nonatomic, assign) WCStyle wcstyle;

@end

@implementation BaseWindowController

-(instancetype)init{
    self = [super initWithWindowNibName:@""];
    
    NSLog(@"-- -init");
    
    return self;
}


-(void)loadWindow{
    [self initWindow];
        //    NSLog(@"-- loadWindow");
    
//    [self.window.contentView ezSetLayerColor:[NSColor blackColor]];
    
}

-(instancetype)initWithWCStyle:(WCStyle)style{
    
    self = [super initWithWindowNibName:@""];
    
    NSLog(@"-- -initWithTitleBar");
    
    self.wcstyle = style;
    
    return self;
}

-(instancetype)initWithWindowNibName:(NSNibName)windowNibName{
    self = [super initWithWindowNibName:windowNibName];
    
    NSLog(@"-- -initWithWindowNibName : %@", windowNibName);
    return self;
} 

- (void)initWindow{
    
    NSLog(@"wcstyle : %ld", self.wcstyle);
    
    NSWindowStyleMask styleMask = NSWindowStyleMaskClosable |
    NSWindowStyleMaskMiniaturizable |
    NSWindowStyleMaskResizable ;
    
    if (self.wcstyle == WCStyle_NoTitleBar) {  // 无标题栏
        styleMask = styleMask | NSWindowStyleMaskTitled |
                NSWindowStyleMaskFullSizeContentView ;
         
    }else if (self.wcstyle == WCStyle_SystemTitleBar) {  // 系统标题栏
        
        styleMask = styleMask | NSWindowStyleMaskTitled;
            //        NSWindowStyleMaskBorderless |
            //            NSWindowStyleMaskFullSizeContentView
            //
            ////         NSWindowStyleMaskUnifiedTitleAndToolbar |
            ////               NSWindowStyleMaskFullScreen  | //  不显示标题栏
            //                NSWindowStyleMaskTitled
        ;
    }
    
    CGFloat kWindow_Width = 500;
    CGFloat kWindow_Height = 600;
     
    NSRect rect = NSMakeRect(100, 100, kWindow_Width, kWindow_Height);
        // NoTitleBarWindow， 如果使用 NSWindow，无法成为主窗口
    self.window = [[NSWindow alloc] initWithContentRect:rect
                                              styleMask:styleMask
                                                backing:NSBackingStoreBuffered
                                                  defer:YES];
    
    
    if (self.wcstyle == WCStyle_NoTitleBar) {
        
        self.window.titlebarAppearsTransparent = YES;
        self.window.titleVisibility = NSWindowTitleHidden;
                
        [self.window setOpaque:NO];
    }
    
    self.window.movableByWindowBackground = YES;
    self.window.alphaValue = 1.0;
        //    self.window.delegate = self;
    
//    [self.window setBackgroundColor:[NSColor clearColor]];
        //    [self.window setBackgroundColor:[NSColor colorWithWhite:0.6 alpha:0.2]];
    
    self.window.contentView.wantsLayer = YES;
    self.window.contentView.layer.backgroundColor = [NSColor colorWithWhite:0.6 alpha:0.2].CGColor;
    self.window.contentView.layer.cornerRadius = 4;
    self.window.contentView.layer.masksToBounds = YES;
    
        //    [self setupViews];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    NSLog(@"-- bwc windowDidLoad");
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}



@end
