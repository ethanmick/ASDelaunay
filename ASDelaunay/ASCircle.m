//
//  ASCircle.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASCircle.h"
#import "ASPoint.h"

@implementation ASCircle

@synthesize point, radius;

- (id)initWithX:(CGFloat)anX y:(CGFloat)aY radius:(CGFloat)r {
    
    if ( (self = [super init]) ) {
        self.point = [[ASPoint alloc] initWithX:anX y:aY];
        self.radius = r;
    }
    
    return self;
}

@end
