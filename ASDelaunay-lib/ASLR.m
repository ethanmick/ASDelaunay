//
//  ASLR.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/10/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASLR.h"

@interface ASLR()


@end

@implementation ASLR

// should be private
- (id)initWithName:(NSString *)aName {
    if ( (self = [super init]) ) {
        _name = aName;
    }
    return self;
}

static ASLR *LEFT = nil;

+ (ASLR *)LEFT {
    if (!LEFT) {
        LEFT = [[ASLR alloc] initWithName:@"LEFT"];
    }
    return LEFT;
}
static ASLR *RIGHT = nil;

+ (ASLR *)RIGHT {
    if (!RIGHT) {
        RIGHT = [[ASLR alloc] initWithName:@"RIGHT"];
    }
    return RIGHT;
}

+ (ASLR *)other:(ASLR *)leftRight {
    return leftRight == [self LEFT] ? [self RIGHT] : [self LEFT];
}

- (NSString *)description {
    return _name;
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]] && [[self name] isEqual:[object name]];
}

@end
