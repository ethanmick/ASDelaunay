//
//  ASPoint.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASPoint.h"

@implementation ASPoint

@synthesize point;


- (CGFloat)x {
    return self.point.x;
}

- (CGFloat)y {
    return self.point.y;
}

- (void)setX:(CGFloat)x {
    self.point = CGPointMake(x, self.point.y);
}

- (void)setY:(CGFloat)y {
    self.point = CGPointMake(self.point.x, y);
}

#pragma mark - Class Methods

+ (CGFloat)distanceBetweenPoint0:(ASPoint *)p0 andPoint1:(ASPoint *)p1 {
    return sqrt(((p1.x - p0.x) * (p1.x - p0.x)) + ((p1.y - p0.y) * (p1.y - p0.y)));
}

@end
