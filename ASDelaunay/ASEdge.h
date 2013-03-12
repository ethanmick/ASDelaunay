//
//  ASEdge.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASSite;
@class ASLR;

@interface ASEdge : NSObject

- (NSComparisonResult)compareSiteDistance:(ASEdge *)object;
- (NSComparisonResult)compareSiteDistanceMAX:(ASEdge *)object;
- (CGFloat)sitesDistance;
- (void)setLeftSite:(ASSite *)s;
- (ASSite *)leftSite;
- (void)setRightSite:(ASSite *)s;
- (ASSite *)rightSite;
- (ASSite *)site:(ASLR *)leftRight;

@end
