//
//  AppDelegate.m
//  AudioOutputList
//
//  Created by Jonathan Ramirez on 6/19/15.
//  Copyright (c) 2015 HeadWorkGames. All rights reserved.
//

#import "AppDelegate.h"
#import "ListViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong) ListViewController *listViewController;
@end

@implementation AppDelegate
@synthesize listViewController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    listViewController = [ListViewController new];
    listViewController.view.frame = [self.window.contentView bounds];
    [self.window.contentView addSubview:listViewController.view];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
