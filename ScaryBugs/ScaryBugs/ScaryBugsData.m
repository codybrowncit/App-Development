//
//  ScaryBugsData.m
//  ScaryBugs
//
//  Created by Cody Brown on 10/8/14.
//  Copyright (c) 2014 Cody Brown. All rights reserved.
//

#import "ScaryBugsData.h"

@implementation ScaryBugData

- (id)initWithTitle:(NSString*)title rating:(float)rating {
    if ((self = [super init])) {
        self.title = title;
        self.rating = rating;
    }
    return self;
}

@end
