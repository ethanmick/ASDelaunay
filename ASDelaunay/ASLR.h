//
//  ASLR.h
//  ASDelaunay
//
//  Created by Ethan Mick on 3/10/13.
//  Copyright (c) 2013 Ethan Mick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASLR : NSObject <NSCopying>

+ (ASLR *)LEFT;
+ (ASLR *)RIGHT;
+ (ASLR *)other:(ASLR *)leftRight;


@end
