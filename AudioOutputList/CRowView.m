//
//  CRowView.m
//  AudioOutputList
//
//  Created by Jonathan Ramirez on 7/2/15.
//  Copyright (c) 2015 HeadWorkGames. All rights reserved.
//

#import "CRowView.h"

@implementation CRowView
@synthesize title;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSCenterTextAlignment;
    NSDictionary *attribute = @{NSFontAttributeName: [NSFont fontWithName: @"HelveticaNeue" size: 20], NSForegroundColorAttributeName: [NSColor whiteColor], NSParagraphStyleAttributeName: style};
    
    [title drawInRect:dirtyRect withAttributes:attribute];
}

@end
