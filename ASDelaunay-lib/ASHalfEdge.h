//
//  ASHalfEdge.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/12/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASHalfEdge, ASEdge, ASLR, ASVertex, ASPoint;

/**
 * http://www.flipcode.com/archives/The_Half-Edge_Data_Structure.shtml
 *
 * The half-edge data structure is called that because instead of storing the edges of the mesh, we store half-edges. As the name implies,
 * a half-edge is a half of an edge and is constructed by splitting an edge down its length. We'll call the two half-edges that make up an edge a pair.
 * Half-edges are directed and the two edges of a pair have opposite directions.
 *
 */
@interface ASHalfEdge : NSObject

/**
 * The left neighbor to this half edge
 */
@property (nonatomic, strong) ASHalfEdge *edgeListLeftNeighbor;

/**
 * The right neighbor.
 */
@property (nonatomic, strong) ASHalfEdge *edgeListRightNeighbor;

@property (nonatomic, strong) ASHalfEdge *nextInPriorityQueue;

@property (nonatomic, strong) ASEdge *edge; //Why do we need an Edge?

/**
 * It looks like this is used in the orientation, which "side" the halfEdge represents.
 * Although I'm not convincied Left/Right notation is appropriate.
 */
@property (nonatomic, strong) ASLR *leftRight;

/**
 * The vertexx that this half edge touches - and it only touches one.
 */
@property (nonatomic, strong) ASVertex *vertex;

/**
 * The vertex's y-coordinate in the transformed Voronoi space V*
 * What?
 */
@property (nonatomic) double ystar;


- (id)initWithEdge:(ASEdge *)anEdge lr:(ASLR *)lr;
+ (instancetype)createDummy;
- (BOOL)isLeftOf:(ASPoint *)p;
//- (void)remove:(ASHalfEdge *)halfEdge; //Remove this later.


@end