//
//  ASHalfEdge.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/12/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASHalfEdge, ASEdge, ASLR, ASVertex, ASPoint;

@interface ASHalfEdge : NSObject

@property (nonatomic, strong) ASHalfEdge *edgeListLeftNeighbor;
@property (nonatomic, strong) ASHalfEdge *edgeListRightNeighbor;
@property (nonatomic, strong) ASHalfEdge *nextInPriorityQueue;

@property (nonatomic, strong) ASEdge *edge;
@property (nonatomic, strong) ASLR *leftRight;
@property (nonatomic, strong) ASVertex *vertex;
@property (nonatomic) double ystar;


- (id)initWithEdge:(ASEdge *)anEdge lr:(ASLR *)lr;
+ (instancetype)createDummy;
- (BOOL)isLeftOf:(ASPoint *)p;
- (void)remove:(ASHalfEdge *)halfEdge;


@end