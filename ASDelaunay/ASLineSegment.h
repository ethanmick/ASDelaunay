//
//  ASLineSegment.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASPoint;

@interface ASLineSegment : NSObject

@property (nonatomic, retain) ASPoint *p0;
@property (nonatomic, retain) ASPoint *p1;

- (id)initWithPoint0:(ASPoint *)aPoint0 point1:(ASPoint *)aPoint1;


+ (NSInteger)compareLengthsMAX:(ASLineSegment *)segment0 segment1:(ASLineSegment *)segment1;
+ (CGFloat)compareLengths:(ASLineSegment *)segment0 segment1:(ASLineSegment *)segment1;

@end
