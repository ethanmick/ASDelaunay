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

- (double)signedDoubleArea;

@end

@implementation ASPolygon

- (id)initWithPoints:(NSArray *)points {
    
    if ( (self = [super init]) ) {
        self.vertices = [NSMutableArray arrayWithArray:points];
    }
    return self;
}

- (ASWinding *)winding {
    double doubleSignedArea = [self signedDoubleArea];
    
    if (doubleSignedArea < 0) {
        return [ASWinding CLOCKWISE];
    }
    if (doubleSignedArea > 0) {
        return [ASWinding COUNTERCLOCKWISE];
    }
    return [ASWinding NONE];
}

- (double)area {
    return fabsf( [self signedDoubleArea] * .5 );
}



#pragma mark - Private

- (double)signedDoubleArea {
    NSUInteger index;
    NSUInteger nextIndex = 0;
    NSUInteger n = [self.vertices count];
    ASPoint *point = nil;
    ASPoint *next = nil;
    double signedDoubleArea = 0;
    
    for (index = 0; index < n; ++index) {
        nextIndex = (index + 1) % n;
        point = [self.vertices objectAtIndex:index];
        next = [self.vertices objectAtIndex:nextIndex];
        signedDoubleArea += point.x * next.y - next.x * point.y;
    }
    return signedDoubleArea;
}

@end

