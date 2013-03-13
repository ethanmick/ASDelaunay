//
//  ASEdgeReorderer.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/11/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASEdgeReorderer : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *edges;
@property (nonatomic, strong, readonly) NSMutableArray *edgeOrientations;

- (id)initWithEdges:(NSMutableArray *)origEdges criterion:(Class)criterion;
- (NSMutableArray *)reorderEdges:(NSMutableArray *)origEdges criterion:(Class)criterion;

@end
