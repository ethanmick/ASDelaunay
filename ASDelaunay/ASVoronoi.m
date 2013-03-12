//
//  Voronoi.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/11/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASVoronoi.h"
#import "ASSite.h"

@implementation ASVoronoi


+ (NSComparisonResult)compareByYThenX:(ASSite *)s1 site2:(id)s2 {
    if (s1.getY < [s2 getY]) return NSOrderedAscending;
    if (s1.getY > [s2 getY]) return NSOrderedDescending;
    if (s1.getX < [s2 getX]) return NSOrderedAscending;
    if (s1.getX > [s2 getX]) return NSOrderedDescending;
    return NSOrderedSame;
}


@end
