//
//  ASPoint.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASPoint.h"

@implementation ASPoint

@synthesize x, y;

- (id)initWithX:(double)anX y:(double)aY {
    if ( (self = [super init]) ) {
        self.x = anX;
        self.y = aY;
    }
    return self;
}

+ (instancetype)pointWithX:(double)anX y:(double)aY {
    return [[ASPoint alloc] initWithX:anX y:aY];
}

- (CGPoint)point {
    return CGPointMake(self.x, self.y);
}

- (double)getX {
    return self.x;
}

- (double)getY {
    return self.y;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"( %f, %f )", self.x, self.y];
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]] && ([self x] == [(ASPoint *)object x]) && ([self y] == [(ASPoint *)object y]);
}

- (id)copyWithZone:(NSZone *)zone {
    return [[ASPoint alloc] initWithX:self.x y:self.y];
}

#pragma mark - Class Methods

+ (double)distanceBetweenPoint0:(ASPoint *)p0 andPoint1:(ASPoint *)p1 {
    return sqrt(((p1.x - p0.x) * (p1.x - p0.x)) + ((p1.y - p0.y) * (p1.y - p0.y)));
}

- (NSComparisonResult)compareYThenX:(ASPoint *)p0 {
    if (self.y < p0.y) return NSOrderedAscending;
    if (self.y > p0.y) return NSOrderedDescending;
    if (self.x < p0.x) return NSOrderedAscending;
    if (self.x > p0.x) return NSOrderedDescending;
    return NSOrderedSame;
}


@end
