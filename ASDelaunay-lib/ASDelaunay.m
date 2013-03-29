//
//  Voronoi.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/11/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASDelaunay.h"

@implementation ASDelaunay

@synthesize edges, sites, sitesIndexedByLocation, triangles, plotBounds;

- (id)initWithPoints:(NSArray *)somePoints plotBounds:(CGRect)theBounds {
    
    if ( (self = [super init]) ) {
        self.sites = [[ASSiteList alloc] init];
        self.sitesIndexedByLocation = [NSMutableDictionary dictionary];
        [self addSites:somePoints];
        plotBounds = theBounds;
        self.triangles = [NSMutableArray array];
        self.edges = [NSMutableArray array];
        [self fortunesAlgorithm];
    }
    return self;
}

- (void)addSites:(NSArray *)points {
    for (NSInteger i = 0; i < [points count]; ++i) {
        [self addSite:[points objectAtIndex:i] index:i];
    }
}

- (void)addSite:(ASPoint *)aPoint index:(NSInteger)index {
    double weight = arc4random();
    ASSite *site = [ASSite createWithPoint:aPoint index:index weight:weight];
    [self.sites push:site];
    [self.sitesIndexedByLocation setObject:site forKey:aPoint];
}

- (NSMutableArray *)region:(ASPoint *)p {
    id site = [self.sitesIndexedByLocation objectForKey:p];
    if (site == [NSNull null]) {
        return [NSMutableArray array];
    }
    return [(ASSite *)site region:self.plotBounds];
}

- (NSMutableArray *)regions {
    return [self.sites regions:self.plotBounds];
}


- (void)fortunesAlgorithm {
    ASSite *newSite = nil; ASSite *bottomSite = nil; ASSite *topSite = nil; ASSite *tempSite = nil;
    ASVertex *v = nil; ASVertex *vertex = nil;
    ASPoint *newIntStar = nil;
    ASLR *leftRight = nil;
    ASHalfEdge *lbnd = nil; ASHalfEdge *rbnd = nil; ASHalfEdge *llbnd = nil; ASHalfEdge *rrbnd = nil; ASHalfEdge *bisector = nil;
    ASEdge *edge = nil;
    
    
    CGRect dataBounds = [self.sites getSitesBounds];
 
    double sqrt_nsites = sqrt([self.sites length] + 4.0);
    ASHalfedgePriorityQueue *heap = [[ASHalfedgePriorityQueue alloc] initWithYMin:dataBounds.origin.y deltay:dataBounds.size.height sqrtNSites:sqrt_nsites];
    ASEdgeList *edgeList = [[ASEdgeList alloc] initWithXMin:dataBounds.origin.x deltax:dataBounds.size.width sqrtNSites:sqrt_nsites];
    NSMutableArray *halfEdges = [NSMutableArray array];
    NSMutableArray *vertices = [NSMutableArray array];
    
    ASSite *bottomMostSite = [self.sites next];
    newSite = [self.sites next];
    
    void (^leftRegion)(ASHalfEdge *, ASSite **) = ^(ASHalfEdge *he, ASSite **site) {
        ASEdge *edge = he.edge;
        
        if (edge == nil) {
            *site = bottomMostSite;
            return;
        }
        
        *site = [edge site:he.leftRight];
    };
    
    void (^rightRegion)(ASHalfEdge *, ASSite **) = ^(ASHalfEdge *he, ASSite **site) {
        ASEdge *edge = he.edge;
        
        if (edge == nil) {
            *site = bottomMostSite;
            return;
        }
        *site = [edge site:[ASLR other:he.leftRight]];
    };
    
    for (;;) {
        
        if ( ![heap empty] ) {
            newIntStar = [heap min];
        }
        
        if (newSite != nil && ([heap empty] || [ASDelaunay compareByYThenX:newSite site2:newIntStar] < 0)) {
            
            // START
            NSLog(@"TESTING");
            /* new site is smallest */
            //trace("smallest: new site " + newSite);
            
            // Step 8:
            lbnd = [edgeList edgeListLeftNeighbor:[newSite coord]]; // the Halfedge just to the left of newSite
            rbnd = lbnd.edgeListRightNeighbor;  // the Halfedge just to the right

            rightRegion(lbnd, &bottomSite); // this is the same as leftRegion(rbnd)
            // this Site determines the region containing the new site
            // Step 9:
            edge = [ASEdge createBisectingEdge:bottomSite site1:newSite];

            [self.edges addObject:edge];
            
            bisector = [[ASHalfEdge alloc] initWithEdge:edge lr:[ASLR LEFT]];
            [halfEdges addObject:bisector];
            
            // inserting two Halfedges into edgeList constitutes Step 10:
            // insert bisector to the right of lbnd:
            [edgeList insert:lbnd newHalfEdge:bisector];
            
            // first half of Step 11:
            if ( (vertex = [ASVertex intersect:lbnd halfEdge1:bisector]) != nil ) {
                [vertices addObject:vertex];
                [heap remove:lbnd];
                lbnd.vertex = vertex;
                lbnd.ystar = [vertex getY] + [newSite distance:vertex];
                [heap insert:lbnd];
            }
            
            lbnd = bisector;
            bisector = [[ASHalfEdge alloc] initWithEdge:edge lr:[ASLR RIGHT]];
            [halfEdges addObject:bisector];

            // second Halfedge for Step 10:
            // insert bisector to the right of lbnd:
            [edgeList insert:lbnd newHalfEdge:bisector];
            
            // second half of Step 11:
            if ( (vertex = [ASVertex intersect:bisector halfEdge1:rbnd]) != nil ) {
                [vertices addObject:vertex];
                bisector.vertex = vertex;
                bisector.ystar = [vertex getY] + [newSite distance:vertex];
                [heap insert:bisector];
            }
            
            newSite = [self.sites next];
            
        } else if ([heap empty] == NO)
        {
            // intersection is smallest //
            lbnd = [heap extraMin];
            llbnd = lbnd.edgeListLeftNeighbor;
            rbnd = lbnd.edgeListRightNeighbor;
            rrbnd = rbnd.edgeListRightNeighbor;
            leftRegion(lbnd, &bottomSite);
            rightRegion(rbnd, &topSite);

            // these three sites define a Delaunay triangle
            // (not actually using these for anything...)
            //_triangles.push(new Triangle(bottomSite, topSite, rightRegion(lbnd)));
            
            v = lbnd.vertex;
            [v setIndex];
            [lbnd.edge setVertex:lbnd.leftRight vertex:v];
            [rbnd.edge setVertex:rbnd.leftRight vertex:v];
            [edgeList remove:lbnd];
            [heap remove:rbnd];
            [edgeList remove:rbnd];
            leftRight = [ASLR LEFT];
            
         
            if ([bottomSite getY] > [topSite getY]) {
                tempSite = bottomSite; bottomSite = topSite; topSite = tempSite; leftRight = [ASLR RIGHT];
            }
            
            edge = [ASEdge createBisectingEdge:bottomSite site1:topSite];
            [self.edges addObject:edge];
            bisector = [[ASHalfEdge alloc] initWithEdge:edge lr:leftRight];
            
            [halfEdges addObject:bisector];
         
            [edgeList insert:llbnd newHalfEdge:bisector];
            [edge setVertex:[ASLR other:leftRight] vertex:v];
            
         
            
            if ( (vertex = [ASVertex intersect:llbnd halfEdge1:bisector]) != nil ) {
                [vertices addObject:vertex];
                [heap remove:llbnd];
                llbnd.vertex = vertex;
                llbnd.ystar = [vertex getY] + [bottomSite distance:vertex];
                [heap insert:llbnd];
            }
            
         
            if ( (vertex = [ASVertex intersect:bisector halfEdge1:rrbnd]) != nil ) {
                [vertices addObject:vertices];
                bisector.vertex = vertex;
                bisector.ystar = [vertex getY] + [bottomSite distance:vertex];
                [heap insert:bisector];
            }
        }
        else {
            break;
        }
    }
    
    // end for loop
    
    // heap should be empty now

    heap = nil;
    edgeList = nil;
    halfEdges = nil;
    for (ASEdge *edge in self.edges) {
        [edge clipVertices:self.plotBounds];
    }
    
    vertices = nil;
    


}

//
+ (NSComparisonResult)compareByYThenX:(ASSite *)s1 site2:(id)s2 {
    if (s1.getY < [s2 getY]) return NSOrderedAscending;
    if (s1.getY > [s2 getY]) return NSOrderedDescending;
    if (s1.getX < [s2 getX]) return NSOrderedAscending;
    if (s1.getX > [s2 getX]) return NSOrderedDescending;
    return NSOrderedSame;
}


@end
