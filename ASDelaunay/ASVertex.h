//
//  ASVertex.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/11/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASPoint.h"

@class ASHalfEdge;

@interface ASVertex : NSObject <ICoord>

@property (nonatomic, readonly) NSInteger vertexIndex;

- (void)setIndex;
+ (ASVertex *)VERTEX_AT_INFINITY;
- (double)getX;
- (double)getY;
- (id)initWith:(double)x y:(double)y;
+ (ASVertex *)intersect:(ASHalfEdge *)halfEdge0 halfEdge1:(ASHalfEdge *)halfEdge1;

@end
