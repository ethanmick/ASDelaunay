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
#import "ASVoronoi.h"
#import "ASSite.h"
#import "ASLR.h"

@interface ASVertex()

@property (nonatomic, strong) ASPoint *coord;
@property (nonatomic) NSInteger nvertices;

@end

@implementation ASVertex
@synthesize coord, nvertices, vertexIndex;

+ (ASVertex *)VERTEX_AT_INFINITY {
    static ASVertex *VERTEX_AT_INFINITY = nil;
    if (VERTEX_AT_INFINITY == nil) {
        VERTEX_AT_INFINITY = [[ASVertex alloc] initWith:INFINITY y:INFINITY];
    }
    return VERTEX_AT_INFINITY;
}


- (id)initWith:(double)x y:(double)y {
    
    if ( (self = [super init]) ) {
        self.nvertices = 0;
        
        if (x == INFINITY && y == INFINITY) {
            return [ASVertex VERTEX_AT_INFINITY];
        }
        
        self.coord = [[ASPoint alloc] initWithX:x y:y];
    }
    
    return self;
}

- (ASPoint *)coord {
    return self.coord;
}

- (void)setIndex {
    vertexIndex = self.nvertices++;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Vertex ( %d )", self.vertexIndex];
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]] && [self coord] == [object coord];
}

- (double)getX {
    return self.coord.x;
}

- (double)getY {
    return self.coord.y;
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
    
    if ([ASVoronoi compareByYThenX:edge0.rightSite site2:edge1.rightSite] < 0)
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
