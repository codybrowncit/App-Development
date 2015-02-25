//
//  ScaryBugsData.h
//  ScaryBugs
//
//  Created by Cody Brown on 10/8/14.
//  Copyright (c) 2014 Cody Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScaryBugData : NSObject

@property (strong) NSString *title;
@property (assign) float rating;

- (id)initWithTitle:(NSString*)title rating:(float)rating;

@end
