//
//  ASWinding.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASWinding.h"

@interface ASWinding()

@end

@implementation ASWinding

@synthesize name;

- (id)initWithName:(NSString *)string {
    
    if ( (self = [super init]) ) {
        self.name = string;
    }
    return self;
}


- (NSString *)description {
    return name;
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]] && [[(ASWinding *)object name] isEqual:self.name];
}

+ (ASWinding *)CLOCKWISE {
    return [[ASWinding alloc] initWithName:@"clockwise"];
}

+ (ASWinding *)COUNTERCLOCKWISE {
    return [[ASWinding alloc] initWithName:@"counterclockwise"];
}

+ (ASWinding *)NONE {
    return [[ASWinding alloc] initWithName:@"none"];
}

@end