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

@interface ASEdge()

//@property (nonatomic, strong) NSMutableArray *pool;
@property (nonatomic, strong) NSMutableDictionary *sites;

@end

@implementation ASEdge

//@synthesize pool;
@synthesize sites;

- (id)init {
    if ( (self = [super init]) ) {
        self.sites = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSComparisonResult)compareSiteDistance:(ASEdge *)object {
    return -[self compareSiteDistanceMAX:object];
}


- (NSComparisonResult)compareSiteDistanceMAX:(ASEdge *)object {
    CGFloat length0 = [self sitesDistance];
    CGFloat length1 = [object sitesDistance];
    if (length0 < length1) return NSOrderedDescending;
    if (length0 > length1) return NSOrderedAscending;
    return NSOrderedSame;
}

- (CGFloat)sitesDistance {
    return [ASPoint distanceBetweenPoint0:[[self leftSite] coord] andPoint1:[[self rightSite] coord]];
}

- (void)setLeftSite:(ASSite *)s {
    [self.sites setObject:s forKey:[ASLR LEFT]];
}

- (ASSite *)leftSite {
    return [self.sites objectForKey:[ASLR LEFT]];
}

- (void)setRightSite:(ASSite *)s {
    [self.sites setObject:s forKey:[ASLR RIGHT]];
}

- (ASSite *)rightSite {
    return [self.sites objectForKey:[ASLR RIGHT]];
}

- (ASSite *)site:(ASLR *)leftRight {
    return [self.sites objectForKey:leftRight];
}




@end
