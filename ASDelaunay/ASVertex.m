//
//  ASVertex.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/11/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASVertex.h"
#import "ASHalfEdge.h"

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


- (id)initWith:(CGFloat)x y:(CGFloat)y {
    
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

- (CGFloat)getX {
    return self.coord.x;
}

- (CGFloat)getY {
    return self.coord.y;
}

+ (NSMutableArray *)intersect:(ASHalfEdge *)halfEdge0 halfEdge1:(ASHalfEdge *)halfEdge1 {
    return nil;
}






/*

public static function intersect(halfedge0:Halfedge, halfedge1:Halfedge):Vertex
{
    var edge0:Edge, edge1:Edge, edge:Edge;
    var halfedge:Halfedge;
    var determinant:Number, intersectionX:Number, intersectionY:Number;
    var rightOfSite:Boolean;
    
    edge0 = halfedge0.edge;
    edge1 = halfedge1.edge;
    if (edge0 == null || edge1 == null)
    {
        return null;
    }
    if (edge0.rightSite == edge1.rightSite)
    {
        return null;
    }
    
    determinant = edge0.a * edge1.b - edge0.b * edge1.a;
    if (-1.0e-10 < determinant && determinant < 1.0e-10)
    {
        // the edges are parallel
        return null;
    }
    
    intersectionX = (edge0.c * edge1.b - edge1.c * edge0.b)/determinant;
    intersectionY = (edge1.c * edge0.a - edge0.c * edge1.a)/determinant;
    
    if (Voronoi.compareByYThenX(edge0.rightSite, edge1.rightSite) < 0)
    {
        halfedge = halfedge0; edge = edge0;
    }
    else
    {
        halfedge = halfedge1; edge = edge1;
    }
    rightOfSite = intersectionX >= edge.rightSite.x;
    if ((rightOfSite && halfedge.leftRight == LR.LEFT)
        ||  (!rightOfSite && halfedge.leftRight == LR.RIGHT))
    {
        return null;
    }
    
    return Vertex.create(intersectionX, intersectionY);
}
*/

@end
