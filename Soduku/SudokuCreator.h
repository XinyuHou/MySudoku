//
//  SudokuCreator.h
//  Sudoku
//
//  Created by Xinyu on 19/08/2013.
//  Copyright (c) 2013 Xinyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CellData;

@interface SudokuCreator : NSObject
{
	CellData* cells[9][9];
}

-(BOOL)isCellBlankX:(int)x Y:(int)y;
-(int)getCellValueX:(int)x Y:(int)y;
-(bool)isCellValid:(CellData *)cell Number:(int)num;
-(void)initValidListForCellX:(int)x Y:(int)y;
-(bool)FillCellX:(int)x Y:(int)y;
-(void)createMatrix;
-(void)FillBlankCellsAccordingToDifficulty:(NSString*)difficulty;

@end
