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

- (id)initWithX:(CGFloat)anX y:(CGFloat)aY {
    if ( (self = [super init]) ) {
        self.x = anX;
        self.y = aY;
    }
    return self;
}

- (CGPoint)point {
    return CGPointMake(self.x, self.y);
}


#pragma mark - Class Methods

+ (CGFloat)distanceBetweenPoint0:(ASPoint *)p0 andPoint1:(ASPoint *)p1 {
    return sqrt(((p1.x - p0.x) * (p1.x - p0.x)) + ((p1.y - p0.y) * (p1.y - p0.y)));
}

@end
