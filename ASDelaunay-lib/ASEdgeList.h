//
//  ASEdgeList.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/14/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASHalfEdge;
@class ASPoint;

@interface ASEdgeList : NSObject

@property (nonatomic, strong, readonly) ASHalfEdge *leftEnd;
@property (nonatomic, strong, readonly) ASHalfEdge *rightEnd;


- (id)initWithXMin:(double)anXmin deltax:(double)aDeltaX sqrtNSites:(NSInteger)sqrtNSites;
- (void)insert:(ASHalfEdge *)lb newHalfEdge:(ASHalfEdge *)newHalfEdge;
- (ASHalfEdge *)edgeListLeftNeighbor:(ASPoint *)p;
- (void)remove:(ASHalfEdge *)halfEdge;



@end
