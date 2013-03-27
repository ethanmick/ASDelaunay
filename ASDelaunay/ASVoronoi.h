//
//  Voronoi.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/11/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASSite;
@class ASSiteList;
@class ASPoint;

@interface ASVoronoi : NSObject

@property (nonatomic, strong) ASSiteList *sites;
@property (nonatomic, strong) NSMutableDictionary *sitesIndexedByLocation;
@property (nonatomic, strong) NSMutableArray *triangles;
@property (nonatomic, strong) NSMutableArray *edges;
@property (nonatomic, readonly) CGRect plotBounds; //may need to make custom rectangle class...

+ (NSComparisonResult)compareByYThenX:(ASSite *)s1 site2:(id)s2;
- (id)initWithPoints:(NSArray *)somePoints plotBounds:(CGRect)theBounds;
- (NSMutableArray *)region:(ASPoint *)p;
- (NSMutableArray *)regions;

@end
