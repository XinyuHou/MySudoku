//
//  Cell.m
//  Sudoku
//
//  Created by Xinyu on 05/08/2013.
//  Copyright (c) 2013 Xinyu. All rights reserved.
//

#import "Cell.h"

@implementation Cell

@synthesize x, y, checkValue, inputValue, isBlank;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        x = 0;
        y = 0;
        checkValue = 0;
        inputValue = 0;
		isBlank = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
