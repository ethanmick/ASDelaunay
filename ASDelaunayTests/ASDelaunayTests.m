//
//  ASDelaunayTests.m
//  ASDelaunayTests
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import "ASDelaunayTests.h"
#import "ASVoronoi.h"
#import "ASPoint.h"

@implementation ASDelaunayTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample {
    
    NSMutableArray *randomPoints = [NSMutableArray array];
    
    for (int i = 0; i < 2000; i++) {
        float x = 10 + (arc4random() % ((int)768 - 10*2));
        float y = 10 + (arc4random() % ((int)900 - 10*2));
        ASPoint *point = [[ASPoint alloc] initWithX:x y:y];
        [randomPoints addObject:point];
    }
    
    ASVoronoi *voronoi = [[ASVoronoi alloc] initWithPoints:randomPoints plotBounds:CGRectMake(0, 0, 768, 1024)];
    
    STAssertNotNil(voronoi.edges, @"Edges cannot be nil after this!");
}

@end
