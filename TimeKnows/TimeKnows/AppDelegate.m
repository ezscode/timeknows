//
//  AppDelegate.m
//  TimeKnows
//
//  Created by luyi on 2023/7/11.
//

#import "AppDelegate.h"
#import "EventManager.h"
#import "ExportTypeView.h"


#import "MainWindowController.h"

@interface AppDelegate ()
 
@property (nonatomic, strong) MainWindowController *mainWC;

@end

@implementation AppDelegate

 

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
     
    
//    [[EventManager sharedInstance] getReminderAuthorizationStatus];
    [[EventManager sharedInstance] requestAuthorizationReminder];
    [[EventManager sharedInstance] requestAuthorizationCalaner];
     
    
    [self.mainWC.window makeKeyAndOrderFront:nil];
    
}

-(BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag{
    NSLog(@"-- should handle reopen ");
    [self.mainWC.window makeKeyAndOrderFront:nil];
    return YES;
}

//-(NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender{
//
//}

-(void)applicationDidBecomeActive:(NSNotification *)notification{
    NSLog(@"-- app become active ");
//    [self.mainWC.window makeKeyAndOrderFront:nil];
    
}
 

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

#pragma mark - 
-(MainWindowController *)mainWC{
   if (!_mainWC) {
       _mainWC = [[MainWindowController alloc] init];
   }
   return _mainWC;
}

@end
