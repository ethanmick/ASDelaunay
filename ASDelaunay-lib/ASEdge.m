//
//  ASEdge.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASEdge.h"
#import "ASPoint.h"
#import "ASSite.h"
#import "ASLR.h"
#import "ASVertex.h"
#import "ASLineSegment.h"

@interface ASEdge()

//@property (nonatomic, strong) NSMutableArray *pool;
@property (nonatomic, strong) NSMutableDictionary *sites;
@property (nonatomic, strong) NSMutableDictionary *clippedVertices;
@property (nonatomic) NSInteger edgeIndex;

@end

static NSInteger nedges = 0;

@implementation ASEdge

- (id)init {
    if ( (self = [super init]) ) {
        self.sites = [NSMutableDictionary dictionary];
        self.edgeIndex = nedges++;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[self class]] && [self.leftVertex isEqual:[object leftVertex]] && [self.rightVertex isEqual:[object rightVertex]];
}

- (NSComparisonResult)compareSiteDistance:(ASEdge *)object {
    return -[self compareSiteDistanceMAX:object];
}


- (NSComparisonResult)compareSiteDistanceMAX:(ASEdge *)object {
    double length0 = [self sitesDistance];
    double length1 = [object sitesDistance];
    if (length0 < length1) return NSOrderedDescending;
    if (length0 > length1) return NSOrderedAscending;
    return NSOrderedSame;
}

- (double)sitesDistance {
    return [ASPoint distanceBetweenPoint0:[[self leftSite] coord] andPoint1:[[self rightSite] coord]];
}

- (void)setLeftSite:(ASSite *)s {
    if (s == nil) {
        [self.sites setObject:[NSNull null] forKey:[[ASLR LEFT] name]];
        return;
    }
    [self.sites setObject:s forKey:[[ASLR LEFT] name]];
}

- (ASSite *)leftSite {
    id toReturn = [self.sites objectForKey:[[ASLR LEFT] name]];
    if (toReturn == [NSNull null]) {
        return nil;
    }
    return toReturn;
}

- (void)setRightSite:(ASSite *)s {
    if (s == nil) {
        [self.sites setObject:[NSNull null] forKey:[[ASLR RIGHT] name]];
        return;
    }
    [self.sites setObject:s forKey:[[ASLR RIGHT] name]];
}

- (ASSite *)rightSite {
    id toReturn = [self.sites objectForKey:[[ASLR RIGHT] name]];
    if (toReturn == [NSNull null]) {
        return nil;
    }
    return toReturn;
}

- (ASSite *)site:(ASLR *)leftRight {
    id toReturn = [self.sites objectForKey:[leftRight name]];
    if (toReturn == [NSNull null]) {
        return nil;
    }
    return toReturn;
}

- (ASVertex *)vertex:(ASLR *)leftRight {
    return leftRight == [ASLR LEFT] ? self.leftVertex : self.rightVertex;
}

- (void)setVertex:(ASLR *)leftRight vertex:(ASVertex *)v {
    if (leftRight == [ASLR LEFT]) {
        self.leftVertex = v;
    } else {
        self.rightVertex = v;
    }
}

- (BOOL)isPartOfConvexHull {
    return self.leftVertex == nil || self.rightVertex == nil;
}

- (ASLineSegment *)delaunayLine {
    return [[ASLineSegment alloc] initWithPoint0:[self.leftSite coord] point1:[self.rightSite coord]];
}

- (NSMutableDictionary *)clippedEnds {
    return self.clippedVertices;
}

- (BOOL)visible {
    return self.clippedVertices != nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Edge: %d; sites: %@ <--> %@; endVertices: Index: %d, Index: %d",
            self.edgeIndex, [self.sites objectForKey:[[ASLR LEFT] name]], [self.sites objectForKey:[[ASLR RIGHT] name]],
            self.leftVertex ? [self.leftVertex vertexIndex] : 0,
            self.rightVertex ? [self.rightVertex vertexIndex] : 0];
}

- (ASLineSegment *)voronoiEdge {
    return [[ASLineSegment alloc] initWithPoint0:[self.clippedVertices objectForKey:[[ASLR LEFT] name]] point1:[self.clippedVertices objectForKey:[[ASLR RIGHT] name]]];
}

static ASEdge *delete = nil;

+ (ASEdge *)DELETED {
    if (!delete) {
        delete = [[ASEdge alloc] init];
    }
    return delete;
}

+ (ASEdge *)createBisectingEdge:(ASSite *)site0 site1:(ASSite *)site1 {
    double dx; double dy; double absdx; double absdy;
    double a; double b; double c;
    
    dx = [site1 getX] - [site0 getX];
    dy = [site1 getY] - [site0 getY];
    absdx = fabs(dx);
    absdy = fabs(dy);
    c = [site0 getX] * dx + [site0 getY] * dy + (dx * dx + dy * dy) * 0.5;
    if (absdx > absdy) {
        a = 1.0; b = dy/dx; c /= dx;
    } else {
        b = 1.0; a = dx/dy; c /= dy;
    }
    
    ASEdge *edge = [[ASEdge alloc] init];
    [edge setLeftSite:site0];
    [edge setRightSite:site1];
    [site0 addEdge:edge];
    [site1 addEdge:edge];
    [edge setLeftVertex:nil];
    [edge setRightVertex:nil];
    
    edge.a = a;
    edge.b = b;
    edge.c = c;
    
    return edge;
}

- (void)clipVertices:(CGRect)bounds {
    double xmin = bounds.origin.x;
    double ymin = bounds.origin.y;
    double xmax = bounds.origin.x + bounds.size.width;
    double ymax = bounds.origin.y + bounds.size.height;
    
    ASVertex *vertex0; ASVertex *vertex1;
    double x0; double x1; double y0; double y1;
    
    if (self.a == 1.0 && self.b >= 0.0) {
        vertex0 = self.rightVertex;
        vertex1 = self.leftVertex;
    } else {
        vertex0 = self.leftVertex;
        vertex1 = self.rightVertex;
    }

    if (self.a == 1.0) {
        y0 = ymin;
        if (vertex0 != nil && [vertex0 getY] > ymin) {
            y0 = [vertex0 getY];
        }
        if (y0 > ymax) {
            return;
        }
        x0 = self.c - self.b * y0;
        y1 = ymax;
        if (vertex1 != nil && [vertex1 getY] < ymax) {
            y1 = [vertex1 getY];
        }
        if (y1 < ymin) {
            return;
        }
        x1 = self.c - self.b * y1;
        
        if ( (x0 > xmax && x1 > xmax) || (x0 < xmin && x1 < xmin)) {
            return;
        }
        
        if (x0 > xmax) {
            x0 = xmax; y0 = (self.c - x0) / self.b;
        } else if ( x0 < xmin) {
            x0 = xmin; y0 = (self.c - x0) / self.b;
        }
        
        if (x1 > xmax) {
            x1 = xmax; y1 = (self.c - x1) / self.b;
        } else if (x1 < xmin) {
            x1 = xmin; y1 = (self.c - x1) / self.b;
        }
    } else {
        x0 = xmin;
        if (vertex0 != nil && [vertex0 getX] > xmin)
        {
            x0 = [vertex0 getX];
        }
        if (x0 > xmax)
        {
            return;
        }
        y0 = self.c - self.a * x0;
        
        x1 = xmax;
        if (vertex1 != nil && [vertex1 getX] < xmax)
        {
            x1 = [vertex1 getX];
        }
        if (x1 < xmin)
        {
            return;
        }
        y1 = self.c - self.a * x1;
        
        if ((y0 > ymax && y1 > ymax) || (y0 < ymin && y1 < ymin))
        {
            return;
        }
        
        if (y0 > ymax)
        {
            y0 = ymax; x0 = (self.c - y0) / self.a;
        }
        else if (y0 < ymin)
        {
            y0 = ymin; x0 = (self.c - y0) / self.a;
        }
        
        if (y1 > ymax)
        {
            y1 = ymax; x1 = (self.c - y1) / self.a;
        }
        else if (y1 < ymin)
        {
            y1 = ymin; x1 = (self.c - y1) / self.a;
        }
    }
    
    self.clippedVertices = [NSMutableDictionary dictionary];
    
    if (vertex0 == self.leftVertex) {
        [self.clippedVertices setObject:[[ASPoint alloc] initWithX:x0 y:y0] forKey:[[ASLR LEFT] name]];
        [self.clippedVertices setObject:[[ASPoint alloc] initWithX:x1 y:y1] forKey:[[ASLR RIGHT] name]];
    } else {
        [self.clippedVertices setObject:[[ASPoint alloc] initWithX:x0 y:y0] forKey:[[ASLR RIGHT] name]];
        [self.clippedVertices setObject:[[ASPoint alloc] initWithX:x1 y:y1] forKey:[[ASLR LEFT] name]];
    }
    
}





@end
