//
//  Cell.h
//  Sudoku
//
//  Created by Xinyu on 05/08/2013.
//  Copyright (c) 2013 Xinyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell : UIButton {
    NSInteger x;
    NSInteger y;
    NSInteger checkValue;
    NSInteger inputValue;
	BOOL isBlank;
}

@property(assign)NSInteger x;
@property(assign)NSInteger y;
@property(assign)NSInteger checkValue;
@property(assign)NSInteger inputValue;
@property(assign) BOOL isBlank;

@end
