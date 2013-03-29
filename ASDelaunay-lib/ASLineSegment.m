//
//  ASLineSegment.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASLineSegment.h"
#import "ASPoint.h"

@implementation ASLineSegment

@synthesize p0, p1;


- (id)initWithPoint0:(ASPoint *)aPoint0 point1:(ASPoint *)aPoint1 {
    
    if ( (self = [super init]) ) {
        self.p0 = aPoint0;
        self.p1 = aPoint1;
    }
    
    return self;
}


+ (NSInteger)compareLengthsMAX:(ASLineSegment *)segment0 segment1:(ASLineSegment *)segment1 {
    double length0 = [ASPoint distanceBetweenPoint0:segment0.p0 andPoint1:segment0.p1];
    double length1 = [ASPoint distanceBetweenPoint0:segment1.p0 andPoint1:segment1.p1];
    if (length0 < length1) {
        return 1;
    }
    if (length0 > length1) {
        return -1;
    }
    return 0;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ ---- %@", self.p0, self.p1];
}


+ (double)compareLengths:(ASLineSegment *)segment0 segment1:(ASLineSegment *)segment1 {
    return -[self compareLengthsMAX:segment0 segment1:segment1];
}

@end
