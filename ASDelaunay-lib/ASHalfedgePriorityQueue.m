//
//  ASHalfedgePriorityQueue.m
//  ASDelaunay
//
//  Created by Ethan Mick on 3/14/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASHalfedgePriorityQueue.h"
#import "ASHalfEdge.h"
#import "ASVertex.h"

@interface ASHalfedgePriorityQueue()

@property (nonatomic, strong) NSMutableArray *hash;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger minBucket;
@property (nonatomic) NSInteger hashSize;
@property (nonatomic) double ymin;
@property (nonatomic) double deltay;

@end

@implementation ASHalfedgePriorityQueue

@synthesize hash, count, minBucket, hashSize, ymin, deltay;

- (id)initWithYMin:(double)aYmin deltay:(double)aDeltay sqrtNSites:(NSInteger)sqrtNSites {
    
    if ( (self = [super init]) ) {
        self.ymin = aYmin;
        self.deltay = aDeltay;
        self.hashSize = 4 * sqrtNSites;
        [self initializeObject];
    }
    return self;
}

- (void)initializeObject {
    NSInteger i;
    self.count = 0;
    self.minBucket = 0;
    self.hash = [NSMutableArray arrayWithCapacity:self.hashSize];
    
    for (i = 0; i < self.hashSize; ++i) {
        ASHalfEdge *edge = [ASHalfEdge createDummy];
        edge.nextInPriorityQueue = nil;
        [self.hash addObject:edge];
    }
}

- (NSInteger)bucket:(ASHalfEdge *)halfEdge {
    NSInteger theBucket = (halfEdge.ystar - self.ymin) / self.deltay * self.hashSize;
    if (theBucket < 0) theBucket = 0;
    if (theBucket >= self.hashSize) theBucket = self.hashSize - 1;
    return theBucket;
}

- (BOOL)isEmpty:(NSInteger)bucket {
    return [[self.hash objectAtIndex:bucket] nextInPriorityQueue] == nil;
}


- (void)insert:(ASHalfEdge *)halfEdge {
    ASHalfEdge *previous; ASHalfEdge *next;
    
    NSInteger insertionBucket = [self bucket:halfEdge];
    if (insertionBucket < self.minBucket) {
        self.minBucket = insertionBucket;
    }
    
    previous = [self.hash objectAtIndex:insertionBucket];
    while ( (next = previous.nextInPriorityQueue) != nil && (halfEdge.ystar > next.ystar || (halfEdge.ystar == next.ystar && [halfEdge.vertex getX] > [next.vertex getX]))) {
        previous = next;
    }
    
    halfEdge.nextInPriorityQueue = previous.nextInPriorityQueue;
    previous.nextInPriorityQueue = halfEdge;
    ++self.count;
}

- (void)remove:(ASHalfEdge *)halfEdge {
    ASHalfEdge *previous;
    NSInteger removalBucket = [self bucket:halfEdge];
    
    if (halfEdge.vertex != nil) {
        previous = [self.hash objectAtIndex:removalBucket];
        while (previous.nextInPriorityQueue != halfEdge) {
            previous = previous.nextInPriorityQueue;
        }
        
        previous.nextInPriorityQueue = halfEdge.nextInPriorityQueue;
        self.count--;
        halfEdge.vertex = nil;
        halfEdge.nextInPriorityQueue = nil;
        halfEdge = nil;
    }
}

- (BOOL)empty {
    return self.count == 0;
}

- (ASPoint *)min {
    [self adjustMinBucket];
    ASHalfEdge *answer = [[self.hash objectAtIndex:self.minBucket] nextInPriorityQueue];
    return [[ASPoint alloc] initWithX:[answer.vertex getX] y:answer.ystar];
}

- (void)adjustMinBucket {
    while (self.minBucket < self.hashSize - 1 && [self isEmpty:self.minBucket]) {
        ++self.minBucket;
    }
}

- (ASHalfEdge *)extractMin {
    ASHalfEdge *answer = [[self.hash objectAtIndex:self.minBucket] nextInPriorityQueue];
    [[self.hash objectAtIndex:self.minBucket] setNextInPriorityQueue:answer.nextInPriorityQueue];
    
    self.count--;
    answer.nextInPriorityQueue = nil;
    return answer;
}



@end
