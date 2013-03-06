//
//  ASLineSegment.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASLineSegment : NSObject

@property (nonatomic) CGPoint p0;
@property (nonatomic) CGPoint p1;

- (id)initWithPoint0:(CGPoint)aPoint0 point1:(CGPoint)aPoint1;

@end
