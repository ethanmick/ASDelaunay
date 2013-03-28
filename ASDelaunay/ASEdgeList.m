//
//  ASEdgeList.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/14/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASEdgeList.h"
#import "ASHalfEdge.h"
#import "ASEdge.h"
#import "ASPoint.h"

@interface ASEdgeList()

@property (nonatomic) double deltax;
@property (nonatomic) double xmin;
@property (nonatomic) NSInteger hashSize;
@property (nonatomic, strong) NSMutableArray *hash;

@end

@implementation ASEdgeList

@synthesize deltax, xmin, hash, hashSize;

- (id)initWithXMin:(double)anXmin deltax:(double)aDeltaX sqrtNSites:(NSInteger)sqrtNSites {
    
    if ( (self = [super init]) ) {
        self.xmin = anXmin;
        self.deltax = aDeltaX;
        self.hashSize = 2 * sqrtNSites;
        
        self.hash = [NSMutableArray arrayWithCapacity:hashSize];
        for (NSInteger i = 0; i < self.hashSize; i++) {
            [self.hash addObject:[NSNull null]];
        }
        
        _leftEnd = [ASHalfEdge createDummy];
        _rightEnd = [ASHalfEdge createDummy];
        
        self.leftEnd.edgeListLeftNeighbor = nil;
        self.leftEnd.edgeListRightNeighbor = self.rightEnd;
        self.rightEnd.edgeListLeftNeighbor = self.leftEnd;
        self.rightEnd.edgeListRightNeighbor = nil;
        
        [self.hash replaceObjectAtIndex:0 withObject:self.leftEnd];
        [self.hash replaceObjectAtIndex:self.hashSize - 1 withObject:self.rightEnd];
    }
    return self;
}

- (void)insert:(ASHalfEdge *)lb newHalfEdge:(ASHalfEdge *)newHalfEdge {
    newHalfEdge.edgeListLeftNeighbor = lb;
    newHalfEdge.edgeListRightNeighbor = lb.edgeListRightNeighbor;
    lb.edgeListRightNeighbor.edgeListLeftNeighbor = newHalfEdge;
    lb.edgeListRightNeighbor = newHalfEdge;
}

- (void)remove:(ASHalfEdge *)halfEdge {
    halfEdge.edgeListLeftNeighbor.edgeListRightNeighbor = halfEdge.edgeListRightNeighbor;
    halfEdge.edgeListRightNeighbor.edgeListLeftNeighbor = halfEdge.edgeListLeftNeighbor;
    halfEdge.edge = [ASEdge DELETED];
    halfEdge.edgeListLeftNeighbor = halfEdge.edgeListRightNeighbor = nil;
}


- (ASHalfEdge *)edgeListLeftNeighbor:(ASPoint *)p {
    
    NSInteger i;
    NSInteger bucket;
    ASHalfEdge *halfEdge;
    
    /* Use hash table to get close to desired halfedge */
    bucket = (p.x - self.xmin) / self.deltax * self.hashSize;
    
    if (bucket < 0) {
        bucket = 0;
    }
    if (bucket >= self.hashSize) {
        bucket = self.hashSize - 1;
    }
    
    halfEdge = [self getHash:bucket];

    if (halfEdge == nil) {
        for (i = 1; YES ; ++i) {
            if ( (halfEdge = [self getHash:(bucket - i)]) != nil) break;
            if ( (halfEdge = [self getHash:(bucket + i)]) != nil) break;
        }
    }

    /* Now search linear list of halfedges for the correct one */
    if (halfEdge == self.leftEnd || (halfEdge != self.rightEnd && [halfEdge isLeftOf:p])) {
        
        do {
            halfEdge = halfEdge.edgeListRightNeighbor;
        } while ( halfEdge != self.rightEnd && [halfEdge isLeftOf:p] );
        
        halfEdge = halfEdge.edgeListLeftNeighbor;
    } else {
        
        do {
            halfEdge = halfEdge.edgeListLeftNeighbor;
        } while ( halfEdge != self.leftEnd && ![halfEdge isLeftOf:p]);
    }
    
    /* Update hash table and reference counts */
    if (bucket > 0 && bucket < self.hashSize - 1) {
        [self.hash replaceObjectAtIndex:bucket withObject:(halfEdge != nil ? halfEdge : [NSNull null])];
    }
    return halfEdge;
    
}


- (ASHalfEdge *)getHash:(NSInteger)b {
    ASHalfEdge *halfEdge;
    
    if (b < 0 || b >= self.hashSize) {
        return nil;
    }
    
    id object = [self.hash objectAtIndex:b];
    if (object == [NSNull null]) {
        halfEdge = nil;
    } else {
        halfEdge = (ASHalfEdge *)object;
    }
    
    if (halfEdge != nil && halfEdge.edge == [ASEdge DELETED]) {
        [self.hash replaceObjectAtIndex:b withObject:[NSNull null]];
        return nil;
    } else {
        return halfEdge;
    }
}



@end




