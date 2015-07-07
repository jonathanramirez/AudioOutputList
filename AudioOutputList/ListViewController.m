//
//  ListViewController.m
//  AudioOutputList
//
//  Created by Jonathan Ramirez on 6/19/15.
//  Copyright (c) 2015 HeadWorkGames. All rights reserved.
//

#import "ListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CRowView.h"

@interface ListViewController () <NSTableViewDelegate, NSTableViewDataSource>
{
    NSMutableArray *deviceList;
}
@property (strong) NSTableView *myTableView;
@property (strong) NSScrollView *scrollView;
@end

@implementation ListViewController
@synthesize myTableView;
@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.autoresizingMask = NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin | NSViewWidthSizable | NSViewHeightSizable;
    
    self.view.wantsLayer = YES;

    deviceList = [[NSMutableArray alloc] initWithArray:[self getListOfAllOutputDevices]];
    
    
    scrollView = [[NSScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.drawsBackground = YES;
    scrollView.hasHorizontalScroller = NO;
    scrollView.autoresizingMask =  NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin | NSViewWidthSizable | NSViewHeightSizable;
    scrollView.backgroundColor = [NSColor redColor];
    
    myTableView = [[NSTableView alloc] initWithFrame:self.view.bounds];
    myTableView.autoresizingMask = NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin | NSViewWidthSizable | NSViewHeightSizable;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.headerView = nil;
    NSTableColumn * column1 = [[NSTableColumn alloc] initWithIdentifier:@"Col1"];
    [column1 setWidth:NSWidth(self.view.bounds)];
    [myTableView addTableColumn:column1];
    [myTableView setIntercellSpacing:NSMakeSize(1.0, 1.0)];
    [myTableView setAllowsEmptySelection:NO];
    myTableView.allowsTypeSelect = YES;
    myTableView.allowsMultipleSelection = NO;

    
    
    [scrollView setDocumentView:self.myTableView];
    [scrollView setHasVerticalScroller:NO];
    myTableView.backgroundColor = [NSColor greenColor];
    [self.view addSubview:self.scrollView];
    [self.myTableView reloadData];

//    NSRect          scrollFrame = NSMakeRect( 10, 10, 300, 300 );
//    scrollView  = [[NSScrollView alloc] initWithFrame:scrollFrame];
//    
//    [scrollView setBorderType:NSBezelBorder];
//    [scrollView setHasVerticalScroller:YES];
//    [scrollView setHasHorizontalScroller:YES];
//    [scrollView setAutohidesScrollers:NO];
//    
//    NSRect          clipViewBounds  = [[scrollView contentView] bounds];
//       myTableView       = [[NSTableView alloc] initWithFrame:clipViewBounds];
//    
//    NSTableColumn*  firstColumn     = [[NSTableColumn alloc] initWithIdentifier:@"firstColumn"];
//    [[firstColumn headerCell] setStringValue:@"First Column"];
//    [myTableView  addTableColumn:firstColumn];
//    
//
//    [myTableView setDataSource:self];
//    [scrollView setDocumentView:myTableView];
//    
//    [self.view  addSubview:scrollView];
   
}

#pragma mark - Table View Data Source


#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    
    return [deviceList count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    return @"";
}

#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    
    return [tableView makeViewWithIdentifier:@"Cell" owner:self];
}


- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
    CRowView *cellView = [tableView makeViewWithIdentifier:@"LCell" owner:self];
    if (!cellView) {
        cellView = [[CRowView alloc] init];
    }
    NSDictionary *device = [deviceList objectAtIndex:row];
    cellView.title = [device objectForKey:@"name"];
    return cellView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    
    
    
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex {
    
    return YES;
}


-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 40;
}

#pragma mark -   Devices

- (NSArray*)getListOfAllOutputDevices
{

    NSMutableArray *devices = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *name;
    NSString *UID;
    
    AudioObjectPropertyAddress aopa;
    aopa.mSelector = kAudioHardwarePropertyDevices;
    aopa.mScope = kAudioObjectPropertyScopeGlobal;
    aopa.mElement = kAudioObjectPropertyElementMaster;
    
    UInt32 propSize;
    OSStatus error = AudioObjectGetPropertyDataSize(kAudioObjectSystemObject, &aopa, 0, NULL, &propSize);
    if (error == noErr) {
        int deviceCount = propSize / sizeof(AudioDeviceID);
        AudioDeviceID *audioDevices = (AudioDeviceID *)malloc(propSize);
        error = AudioObjectGetPropertyData(kAudioObjectSystemObject, &aopa, 0, NULL, &propSize, audioDevices);
        if (error == noErr) {
            UInt32 propSize = sizeof(CFStringRef);
            for(int i = 1; i <= deviceCount; i++) {
                NSString *result;
                aopa.mSelector = kAudioDevicePropertyDeviceManufacturerCFString;
                error = AudioObjectGetPropertyData(audioDevices[i], &aopa, 0, NULL, &propSize, &result);
                
                
                aopa.mSelector = kAudioDevicePropertyDeviceNameCFString;
                error = AudioObjectGetPropertyData(audioDevices[i], &aopa, 0, NULL, &propSize, &result);
                
                if (error == noErr) {
                    name = result;
                }
                
                aopa.mSelector = kAudioDevicePropertyDeviceUID;
                error = AudioObjectGetPropertyData(audioDevices[i], &aopa, 0, NULL, &propSize, &result);
                if (error == noErr) {
                    UID = result;
                }

                if (name && UID) {
                    [devices addObject:@{@"name":name, @"UID":UID}];
                }
            }
        }
        free(audioDevices);
    }
    return devices;
}


@end
