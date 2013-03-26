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
    
//    self.point0 = [[ASPoint alloc] initWithX:-10 y:0];
//    self.point1 = [[ASPoint alloc] initWithX:10 y:0];
//    self.point2 = [[ASPoint alloc] initWithX:0 y:10];
//    self.points = @[self.point0, self.point1, self.point2];
//    
//    self.plotBounds = CGRectMake(-20, -20, 40, 40);
//    self.voronoi = [[ASVoronoi alloc] initWithPoints:[NSMutableArray arrayWithArray:self.points] plotBounds:self.plotBounds];
}

- (void)tearDown
{
//    self.voronoi = nil;
//    self.plotBounds = CGRectZero;
//    self.points = nil;
//    self.point0 = self.point1 = self.point2 = nil;
    
    [super tearDown];
}


//- (void)testExample {
//    
//    NSMutableArray *randomPoints = [NSMutableArray array];
//    
//    NSInteger start = 3;
//    NSInteger start2 = 10;
//    for (int i = 0; i < 10; i++) {
//        [randomPoints addObject:[[ASPoint alloc] initWithX:start + (i * 4) y:start2 + (i * 5)]];
//    }
//    
//    ASVoronoi *voronoiInner = [[ASVoronoi alloc] initWithPoints:randomPoints plotBounds:CGRectMake(0, 0, 70, 70)];
//    
//    STAssertNotNil(voronoiInner.edges, @"Edges cannot be nil after this!");
//    
//    for (ASEdge *edge in voronoiInner.edges) {
//        NSLog(@"Final Segments: %@", [edge voronoiEdge]);
//    }
//}

//- (void)testNumberTwo {
//    
//    
//    ASPoint *p0 = [[ASPoint alloc] initWithX:-10 y:0];
//    ASPoint *p1 = [[ASPoint alloc] initWithX:10 y:0];
//    ASPoint *p2 = [[ASPoint alloc] initWithX:0 y:10];
//    NSArray *pos = @[p0, p1, p2];
//    
//    CGRect pb = CGRectMake(-20, -20, 40, 40);
//    ASVoronoi *vo = [[ASVoronoi alloc] initWithPoints:[NSMutableArray arrayWithArray:pos] plotBounds:pb];
//    
//    
//    for (ASEdge *edge in vo.edges) {
//        NSLog(@"Final Segments: %@", [edge voronoiEdge]);
//    }
//    
//    
//}


//- (void)testNumberThree {
//    
//    
//    ASPoint *p0 = [[ASPoint alloc] initWithX:-10 y:0];
//    ASPoint *p1 = [[ASPoint alloc] initWithX:10 y:0];
//    ASPoint *p2 = [[ASPoint alloc] initWithX:-5 y:-5];
//    ASPoint *p3 = [[ASPoint alloc] initWithX:-10 y:3];
//    ASPoint *p4 = [[ASPoint alloc] initWithX:0 y:7];
//    ASPoint *p5 = [[ASPoint alloc] initWithX:13 y:-4];
//    ASPoint *p6 = [[ASPoint alloc] initWithX:10 y:10];
//    ASPoint *p7 = [[ASPoint alloc] initWithX:8 y:1];
//    
//    NSArray *pos = @[p0, p1, p2, p3, p4, p5, p6, p7];
//    
//    CGRect pb = CGRectMake(-20, -20, 40, 40);
//    ASVoronoi *vo = [[ASVoronoi alloc] initWithPoints:[NSMutableArray arrayWithArray:pos] plotBounds:pb];
//    
//    
//    for (ASEdge *edge in vo.edges) {
//        NSLog(@"Final Segments: %@", [edge voronoiEdge]);
//    }
//    
//    for (ASEdge *edge in vo.edges) {
//        NSLog(@"Delaunay Line: %@", [edge delaunayLine]);
//    }
//    
//    
//}

- (void)testJSON {
    
    for (NSInteger i = 0; i < 100; i++) {
        
        NSString * filePath = [[NSBundle bundleForClass:[self class] ] pathForResource:[NSString stringWithFormat:@"points-%d", i] ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        if (data) {
            
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSMutableArray *points = [NSMutableArray array];
            
            for (NSDictionary *coords in array) {
                [points addObject:[[ASPoint alloc] initWithX:[coords[@"x"] doubleValue] y:[coords[@"y"] doubleValue]]];
            }
            
            ASVoronoi *voro = [[ASVoronoi alloc] initWithPoints:points plotBounds:CGRectMake(0, 0, 500, 500)];
            
            NSString *outputPath = @"/Users/ethan/Documents/json";
            
            outputPath = [outputPath stringByExpandingTildeInPath];
            outputPath = [outputPath stringByAppendingPathComponent:[NSString stringWithFormat:@"output-%d", i]];
            outputPath = [outputPath stringByAppendingPathExtension:@"txt"];
            
            NSString *output = @"";
            for (ASEdge *edge in voro.edges) {
                output = [NSString stringWithFormat:@"%@\n%@", output, [edge voronoiEdge]];
            }
            [output writeToFile:outputPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }

    }
    
        
    
}


//- (void)testRegionsHaveNoDuplicatedPoints {
//    NSLog(@"TEST STARTING 111111");
//    
//    for (NSMutableArray *region in [self.voronoi regions]) {
//        NSLog(@"Region: %@", region);
//        NSMutableArray *sortedRegion = [region mutableCopy];
//        
//        NSLog(@"Sorted Region: %@", NSStringFromClass([[sortedRegion lastObject] class]));
//        
//        [sortedRegion sortUsingSelector:@selector(compareYThenX:)];
//        for (NSInteger i = 1; i < [sortedRegion count]; ++i) {
//            STAssertFalse([[sortedRegion objectAtIndex:i] isEqual:[sortedRegion objectAtIndex:i - 1]], @"They should not be equal!");
//        }
//    }
//}



@end
