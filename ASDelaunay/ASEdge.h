//
//  ASEdge.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASSite;
@class ASVertex;
@class ASLR;
@class ASLineSegment;

@interface ASEdge : NSObject

@property (nonatomic, strong) ASVertex *leftVertex;
@property (nonatomic, strong) ASVertex *rightVertex;
@property (nonatomic) double a;
@property (nonatomic) double b;
@property (nonatomic) double c;

- (NSComparisonResult)compareSiteDistance:(ASEdge *)object;
- (NSComparisonResult)compareSiteDistanceMAX:(ASEdge *)object;
+ (ASEdge *)createBisectingEdge:(ASSite *)site0 site1:(ASSite *)site1;
- (ASLineSegment *)voronoiEdge;
- (ASLineSegment *)delaunayLine;
- (NSMutableDictionary *)clippedEnds;
- (BOOL)visible;
- (double)sitesDistance;
- (void)setLeftSite:(ASSite *)s;
- (ASSite *)leftSite;
- (void)setRightSite:(ASSite *)s;
- (ASSite *)rightSite;
- (ASSite *)site:(ASLR *)leftRight;
- (BOOL)isPartOfConvexHull;
+ (ASEdge *)DELETED;
- (void)setVertex:(ASLR *)leftRight vertex:(ASVertex *)v;
- (void)clipVertices:(CGRect)bounds;

@end
