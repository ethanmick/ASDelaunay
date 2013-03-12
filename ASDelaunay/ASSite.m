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

#define EPSILON .005

@interface ASSite()

@property (nonatomic) NSUInteger siteIndex;
@property (nonatomic, strong) ASPoint *coord;
@property (nonatomic) CGFloat weight;
@property (nonatomic, strong) NSMutableArray *edges;
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) NSMutableArray *edgeOrientation;

@end

//static NSMutableArray *pool = nil;

@implementation ASSite

@synthesize siteIndex, coord, weight, edges, points;



- (id)initWithPoint:(ASPoint *)aPoint index:(NSUInteger)anIndex weight:(CGFloat)aWeight {
    if ( (self = [super init]) ) {
        self.coord = aPoint;
        self.siteIndex = anIndex;
        self.weight = aWeight;
        self.edges = [[NSMutableArray alloc] init];
        self.points = nil;
    }
    return self;
}

+ (id)createWithPoint:(ASPoint *)aPoint index:(NSUInteger)anIndex weight:(CGFloat)aWeight {
//    if (!pool) {
//        pool = [NSMutableArray array];
//    }
    
    ///
    /// I think the pool is just a memory management sort of thing. If necessary, I'll play around with it later.
    ///
    
//    if ([pool count] > 0) {
//        [[pool lastObject] initWithPoint:<#(ASPoint *)#> index:<#(NSUInteger)#> weight:<#(CGFloat)#>];
//    } else {
        return [[ASSite alloc] initWithPoint:aPoint index:anIndex weight:aWeight];
//    }
}

+ (BOOL)closeEnough:(ASPoint *)p0 andPoint:(ASPoint *)p1 {
    return [ASPoint distanceBetweenPoint0:p0 andPoint1:p1] < EPSILON;
}

- (ASPoint *)coord {
    return self.coord;
}

+ (void)sortSites:(NSMutableArray *)someSites {
    [someSites sortUsingSelector:@selector(compare:)];
}


//acending = -1
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


- (CGFloat)getX {
    return self.coord.x;
}

- (CGFloat)getY {
    return self.coord.y;
}

- (CGFloat)distance:(id<ICoord>)aCoord {
    return [ASPoint distanceBetweenPoint0:aCoord andPoint1:self.coord];
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
    
}






private function reorderEdges():void
{
    //trace("_edges:", _edges);
    var reorderer:EdgeReorderer = new EdgeReorderer(_edges, Vertex);
    _edges = reorderer.edges;
    //trace("reordered:", _edges);
    _edgeOrientations = reorderer.edgeOrientations;
    reorderer.dispose();
}





@end
