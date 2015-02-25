//
//  ScaryBugDoc.m
//  ScaryBugs
//
//  Created by Cody Brown on 10/10/14.
//  Copyright (c) 2014 Cody Brown. All rights reserved.
//

#import "ScaryBugDoc.h"
#import "ScaryBugsData.h"

@implementation ScaryBugDoc

- (id)initWithTitle:(NSString*)title rating:(float)rating thumbImage:(NSImage *)thumbImage fullImage:(NSImage *)fullImage {
    if ((self = [super init])) {
        self.data = [[ScaryBugData alloc] initWithTitle:title rating:rating];
        self.thumbImage = thumbImage;
        self.fullImage = fullImage;
    }
    return self;
}

@end
