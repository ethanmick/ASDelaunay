//
//  ASSite.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASSite.h"
#import "ASPoint.h"
#import "ASVoronoi.h"
#import "ASEdge.h"
#import "ASEdgeReorderer.h"
#import "ASVertex.h"

#define EPSILON .005

@interface ASSite()

@property (nonatomic) NSUInteger siteIndex;
@property (nonatomic, strong) ASPoint *coord;
@property (nonatomic) double weight;
@property (nonatomic, strong) NSMutableArray *edges;
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) NSMutableArray *edgeOrientation;
@property (nonatomic, strong) NSMutableArray *regions;

@end

//static NSMutableArray *pool = nil;

@implementation ASSite

@synthesize siteIndex, coord, weight, edges, points;



- (id)initWithPoint:(ASPoint *)aPoint index:(NSUInteger)anIndex weight:(double)aWeight {
    if ( (self = [super init]) ) {
        self.coord = aPoint;
        self.siteIndex = anIndex;
        self.weight = aWeight;
        self.edges = [[NSMutableArray alloc] init];
        self.points = nil;
        self.regions = nil;
    }
    return self;
}

+ (id)createWithPoint:(ASPoint *)aPoint index:(NSUInteger)anIndex weight:(double)aWeight {
//    if (!pool) {
//        pool = [NSMutableArray array];
//    }
    
    ///
    /// I think the pool is just a memory management sort of thing. If necessary, I'll play around with it later.
    ///
    
//    if ([pool count] > 0) {
//        [[pool lastObject] initWithPoint:<#(ASPoint *)#> index:<#(NSUInteger)#> weight:<#(double)#>];
//    } else {
        return [[ASSite alloc] initWithPoint:aPoint index:anIndex weight:aWeight];
//    }
}

+ (BOOL)closeEnough:(ASPoint *)p0 andPoint:(ASPoint *)p1 {
    return [ASPoint distanceBetweenPoint0:p0 andPoint1:p1] < EPSILON;
}

- (ASPoint *)coord {
    return coord;
}

+ (void)sortSites:(NSMutableArray *)someSites {
    [someSites sortUsingSelector:@selector(compare:)];
}


- (NSComparisonResult)compare:(id)object {
    NSComparisonResult returnValue = [ASVoronoi compareByYThenX:self site2:object];
    ASSite *s2 = (ASSite *)object;
    
    NSInteger tempIndex;
    if (returnValue == NSOrderedAscending) {
        if ([self siteIndex] > [s2 siteIndex]) {
            tempIndex = [self siteIndex];
            self.siteIndex = [s2 siteIndex];
            s2.siteIndex = tempIndex;
        }
    } else if (returnValue == NSOrderedDescending) {
        if (s2.siteIndex > self.siteIndex) {
            tempIndex = s2.siteIndex;
            s2.siteIndex = self.siteIndex;
            self.siteIndex = tempIndex;
        }
    }
return returnValue;
}


- (double)getX {
    return self.coord.x;
}

- (double)getY {
    return self.coord.y;
}

- (double)distance:(id<ICoord>)aCoord {
    return [ASPoint distanceBetweenPoint0:[aCoord coord] andPoint1:self.coord];
}

- (NSMutableArray *)getEdges {
    return self.edges;
}

- (void)move:(ASPoint *)aPoint {
    self.coord = aPoint;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ASSite %d: %@", self.siteIndex, self.coord];
}

- (void)addEdge:(ASEdge *)anEdge {
    [self.edges addObject:anEdge];
}

- (ASEdge *)nearestEdge {
    [self.edges sortUsingSelector:@selector(compareSiteDistance:)];
    return [self.edges objectAtIndex:0];
}

- (NSMutableArray *)neighborSites {
    if (self.edges == nil || [self.edges count] == 0) {
        return [NSMutableArray array];
    }
    
    if (self.edgeOrientation == nil) {
        [self reorderEdges];
    }
    
    NSMutableArray *list = [NSMutableArray array];
    for (ASEdge *edge in self.edges) {
        [list addObject:[self neighborSite:edge]];
    }
    return list;
}

- (ASSite *)neighborSite:(ASEdge *)edge {
    if (self == [edge leftSite]) {
        return [edge rightSite];
    }
    
    if (self == [edge rightSite]) {
        return [edge leftSite];
    }
    return nil;
}

- (void)reorderEdges {
    ASEdgeReorderer *reorderer = [[ASEdgeReorderer alloc] initWithEdges:self.edges criterion:[ASVertex class]];
    self.edges = [reorderer edges];
    self.edgeOrientation = [reorderer edgeOrientations];
}

//- (NSMutableArray *)region:(CGRect)clippingBounds {
//    if (self.edges == nil || [self.edges count] == 0) {
//        return [NSMutableArray array];
//    }
//    
//    if (self.edgeOrientation == nil) {
//        [self reorderEdges];
//    }
//}







@end
