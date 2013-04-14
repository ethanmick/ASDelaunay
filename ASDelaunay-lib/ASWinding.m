//
//  ASWinding.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASWinding.h"

@interface ASWinding()

@property (nonatomic, strong) NSString *name;

@end

@implementation ASWinding

static ASWinding *clockwise = nil;
static ASWinding *counterClockwise = nil;
static ASWinding *none = nil;


- (id)initWithName:(NSString *)string {
    
    if ( (self = [super init]) ) {
        self.name = string;
    }
    return self;
}


- (NSString *)description {
    return _name;
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]] && [[object name] isEqual:self.name];
}

+ (ASWinding *)CLOCKWISE {
    if (clockwise == nil) {
        clockwise = [[ASWinding alloc] initWithName:@"clockwise"];
    }
    return clockwise;
}

+ (ASWinding *)COUNTERCLOCKWISE {
    if (counterClockwise == nil) {
        counterClockwise = [[ASWinding alloc] initWithName:@"counterclockwise"];
    }
    return counterClockwise;
}

+ (ASWinding *)NONE {
    if (none == nil) {
        none = [[ASWinding alloc] initWithName:@"none"];
    }
    return none;
}

@end