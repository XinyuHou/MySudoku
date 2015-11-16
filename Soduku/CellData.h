//
//  CellData.h
//  Sudoku
//
//  Created by Xinyu on 19/08/2013.
//  Copyright (c) 2013 Xinyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellData : NSObject
{
	
	int x;
	int y;
	int value;
	BOOL isBlank;
	NSMutableArray *validList;
}

@property (assign,readwrite)int x;
@property (assign,readwrite)int y;
@property (assign,readwrite)int value;
@property (assign,readwrite)BOOL isBlank;
@property (retain,readwrite)NSMutableArray *validList;

-(id)initWithX:(int)fx Y:(int)fy;

@end
