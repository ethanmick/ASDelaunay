//
//  ASHalfedgePriorityQueue.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/14/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASHalfEdge, ASPoint;

@interface ASHalfedgePriorityQueue : NSObject

- (id)initWithYMin:(double)aYmin deltay:(double)aDeltay sqrtNSites:(NSInteger)sqrtNSites;
- (void)insert:(ASHalfEdge *)halfEdge;
- (void)remove:(ASHalfEdge *)halfEdge;
- (BOOL)empty;
- (ASPoint *)min;
- (ASHalfEdge *)extraMin;

@end
