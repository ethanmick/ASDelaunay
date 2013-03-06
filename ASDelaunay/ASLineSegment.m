//
//  ASLineSegment.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASLineSegment.h"

@implementation ASLineSegment

@synthesize p0, p1;


- (id)initWithPoint0:(CGPoint)aPoint0 point1:(CGPoint)aPoint1 {
    
    if ( (self = [super init]) ) {
        self.p0 = aPoint0;
        self.p1 = aPoint1;
    }
    
    return self;
}


+ (NSInteger)compareLengthsMAX(ASLineSegment *)segment0 segment1:(ASLineSegment *)segment1 {
    
}

@end
