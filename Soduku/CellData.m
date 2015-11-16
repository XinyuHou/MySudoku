//
//  CellData.m
//  Sudoku
//
//  Created by Xinyu on 19/08/2013.
//  Copyright (c) 2013 Xinyu. All rights reserved.
//

#import "CellData.h"

@implementation CellData

@synthesize x;
@synthesize y;
@synthesize value;
@synthesize isBlank;
@synthesize validList;

-(id)initWithX:(int)fx Y:(int)fy
{
    if (self = [super init]) {
        x = fx;
        y = fy;
        value = 0;
        isBlank = NO;
        validList = [NSMutableArray arrayWithCapacity:9];
        
        return  self;
    }
    else
    {
        return nil;
    }
}

@end
