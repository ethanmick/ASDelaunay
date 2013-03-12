//
//  Voronoi.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/11/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASSite;

@interface ASVoronoi : NSObject

+ (NSComparisonResult)compareByYThenX:(ASSite *)s1 site2:(id)s2;

@end
