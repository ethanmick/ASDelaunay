//
//  ASLR.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/10/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASLR.h"

@interface ASLR()

@property (nonatomic, strong) NSString *name;

@end

@implementation ASLR

@synthesize name;

// should be private
- (id)initWithName:(NSString *)aName {
    if ( (self = [super init]) ) {
        self.name = aName;
    }
    return self;
}

+ (ASLR *)LEFT {
    static ASLR *LEFT = nil;
    if (!LEFT) {
        LEFT = [[ASLR alloc] initWithName:@"LEFT"];
    }
    return LEFT;
}

+ (ASLR *)RIGHT {
    static ASLR *RIGHT = nil;
    if (!RIGHT) {
        RIGHT = [[ASLR alloc] initWithName:@"RIGHT"];
    }
    return RIGHT;
}

+ (ASLR *)other:(ASLR *)leftRight {
    return leftRight == [self LEFT] ? [self RIGHT] : [self LEFT];
}

///
/// We'll work on memory management later
///
- (id)copyWithZone:(NSZone *)zone {
    return [[ASLR alloc] initWithName:self.name];
}


- (NSString *)description {
    return name;
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]] && [self name] == [object name];
}

@end
