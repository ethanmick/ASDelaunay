//
//  ASPoint.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Apples CGPoint really sucks for a lot of stuff. You can't put it in arrays,
 * it isn't an object so you cannot run methods on it.
 *
 * This is *my* port damn it, I'm going to fix this. This class will mimic Actionsripts Point class.
 */
@interface ASPoint : NSObject

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

- (id)initWithX:(CGFloat)anX y:(CGFloat)aY;
+ (CGFloat)distanceBetweenPoint0:(ASPoint *)p0 andPoint1:(ASPoint *)p1;
- (CGPoint)point;

@end
