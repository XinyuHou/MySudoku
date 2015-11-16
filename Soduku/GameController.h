//
//  GameController.h
//  Sudoku
//
//  Created by Xinyu on 15/07/2013.
//  Copyright (c) 2013 Xinyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Cell.h"

@interface GameController : UIViewController<UITextFieldDelegate, UIScrollViewDelegate> {
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIView *scrollContent;
    __weak IBOutlet UILabel *timer;
    __weak IBOutlet UILabel *difficulty;
    NSString *difficultyString;
    
    int timeSec;
    int timeMin;
    int timeHour;
    
    __weak NSTimer *clock;
    UITextField *textField;
    
    // because UIKeyboardTypeNumberPad does not have
    // done button
    UIButton *doneButton;
    
	BOOL enableMusic;
	MPMusicPlayerController *appPlayer;
	
    // 9 * 9 cell buttons
    Cell * cells[9][9];
    
    int selectedX;
    int selectedY;
    int lastSelectedX;
    int lastSelectedY;
	
	int cellSize;
	
	__weak IBOutlet UIView *WonView;
	__weak IBOutlet UIView *FailedView;
	
	NSManagedObjectContext *context;
	
	BOOL paused;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContent;
@property  (copy) NSString* difficultyString;
@property (weak, nonatomic) IBOutlet UILabel *difficulty;
@property (weak, nonatomic) IBOutlet NSTimer *clock;
@property (assign) BOOL enableMusic;
@property (strong, nonatomic) NSManagedObjectContext *context;

- (IBAction)backToMainMenu:(id)sender;
- (IBAction)backToGame:(id)sender;
- (IBAction)backToScoreBoard:(id)sender;

@end 
