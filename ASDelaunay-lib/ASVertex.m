//
//  ASVertex.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/11/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASVertex.h"
#import "ASHalfEdge.h"
#import "ASEdge.h"
#import "ASDelaunay.h"
#import "ASSite.h"
#import "ASLR.h"

static ASVertex *_VERTEX_AT_INFINITY = nil;
static int nvertices = 0;

@interface ASVertex()

@property (nonatomic, strong) ASPoint *coord;

@end

@implementation ASVertex

+ (ASVertex *)VERTEX_AT_INFINITY {
    if (_VERTEX_AT_INFINITY == nil) {
        _VERTEX_AT_INFINITY = [[ASVertex alloc] initWith:INFINITY y:INFINITY];
    }
    return _VERTEX_AT_INFINITY;
}


- (id)initWith:(double)x y:(double)y {
    
    if ( (self = [super init]) ) {
        
//        if (x == INFINITY && y == INFINITY) {
//            return [ASVertex VERTEX_AT_INFINITY];
//        }
        
        self.coord = [[ASPoint alloc] initWithX:x y:y];
    }
    
    return self;
}

- (ASPoint *)coord {
    return _coord;
}

- (void)setIndex {
    _vertexIndex = nvertices++;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Vertex ( %d )", self.vertexIndex];
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]] && [[self coord] isEqual:[object coord]];
}

- (double)getX {
    return _coord.x;
}

- (double)getY {
    return _coord.y;
}

+ (ASVertex *)intersect:(ASHalfEdge *)halfEdge0 halfEdge1:(ASHalfEdge *)halfEdge1 {
    ASEdge *edge0; ASEdge *edge1; ASEdge *edge;
    ASHalfEdge *halfEdge;
    double determinant; double intersectionX; double intersectionY;
    BOOL rightOfSite;
    
    edge0 = halfEdge0.edge;
    edge1 = halfEdge1.edge;
    
    if (edge0 == nil || edge1 == nil) {
        return nil;
    }
    
    if (edge0.rightSite == edge1.rightSite) {
        return nil;
    }
    
    determinant = edge0.a * edge1.b - edge0.b * edge1.a;
    if (-1.0e-10 < determinant && determinant < 1.0e-10) {
        return nil;
    }
    
    intersectionX = (edge0.c * edge1.b - edge1.c * edge0.b) / determinant;
    intersectionY = (edge1.c * edge0.a - edge0.c * edge1.a) / determinant;
    
    if ([ASDelaunay compareByYThenX:edge0.rightSite site2:edge1.rightSite] < 0)
    {
        halfEdge = halfEdge0; edge = edge0;
    }
    else
    {
        halfEdge = halfEdge1; edge = edge1;
    }
    rightOfSite = intersectionX >= [edge.rightSite getX];
    if ((rightOfSite && halfEdge.leftRight == [ASLR LEFT])
        ||  (!rightOfSite && halfEdge.leftRight == [ASLR RIGHT]))
    {
        return nil;
    }
    
    return [[ASVertex alloc] initWith:intersectionX y:intersectionY];
}



@end
