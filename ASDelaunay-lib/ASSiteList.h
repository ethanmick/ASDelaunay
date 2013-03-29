//
//  ASSiteList.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/13/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASSite;

@interface ASSiteList : NSObject

- (NSMutableArray *)circles;
- (NSMutableArray *)siteCoords;
- (CGRect)getSitesBounds;
- (ASSite *)next;
- (NSUInteger)push:(ASSite *)aSite;
- (NSUInteger)length;
- (NSMutableArray *)regions:(CGRect)plotBounds;

@end
