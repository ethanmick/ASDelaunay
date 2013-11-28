//
//  ASSiteList.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/13/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASSiteList.h"
#import "ASSite.h"
#import "ASEdge.h"
#import "ASCircle.h"

@interface ASSiteList()

@property (nonatomic, strong) NSMutableArray *sites;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic) BOOL sorted;

@end

@implementation ASSiteList

- (id)init {
    
    if ( (self = [super init]) ) {
        self.sites = [NSMutableArray array];
        self.sorted = NO;
    }
    return self;
}

- (NSUInteger)push:(ASSite *)aSite {
    self.sorted = NO;
    [self.sites addObject:aSite];
    return [self.sites count];
}

- (NSUInteger)length {
    return [self.sites count];
}

- (ASSite *)next {
    if (!self.sorted) {
        [NSException raise:@"Not Sorted Exception" format:@"ASSiteList - Next : Sites not sorted!"];
    }
    
    if (self.currentIndex < [self.sites count]) {
        return [self.sites objectAtIndex:self.currentIndex++];
    } else {
        return nil;
    }
}

- (CGRect)getSitesBounds {
    if (!self.sorted) {
        [ASSite sortSites:self.sites];
        self.currentIndex = 0;
        self.sorted = YES;
    }
    
    double xmin = 0; double xmax = 0; double ymin = 0; double ymax = 0;
    
    if ([self.sites count] == 0) {
        return CGRectMake(0, 0, 0, 0);
    }
    
    xmin = NSIntegerMax;
    xmax = NSIntegerMin;
    
    for (ASSite *site in self.sites) {
        if ([site getX] < xmin) {
            xmin = [site getX];
        }
        
        if ([site getX] > xmax) {
            xmax = [site getX];
        }
    }
    
    ymin = [[_sites objectAtIndex:0] getY];
    ymax = [[_sites lastObject] getY];
    
    return CGRectMake(xmin, ymin, xmax - xmin, ymax - ymin);
}

- (NSMutableArray *)siteCoords {
    NSMutableArray *coords = [NSMutableArray array];
    for (ASSite *site in self.sites) {
        [coords addObject:[site coord]];
    }
    return coords;
}

- (NSMutableArray *)circles {
    NSMutableArray *cirlces = [NSMutableArray array];
    
    for (ASSite *site in self.sites) {
        double radius = 0;
        ASEdge *nearestEdge = [site nearestEdge];
        if (![nearestEdge isPartOfConvexHull]) {
            radius = [nearestEdge sitesDistance] * 0.5;
        }
        [cirlces addObject:[[ASCircle alloc] initWithX:[site getX] y:[site getY] radius:radius]];
    }
    return cirlces;
}

- (NSMutableArray *)regions:(CGRect)plotBounds {
    NSMutableArray *regions = [NSMutableArray array];
    for (ASSite *site in self.sites) {
        [regions addObject:[site region:plotBounds]];
    }
    return regions;
}


@end