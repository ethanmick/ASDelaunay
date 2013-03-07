//
//  ASPolygon.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASPolygon : NSObject

- (id)initWithPoints:(NSArray *)points;
- (CGFloat)area;


@end
