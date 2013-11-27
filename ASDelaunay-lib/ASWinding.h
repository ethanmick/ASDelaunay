//
//  ASWinding.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/6/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ASWinding : NSObject

@property (nonatomic, strong) NSString *name;

- (id)initWithName:(NSString *)string;
+ (ASWinding *)CLOCKWISE;
+ (ASWinding *)COUNTERCLOCKWISE;
+ (ASWinding *)NONE;

@end