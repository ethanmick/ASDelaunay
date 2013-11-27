//
//  ASSite.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASSite.h"
#import "ASPoint.h"
#import "ASDelaunay.h"
#import "ASEdge.h"
#import "ASEdgeReorderer.h"
#import "ASVertex.h"
#import "ASPolygon.h"
#import "ASWinding.h"
#import "ASLR.h"

#define EPSILON .005

static const NSInteger TOP = 1;
static const NSInteger BOTTOM = 2;
static const NSInteger LEFT = 4;
static const NSInteger RIGHT = 8;

@interface ASSite()

@property (nonatomic) NSUInteger siteIndex;
@property (nonatomic, strong) ASPoint *coord;
@property (nonatomic) double weight;
@property (nonatomic, strong) NSMutableArray *edges;
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) NSMutableArray *edgeOrientation;
@property (nonatomic, strong) NSMutableArray *region;

@end

//static NSMutableArray *pool = nil;

@implementation ASSite

- (id)initWithPoint:(ASPoint *)aPoint index:(NSUInteger)anIndex weight:(double)aWeight {
    if ( (self = [super init]) ) {
        self.coord = aPoint;
        self.siteIndex = anIndex;
        self.weight = aWeight;
        self.edges = [[NSMutableArray alloc] init];
        self.points = nil;
        self.region = nil;
    }
    return self;
}
- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]] && [[self coord] isEqual:[object coord]];
}

+ (id)createWithPoint:(ASPoint *)aPoint index:(NSUInteger)anIndex weight:(double)aWeight {
//    if (!pool) {
//        pool = [NSMutableArray array];
//    }
    
    ///
    /// I think the pool is just a memory management sort of thing. If necessary, I'll play around with it later.
    ///
    
//    if ([pool count] > 0) {
//        [[pool lastObject] initWithPoint:nil index:nil weight:nil];
//    } else {
        return [[ASSite alloc] initWithPoint:aPoint index:anIndex weight:aWeight];
//    }
}

+ (BOOL)closeEnough:(ASPoint *)p0 andPoint:(ASPoint *)p1 {
    return [ASPoint distanceBetweenPoint0:p0 andPoint1:p1] < EPSILON;
}

- (ASPoint *)coord {
    return _coord;
}

+ (void)sortSites:(NSMutableArray *)someSites {
    [someSites sortUsingSelector:@selector(compare:)];
}


- (NSComparisonResult)compare:(id)object {
    NSComparisonResult returnValue = [ASDelaunay compareByYThenX:self site2:object];
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

- (NSMutableArray *)region:(CGRect)clippingBounds {
    if (self.edges == nil || [self.edges count] == 0) {
        return [NSMutableArray array];
    }
    
    if (self.edgeOrientation == nil) {
        [self reorderEdges];
        self.region = [self clipToBounds:clippingBounds];
        if ( [[[[ASPolygon alloc] initWithPoints:self.region] winding] isEqual:[ASWinding CLOCKWISE]]) {
            
            self.region = [NSMutableArray arrayWithArray:[[self.region reverseObjectEnumerator] allObjects]];
        }
    }
    return self.region;
}

- (NSMutableArray *)clipToBounds:(CGRect)bounds {
    NSMutableArray *pointsInner = [NSMutableArray array];
    NSInteger n = [self.edges count];
    NSInteger i = 0;
    ASEdge *edge;
    
    while (i < n && [self.edges[i] visible] == NO ) {
        ++i;
    }
    
    if (i == n) {
        return [NSMutableArray array];
    }
    
    edge = _edges[i];
    ASLR *orientation = _edgeOrientation[i];
    [pointsInner addObject:edge.clippedEnds[[orientation name]]];
    [pointsInner addObject:edge.clippedEnds[[[ASLR other:orientation] name]]];
    
    
    for (NSInteger j = i + 1; j < n; ++j) {
        edge = self.edges[j];
        if ([edge visible] == NO) {
            continue;
        }
        [self connect:_points j:j bounds:bounds closingUp:NO];
    }
    
    [self connect:_points j:i bounds:bounds closingUp:YES];
    return pointsInner;
}


- (NSInteger)check:(ASPoint *)point bounds:(CGRect)bounds {
    NSInteger value = 0;
    if (point.x == bounds.origin.x) {
        value |= LEFT;
    }
    if (point.x == bounds.origin.x + bounds.size.width) {
        value |= RIGHT;
    }
    if (point.y == bounds.origin.y) {
        value |= TOP;
    }
    if (point.y == bounds.origin.y + bounds.size.height) {
        value |= BOTTOM;
    }
    return value;
}

- (void)connect:(NSMutableArray *)thePoints j:(NSInteger)j bounds:(CGRect)bounds closingUp:(BOOL)closingUp {
    ASPoint *rightPoint = [thePoints lastObject];
    ASEdge *newEdge = _edges[j];
    ASLR *newOrientation = _edgeOrientation[j];
    ASPoint *newPoint = newEdge.clippedEnds[[newOrientation name]];
    if (![ASSite closeEnough:rightPoint andPoint:newPoint])
    {
        // The points do not coincide, so they must have been clipped at the bounds;
        // see if they are on the same border of the bounds:
        if (rightPoint.x != newPoint.x && rightPoint.y != newPoint.y)
        {
            // They are on different borders of the bounds;
            // insert one or two corners of bounds as needed to hook them up:
            // (NOTE this will not be correct if the region should take up more than
            // half of the bounds rect, for then we will have gone the wrong way
            // around the bounds and included the smaller part rather than the larger)
            NSInteger rightCheck = [self check:rightPoint bounds:bounds];
            NSInteger newCheck = [self check:newPoint bounds:bounds];
            double px; double py;

            if (rightCheck & RIGHT)
            {
                px = bounds.origin.x + bounds.size.width;
                if (newCheck & BOTTOM)
                {
                    py = bounds.origin.y + bounds.size.height;
                    [thePoints addObject:[[ASPoint alloc] initWithX:px y:py]];
                }
                else if (newCheck & TOP)
                {
                    py = bounds.origin.y;
                    [thePoints addObject:[[ASPoint alloc] initWithX:px y:py]];
                }
                else if (newCheck & LEFT)
                {
                    if (rightPoint.y - bounds.origin.y + newPoint.y - bounds.origin.y < bounds.size.height)
                    {
                        py = bounds.origin.y;
                    }
                    else
                    {
                        py = bounds.origin.y + bounds.size.height;
                    }
                    [thePoints addObject:[[ASPoint alloc] initWithX:px y:py]];
                    [thePoints addObject:[[ASPoint alloc] initWithX:bounds.origin.x y:py]];
                }
            }
            else if (rightCheck & LEFT)
            {
                px = bounds.origin.x;
                if (newCheck & BOTTOM)
                {
                    py = bounds.origin.y + bounds.size.height;
                    [thePoints addObject:[[ASPoint alloc] initWithX:px y:py]];
                }
                else if (newCheck & TOP)
                {
                    py = bounds.origin.y;
                    [thePoints addObject:[[ASPoint alloc] initWithX:px y:py]];
                }
                else if (newCheck & RIGHT)
                {
                    if (rightPoint.y - bounds.origin.y + newPoint.y - bounds.origin.y < bounds.size.height)
                    {
                        py = bounds.origin.y;
                    }
                    else
                    {
                        py = bounds.origin.y + bounds.size.height;
                    }
                    [thePoints addObject:[[ASPoint alloc] initWithX:px y:py]];
                    [thePoints addObject:[[ASPoint alloc] initWithX:bounds.origin.x + bounds.size.width y:py]];
                }
            }
            else if (rightCheck & TOP)
            {
                py = bounds.origin.y;
                if (newCheck & RIGHT)
                {
                    px = bounds.origin.x + bounds.size.width;
                    [thePoints addObject:[[ASPoint alloc] initWithX:px y:py]];
                }
                else if (newCheck & LEFT)
                {
                    px = bounds.origin.x;
                    [thePoints addObject:[[ASPoint alloc] initWithX:px y:py]];
                }
                else if (newCheck & BOTTOM)
                {
                    if (rightPoint.x - bounds.origin.x + newPoint.x - bounds.origin.x < bounds.size.width)
                    {
                        px = bounds.origin.x;
                    }
                    else
                    {
                        px = bounds.origin.x + bounds.size.width;
                    }
                    [thePoints addObject:[[ASPoint alloc] initWithX:px y:py]];
                    [thePoints addObject:[[ASPoint alloc] initWithX:px y:bounds.origin.y + bounds.size.height]];
                }
            }
            else if (rightCheck & BOTTOM)
            {
                py = bounds.origin.y + bounds.size.height;
                if (newCheck & RIGHT)
                {
                    px = bounds.origin.x + bounds.size.width;
                    [thePoints addObject:[[ASPoint alloc] initWithX:px y:py]];
                }
                else if (newCheck & LEFT)
                {
                    px = bounds.origin.x;
                    [thePoints addObject:[[ASPoint alloc] initWithX:px y:py]];
                }
                else if (newCheck & TOP)
                {
                    if (rightPoint.x - bounds.origin.x + newPoint.x - bounds.origin.x < bounds.size.width)
                    {
                        px = bounds.origin.x;
                    }
                    else
                    {
                        px = bounds.origin.x + bounds.size.width;
                    }
                    [thePoints addObject:[[ASPoint alloc] initWithX:px y:py]];
                    [thePoints addObject:[[ASPoint alloc] initWithX:px y:bounds.origin.y]];
                }
            }
        }
        if (closingUp)
        {
            return;
        }
        [thePoints addObject:newPoint];
    }
    
    
    ASPoint *newRightPoint = [[newEdge clippedEnds] objectForKey:[[ASLR other:newOrientation] name]];
    if (![ASSite closeEnough:[thePoints objectAtIndex:0] andPoint:newRightPoint]) {
        [thePoints addObject:newRightPoint];
    }

}





@end
