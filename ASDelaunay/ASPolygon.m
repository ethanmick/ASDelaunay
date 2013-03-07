//
//  ASPolygon.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASPolygon.h"
#import "ASPoint.h"
#import "ASWinding.h"

@interface ASPolygon()

@property (nonatomic, copy) NSMutableArray *vertices;

- (CGFloat)signedDoubleArea;

@end

@implementation ASPolygon

@synthesize vertices;

- (id)initWithPoints:(NSArray *)points {
    
    if ( (self = [super init]) ) {
        self.vertices = [NSMutableArray arrayWithArray:points];
    }
    return self;
}

- (ASWinding *)winding {
    CGFloat doubleSignedArea = [self signedDoubleArea];
    
    if (doubleSignedArea < 0) {
        return [ASWinding CLOCKWISE];
    }
    if (doubleSignedArea > 0) {
        return [ASWinding COUNTERCLOCKWISE];
    }
    return [ASWinding NONE];
}

- (CGFloat)area {
    return fabsf( [self signedDoubleArea] * .5 );
}



#pragma mark - Private

- (CGFloat)signedDoubleArea {
    NSUInteger index = 0;
    NSUInteger nextIndex = 0;
    NSUInteger n = [self.vertices count];
    ASPoint *point = nil;
    ASPoint *next = nil;
    double signedDoubleArea = 0;
    
    for (index = 0; index < n; ++index) {
        nextIndex = (index + 1) % n;
        point = [self.vertices objectAtIndex:n];
        next = [self.vertices objectAtIndex:nextIndex];
        signedDoubleArea += point.x * next.y - next.x * point.y;
    }
    return signedDoubleArea;
}

@end

