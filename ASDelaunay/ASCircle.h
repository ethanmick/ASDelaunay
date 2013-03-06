//
//  ASCircle.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASPoint;

@interface ASCircle : NSObject

@property (nonatomic, retain) ASPoint *point;
@property (nonatomic) CGFloat radius;

- (id)initWithX:(CGFloat)anX y:(CGFloat)aY radius:(CGFloat)r;

@end
