//
//  ASHalfEdge.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/12/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASHalfEdge.h"
#import "ASEdge.h"
#import "ASLR.h"
#import "ASPoint.h"
#import "ASSite.h"


@implementation ASHalfEdge

@synthesize edge, edgeListLeftNeighbor, edgeListRightNeighbor, leftRight, nextInPriorityQueue, vertex;
@synthesize ystar;

- (id)initWithEdge:(ASEdge *)anEdge lr:(ASLR *)lr {
    
    if ( (self = [super init]) ) {
        self.edge = anEdge;
        self.leftRight = lr;
        self.nextInPriorityQueue = nil;
        self.vertex = nil;
        self.edgeListLeftNeighbor = nil;
        self.edgeListRightNeighbor = nil;
    }
    return self;
}

+ (instancetype)createDummy {
    return [[ASHalfEdge alloc] initWithEdge:nil lr:nil];
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]] &&
    [self.edge isEqual:[object edge]] &&
    [self.leftRight isEqual:[object leftRight]] &&
    [self.edgeListLeftNeighbor isEqual:[object edgeListLeftNeighbor]] &&
    [self.edgeListRightNeighbor isEqual:[object edgeListRightNeighbor]];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"Halfedge ( leftRight: %@ vertex: %@ LeftHalfEdge Nil?: %d RightHalfEdge Nil?: %d)", self.leftRight, self.vertex,
            self.edgeListLeftNeighbor == nil, self.edgeListRightNeighbor == nil];
}

//- (void)remove:(ASHalfEdge *)halfEdge {
//    halfEdge.edgeListLeftNeighbor.edgeListRightNeighbor = halfEdge.edgeListRightNeighbor;
//    halfEdge.edgeListRightNeighbor.edgeListLeftNeighbor = halfEdge.edgeListLeftNeighbor;
//    halfEdge.edge = [ASEdge DELETED];
//    halfEdge.edgeListLeftNeighbor = halfEdge.edgeListRightNeighbor = nil;
//}


- (BOOL)isLeftOf:(ASPoint *)p {
    ASSite *topSite;
    BOOL rightOfSite; BOOL above; BOOL fast;
    double dxp; double dyp; double dxs; double t1; double t2; double t3; double yl;
    
    topSite = [self.edge rightSite];
    rightOfSite = p.x > [topSite getX];
    if (rightOfSite && self.leftRight == [ASLR LEFT]) {
        return YES;
    }
    
    if (!rightOfSite && self.leftRight == [ASLR RIGHT]) {
        return NO;
    }
    
    if (self.edge.a == 1.0) {
        dyp = p.y - [topSite getY];
        dxp = p.x - [topSite getX];
        fast = NO;
        if ((!rightOfSite && self.edge.b < 0.0) || (rightOfSite && self.edge.b >= 0.0) )
        {
            above = dyp >= self.edge.b * dxp;
            fast = above;
        } else {
            above = p.x + p.y * self.edge.b > self.edge.c;
            if (self.edge.b < 0.0)
            {
                above = !above;
            }
            if (!above)
            {
                fast = true;
            }
        }
        if (!fast) {
            dxs = [topSite getX] - [self.edge.leftSite getX];
            above = edge.b * (dxp * dxp - dyp * dyp) < dxs * dyp * (1.0 + 2.0 * dxp/dxs + edge.b * edge.b);
            if (edge.b < 0.0)
            {
                above = !above;
            }
        }
    } else  /* edge.b == 1.0 */ {
        yl = edge.c - edge.a * p.x;
        t1 = p.y - yl;
        t2 = p.x - [topSite getX];
        t3 = yl - [topSite getY];
        above = t1 * t1 > t2 * t2 + t3 * t3;
    }

    return self.leftRight == [ASLR LEFT] ? above : !above;
}



@end
