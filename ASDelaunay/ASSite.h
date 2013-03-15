//
//  ASSite.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASPoint.h"

@class ASEdge;

@interface ASSite : NSObject <ICoord>

+ (id)createWithPoint:(ASPoint *)aPoint index:(NSUInteger)anIndex weight:(double)aWeight;
- (double)getX;
- (double)getY;
- (double)distance:(id<ICoord>)aCoord;
+ (BOOL)closeEnough:(ASPoint *)p0 andPoint:(ASPoint *)p1;
+ (void)sortSites:(NSMutableArray *)someSites;
- (void)addEdge:(ASEdge *)anEdge;
- (ASEdge *)nearestEdge;
- (void)move:(ASPoint *)aPoint;
- (NSMutableArray *)getEdges;


@end
