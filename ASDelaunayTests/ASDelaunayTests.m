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

@interface ASDelaunayTests()

@property (nonatomic, strong) ASPoint *point0;
@property (nonatomic, strong) ASPoint *point1;
@property (nonatomic, strong) ASPoint *point2;
@property (nonatomic, strong) ASVoronoi *voronoi;
@property (nonatomic, copy) NSArray *points;
@property (nonatomic) CGRect plotBounds;

@end

@implementation ASDelaunayTests

@synthesize point0, point1, point2, voronoi, points, plotBounds;

- (void)setUp
{
    [super setUp];
    
    self.point0 = [[ASPoint alloc] initWithX:-10 y:0];
    self.point1 = [[ASPoint alloc] initWithX:10 y:0];
    self.point2 = [[ASPoint alloc] initWithX:0 y:10];
    self.points = @[self.point0, self.point1, self.point2];
    
    self.plotBounds = CGRectMake(-20, -20, 40, 40);
    self.voronoi = [[ASVoronoi alloc] initWithPoints:[NSMutableArray arrayWithArray:self.points] plotBounds:self.plotBounds];
}

- (void)tearDown
{
    self.voronoi = nil;
    self.plotBounds = CGRectZero;
    self.points = nil;
    self.point0 = self.point1 = self.point2 = nil;
    
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
    
    ASVoronoi *voronoiInner = [[ASVoronoi alloc] initWithPoints:randomPoints plotBounds:CGRectMake(0, 0, 768, 1024)];
    
    STAssertNotNil(voronoiInner.edges, @"Edges cannot be nil after this!");
}

- (void)testRegionsHaveNoDuplicatedPoints {
    for (NSMutableArray *region in [self.voronoi regions]) {
        NSLog(@"Region: %@", region);
        NSMutableArray *sortedRegion = [region copy];
        [sortedRegion sortUsingSelector:@selector(compare:)];
        for (NSInteger i = 1; i < [sortedRegion count]; ++i) {
            STAssertFalse([[sortedRegion objectAtIndex:i] isEqual:[sortedRegion objectAtIndex:i - 1]], @"They should not be equal!");
        }
    }
}


- (NSComparisonResult)compareYThenX:(ASPoint *)p0 p1:(ASPoint *)p1 {
    if (p0.y < p1.y) return NSOrderedAscending;
    if (p0.y > p1.y) return NSOrderedDescending;
    if (p0.x < p1.x) return NSOrderedAscending;
    if (p0.x > p1.x) return NSOrderedDescending;
    return NSOrderedSame;
}



@end
