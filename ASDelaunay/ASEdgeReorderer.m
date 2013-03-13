//
//  ASEdgeReorderer.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/11/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASEdgeReorderer.h"
#import "ASSite.h"
#import "ASVertex.h"
#import "ASLR.h"
#import "ASEdge.h"

@interface ASEdgeReorderer()

@end

@implementation ASEdgeReorderer

@synthesize edges, edgeOrientations;

- (id)initWithEdges:(NSMutableArray *)origEdges criterion:(Class)criterion {
    
    if ( (self = [super init]) ) {
        if ([ASSite class] != criterion || [ASVertex class] != criterion) {
            [NSException raise:@"Bad Arguement Exception" format:@"Criterion must either be ASSite or ASVertex!"];
        }
        
        edges = [NSMutableArray array];
        edgeOrientations = [NSMutableArray array];
    
    if ([origEdges count] > 0) {
        edges = [self reorderEdges:origEdges criterion:criterion];
    }
    
    
    
    }
    return self;
}

- (NSMutableArray *)reorderEdges:(NSMutableArray *)origEdges criterion:(Class)criterion {
    NSInteger i = 0;
    NSInteger n = [origEdges count];
    NSMutableArray *done = [NSMutableArray arrayWithCapacity:n];
    for (NSInteger forgetMe = 0 ; forgetMe < n; forgetMe++) {
        [done addObject:@NO];
    }
    NSInteger nDone = 0;
    NSMutableArray *newEdges = [NSMutableArray array];
    ASEdge *edge = [origEdges objectAtIndex:i];
    
    
    [newEdges addObject:edge];
    [edgeOrientations addObject:[ASLR LEFT]];
    id<ICoord> firstPoint = (criterion == [ASVertex class]) ? [edge leftVertex] : [edge leftSite];
    id<ICoord> lastPoint = (criterion == [ASVertex class]) ? [edge rightVertex] : [edge rightSite];
    
    if (firstPoint == [ASVertex VERTEX_AT_INFINITY] || lastPoint == [ASVertex VERTEX_AT_INFINITY]) {
        return [NSMutableArray array];
    }
    
    [done setObject:@YES atIndexedSubscript:i];
    ++nDone;
    
    while (nDone < n) {
        for (i = 1; i < n; ++i) {
            if ([done objectAtIndex:i]) {
                continue;
            }
            
            edge = [origEdges objectAtIndex:i];
            
            id<ICoord>leftPoint = criterion == [ASVertex class] ? [edge leftVertex] : [edge leftSite];
            id<ICoord>rightPoint = criterion == [ASVertex class] ? [edge rightVertex] : [edge rightSite];
            
            if (leftPoint == [ASVertex VERTEX_AT_INFINITY] || rightPoint == [ASVertex VERTEX_AT_INFINITY]) {
                return [NSMutableArray array];
            }
            
            if ([leftPoint isEqual:lastPoint]) {
                lastPoint = rightPoint;
                [self.edgeOrientations addObject:[ASLR LEFT]];
                [newEdges addObject:edge];
                [done setObject:@YES atIndexedSubscript:i];
            } else if ( [rightPoint isEqual:firstPoint]) {
                firstPoint = leftPoint;
                [self.edgeOrientations insertObject:[ASLR LEFT] atIndex:0];
                [newEdges insertObject:edge atIndex:0];
                [done setObject:@YES atIndexedSubscript:i];
            } else if ([leftPoint isEqual:firstPoint]) {
                firstPoint = rightPoint;
                [self.edgeOrientations insertObject:[ASLR RIGHT] atIndex:0];
                [newEdges insertObject:edge atIndex:0];
                [done setObject:@YES atIndexedSubscript:i];
            } else if ([lastPoint isEqual:lastPoint]) {
                lastPoint = leftPoint;
                [self.edgeOrientations addObject:[ASLR RIGHT]];
                [newEdges addObject:edge];
                [done setObject:@YES atIndexedSubscript:i];
            }
            
            if ([done objectAtIndex:i]) {
                ++nDone;
            }
        }
    }
    return newEdges;

}



@end
