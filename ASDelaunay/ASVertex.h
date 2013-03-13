//
//  ASVertex.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/11/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASPoint.h"

@interface ASVertex : NSObject <ICoord>

@property (nonatomic, readonly) NSInteger vertexIndex;

- (void)setIndex;
+ (ASVertex *)VERTEX_AT_INFINITY;
- (CGFloat)getX;
- (CGFloat)getY;

@end
