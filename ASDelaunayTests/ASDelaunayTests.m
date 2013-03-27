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
#import "ASEdge.h"
#import "ASLineSegment.h"

#define EPSILON 0.01

@interface ASDelaunayTests()


- (BOOL)isCloseEnough:(double)d0 d1:(double)d1;

@end

@implementation ASDelaunayTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testASmallNumberOfPoints {
    ASPoint *p0 = [[ASPoint alloc] initWithX:-10 y:0];
    ASPoint *p1 = [[ASPoint alloc] initWithX:10 y:0];
    ASPoint *p2 = [[ASPoint alloc] initWithX:0 y:10];
    NSArray *pos = @[p0, p1, p2];
    
    CGRect pb = CGRectMake(-20, -20, 40, 40);
    ASVoronoi *vo = [[ASVoronoi alloc] initWithPoints:[NSMutableArray arrayWithArray:pos] plotBounds:pb];
    
    STAssertTrue([vo.edges count] == 3, @"The Number of Line Segments should be 3");
    STAssertTrue([[[vo.edges[0] voronoiEdge] p0] x] == 0, @"X Should be 0");
    STAssertTrue([[[vo.edges[0] voronoiEdge] p0] y] == 0, @"X Should be 0");
    STAssertTrue([[[vo.edges[0] voronoiEdge] p1] x] == 0, @"X Should be 0");
    STAssertTrue([[[vo.edges[0] voronoiEdge] p1] y] == -20, @"X Should be -20");
    
    STAssertTrue([[[vo.edges[1] voronoiEdge] p0] x] == -20, @"X Should be -20");
    STAssertTrue([[[vo.edges[1] voronoiEdge] p0] y] == 20, @"X Should be 20");
    STAssertTrue([[[vo.edges[1] voronoiEdge] p1] x] == 0, @"X Should be 0");
    STAssertTrue([[[vo.edges[1] voronoiEdge] p1] y] == 0, @"X Should be 0");
    
    STAssertTrue([[[vo.edges[2] voronoiEdge] p0] x] == 0, @"X Should be 0");
    STAssertTrue([[[vo.edges[2] voronoiEdge] p0] y] == 0, @"X Should be 0");
    STAssertTrue([[[vo.edges[2] voronoiEdge] p1] x] == 20, @"X Should be 20");
    STAssertTrue([[[vo.edges[2] voronoiEdge] p1] y] == 20, @"X Should be 20");

}

- (void)testJSON0 {
    [self testForFile:0];
}

- (void)testJSON1 {
    [self testForFile:1];
}

- (void)testJSON2 {
    [self testForFile:2];
}

- (void)testJSON3 {
    [self testForFile:3];
}

///
/// This crashed on the original library, so this test ensures it completes here.
/// Of course, since it crashed we can't verify that this is correct...
///
- (void)testJSON4 {
    ASVoronoi *voro = [[ASVoronoi alloc] initWithPoints:[[self arrayOfPointsFromJSONFile:4] mutableCopy] plotBounds:CGRectMake(0, 0, 500, 500)];
    STAssertTrue([voro.edges count] > 0, @"Did we put something in the edges array?");
}


- (void)testJSON5 {
    [self testForFile:5];
}

- (void)testForFile:(NSInteger)integer {
    ASVoronoi *voro = [[ASVoronoi alloc] initWithPoints:[[self arrayOfPointsFromJSONFile:integer] mutableCopy] plotBounds:CGRectMake(0, 0, 500, 500)];
    
    ///
    /// Read in input and test to see if it's "close enough"
    ///
    NSArray *outputs = [self arrayFromJSONFileNamed:[NSString stringWithFormat:@"output-%d", integer]];
    
    STAssertTrue([outputs count] == [voro.edges count], @"The number of line segments should be equal.");
    
    for (NSInteger i = 0; i < [voro.edges count]; i++) {
        ASLineSegment *segment = [voro.edges[i] voronoiEdge];
        
        if ([segment p0] == nil) {
            
            STAssertTrue([segment p0] == ((outputs[i][@"p0"] == [NSNull null]) ? nil : outputs[i][@"p0"]), @"Both p0's should be nil");
            STAssertTrue([segment p1] == ((outputs[i][@"p1"] == [NSNull null]) ? nil : outputs[i][@"p1"]), @"Both p1's should be nil");
            
        } else {
            
            STAssertTrue( [self isCloseEnough:[segment p0].x d1:[outputs[i][@"p0"][@"x"] doubleValue] ] ,@"The X values are not close enough!");
            STAssertTrue( [self isCloseEnough:[segment p0].y d1:[outputs[i][@"p0"][@"y"] doubleValue] ] ,@"The points are not close enough!");
            
            STAssertTrue( [self isCloseEnough:[segment p1].x d1:[outputs[i][@"p1"][@"x"] doubleValue] ] ,@"The points are not close enough!");
            STAssertTrue( [self isCloseEnough:[segment p1].y d1:[outputs[i][@"p1"][@"y"] doubleValue] ] ,@"The points are not close enough!");
        }
    }

}

- (NSArray *)arrayFromJSONFileNamed:(NSString *)fileName {
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
}

- (NSArray *)arrayOfPointsFromJSONFile:(NSInteger)integer {
    
    NSArray *array = [self arrayFromJSONFileNamed:[NSString stringWithFormat:@"points-%d", integer]];
    NSMutableArray *jsonPoints = [NSMutableArray array];
    
    for (NSDictionary *coords in array) {
        [jsonPoints addObject:[[ASPoint alloc] initWithX:[coords[@"x"] doubleValue] y:[coords[@"y"] doubleValue]]];
    }
    
    return jsonPoints;
}

- (BOOL)isCloseEnough:(double)d0 d1:(double)d1 {
    return fabs(d0 - d1) < EPSILON;
}



@end
