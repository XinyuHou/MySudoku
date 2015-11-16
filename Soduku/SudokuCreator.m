//
//  SudokuCreator.m
//  Sudoku
//
//  Created by Xinyu on 19/08/2013.
//  Copyright (c) 2013 Xinyu. All rights reserved.
//

#import "SudokuCreator.h"
#import "CellData.h"

@implementation SudokuCreator

-(id)init
{
    if (self = [super init])
    {
        for (int i = 0; i < 9; ++i)
        {
            for (int j = 0; j < 9; ++j)
            {
                cells[i][j] = [[CellData alloc]initWithX:i Y:j];
            }
        }
        return self;
    }
    else
    {
        return nil;
    }
}

-(BOOL)isCellBlankX:(int)x Y:(int)y
{
    return cells[x][y].isBlank;
}

-(int)getCellValueX:(int)x Y:(int)y
{
    return cells[x][y].value;
}

// check if cell is valid with number
-(bool)isCellValid:(CellData *)cell Number:(int)num
{
	// check if already have the same number in that column
    for (int i = 0; i < 9; ++i)
    {
        if(i != cell.y)
        {
            if (num == cells[cell.x][i].value)
                return NO;
        }
    }
	
	// check if already have the same number in that row
    for (int i = 0; i < 9; ++i)
    {
        if(i != cell.x)
        {
            if (num == cells[i][cell.y].value)
                return NO;
        }
    }
	
	// // check if already have the same number in that 3 * 3 square
    int cx = cell.x / 3 * 3 + 1;
    int cy = cell.y / 3 * 3 + 1;
    for (int i = -1; i < 2; ++i)
    {
        for (int j = -1; j < 2; ++j)
        {
            if((cx+i) == cell.x && (cy+j) == cell.y)
            {
                continue;
            }
            
			if (cells[cx+i][cy+j].value == num)
			{
				return NO;
			}
        }
    }
    return YES;
}

-(void)initValidListForCellX:(int)x Y:(int)y
{
    for(int i = 1;i <= 9; ++i)
    {
        if([self isCellValid:cells[x][y] Number:i])
        {
			NSMutableArray* array = cells[x][y].validList;
            [array addObject:[NSNumber numberWithInt:i]];
        }
    }
}

-(bool)FillCellX:(int)x Y:(int)y
{
    // if validList is not empty,randomly choose one, then remove it
    if([cells[x][y].validList count] != 0)
    {
        int size = [cells[x][y].validList count];
        srand((unsigned)time(NULL));
        int n = rand()%size;
        
        cells[x][y].value = [[cells[x][y].validList objectAtIndex:n]intValue];
        [cells[x][y].validList removeObjectAtIndex:n];
    }
	// if it's empty, refill the previous cell
    else
    {
		// the back to (0, 0) then return fill failed
        if (x==0 && y==0)
        {
            return FALSE;
        }
		
		//reset value
        cells[x][y].value = 0;
		
		// depth first search
        if(y != 0)
        {
            if (![self FillCellX:x Y:y-1])
			{
                return FALSE;
            }
        }
        else
        {
            if (![self FillCellX:x-1 Y:8])
			{
                return FALSE;
            }
        }
        
        [self initValidListForCellX:x Y:y];
        
        if (![self FillCellX:x Y:y])
		{
            return FALSE;
        }
		
    }
    return  TRUE;
}

-(void)createMatrix
{
    for (int i = 0; i < 9;++i)
    {
        for (int j = 0; j < 9;++j)
        {
            [self initValidListForCellX:i Y:j];
            if (-1 == [self FillCellX:i Y:j])
            {
                return;
            }
        }
    }
}

-(void)FillBlankCellsAccordingToDifficulty:(NSString*)difficulty
{
    int i = 0;
    int j = 0;
    int loop = 0;
    int blankCellsPerSquare = 0;
    int subCount = 0;
	
	if ([difficulty isEqualToString:@"Easy"])
	{
		blankCellsPerSquare = 2;
	}
	else if ([difficulty isEqualToString:@"Hard"])
	{
		blankCellsPerSquare = 4;
	}
	else if ([difficulty isEqualToString:@"Hell"])
	{
		blankCellsPerSquare = 6;
	}
	else
	{
		blankCellsPerSquare = 2;
	}
    
    for (loop = 0; loop < 9; ++loop)
    {
        subCount = 0;
        
        srand((unsigned)time(NULL) + loop);
        
        while (subCount < (blankCellsPerSquare + rand() % 2))
        {
            srand((unsigned)time(NULL) + loop);
            do {
                i = 3 * (loop % 3) + rand() % 3;
                j = 3 * (loop / 3) + rand() % 3;
            } while (cells[i][j].isBlank == YES);
            
            subCount++;
            cells[i][j].isBlank = YES;
        }
    }
    
}

@end
