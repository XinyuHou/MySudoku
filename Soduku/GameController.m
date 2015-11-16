//
//  GameController.m
//  Sudoku
//
//  Created by Xinyu on 15/07/2013.
//  Copyright (c) 2013 Xinyu. All rights reserved.
//

#import "GameController.h"
#import "SudokuCreator.h"
#import "HighScoresController.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GameController ()

@end

@implementation GameController

@synthesize scrollView, scrollContent, difficultyString, clock, difficulty, enableMusic, context;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        difficultyString = @"Easy";
		enableMusic = true;
		paused = false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    selectedX = -1;
    selectedY = -1;
    lastSelectedX = -1;
    lastSelectedY = -1;
    
    UIBarButtonItem* button = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Check"
                                              style:(UIBarButtonItemStylePlain)
                                              target:self
                                              action:@selector(checkResult)];
    
    [self.navigationItem setRightBarButtonItem:button];
    self.title = @"Sudoku";
    
    difficulty.text = difficultyString;
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(-1, -1, 0, 0)];
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
    textField.delegate = self;
	textField.text = @"1";
    [self.view addSubview:textField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [scrollView setContentSize: scrollContent.bounds.size];
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 1.5;
    scrollView.delegate = self;
	
	[self.view addSubview:WonView];
	[self.view addSubview:FailedView];
	FailedView.layer.borderColor = [UIColor blueColor].CGColor;
	FailedView.layer.borderWidth = 5.0f;
	WonView.layer.borderColor = [UIColor greenColor].CGColor;
	WonView.layer.borderWidth = 5.0f;
	[WonView setHidden:YES];
	[FailedView setHidden:YES];
	
	// audio stuff
	// create an instance of MPMusicPlayerController
	// instantiate a music player
	if (appPlayer == 0) {
		appPlayer = [MPMusicPlayerController applicationMusicPlayer];
	}
	
	if (enableMusic) {
		// shuffle all songs
		[appPlayer setShuffleMode:MPMusicShuffleModeSongs];
		// assume we will not find our playlist
		BOOL playlistFound = NO;
		// get a collection of all playlists on the device
		MPMediaQuery *playlistsQuery = [MPMediaQuery playlistsQuery];
		NSArray *playlists = [playlistsQuery collections];
		// Check each playlist to see if it is the Favorites list
		for (MPMediaPlaylist *playlist in playlists) {
			NSString *playlistName = [playlist valueForProperty: MPMediaPlaylistPropertyName];
			if ([playlistName isEqualToString:@"Favorites"]) {
				// add the playlist to the player's queue and get out of here
				[appPlayer setQueueWithItemCollection:playlist];
				playlistFound = YES;
				break;
			}
		}
		// if no playlist found, just play any old thing
		if (!playlistFound) {
			[appPlayer setQueueWithQuery: [MPMediaQuery songsQuery]];
		}
		// start playing from the beginning of the queue
		[appPlayer play];
	}
	else {
		[appPlayer stop];
	}
	
	// swipe guesture recognizer for skip song
	UISwipeGestureRecognizer* swiperRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
	swiperRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:swiperRightGestureRecognizer];
	UISwipeGestureRecognizer* swiperLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
	swiperLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:swiperLeftGestureRecognizer];

	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chinesepainting.jpg"]];
}

- (void)handleSwipeFrom:(UIGestureRecognizer*)recognizer {
	[appPlayer stop];
	[appPlayer setQueueWithQuery: [MPMediaQuery songsQuery]];
	[appPlayer play];
}

- (void)addButtonToKeyboard
{
    // create custom button
    if (doneButton == nil) {
        doneButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 163, 106, 53)];
        [doneButton setTitle:@"DONE" forState:UIControlStateNormal];
        [[doneButton titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    }
    else {
        [doneButton setHidden:NO];
    }
    
    [doneButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [doneButton setBackgroundColor:[UIColor whiteColor]];
    [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [doneButton addTarget:self action:@selector(holdingDoneButton:) forControlEvents:UIControlEventTouchDown];
    // locate keyboard view
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIView* keyboard = nil;
    for(int i=0; i<[tempWindow.subviews count]; ++i)
	{
        keyboard = [tempWindow.subviews objectAtIndex:i];
        // keyboard found, add the button
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2)
		{
            if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
			{
                [keyboard addSubview:doneButton];
			}
        }
		else {
            if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
			{
                [keyboard addSubview:doneButton];
			}
        }
    }
}

- (void)holdingDoneButton:(id)Sender
{
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setBackgroundColor:[UIColor darkGrayColor]];
}

- (void)doneButtonClicked:(id)Sender
{
	[cells[selectedX][selectedY] setBackgroundColor:[UIColor colorWithRed:(float)(170.0/255.0) green:(float)(170.0/255.0) blue:(float)(170.0/255.0) alpha:0.7]];
    [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)checkResult
{
    int i,j;

    for (i = 0; i < 9; ++i) {
        for (j = 0; j < 9; ++j) {
            if (cells[i][j].inputValue!=cells[i][j].checkValue) {
				[FailedView setHidden:NO];
                return FALSE;
            }
        }
    }
	[WonView setHidden:NO];
	paused = true;
    return TRUE;
}

- (void) increaseTime: (NSTimer*) clock
{
	if (paused) {
		return;
	}
	
    if (timeSec + 1 == 60) {
        if (timeMin + 1 == 60) {
            ++timeHour;
            timeMin = 0;
        }
        ++timeMin;
        timeSec = 0;
    }
    ++timeSec;
    timer.text = [NSString stringWithFormat:@"%d:%02d:%02d", timeHour, timeMin, timeSec];
}

- (void) CellButtonTouchUpInside:(id)sender
{
    Cell* selectedCell = (Cell*)sender;
	
	if (![selectedCell isBlank])
	{
		return;
	}
	
    lastSelectedX = selectedX;
    lastSelectedY = selectedY;
    selectedX = selectedCell.x;
    selectedY = selectedCell.y;
    if (lastSelectedX != -1 & lastSelectedY != -1) {
        [cells[lastSelectedX][lastSelectedY] setBackgroundColor:[UIColor colorWithRed:(float)(170.0/255.0) green:(float)(170.0/255.0) blue:(float)(170.0/255.0) alpha:0.7]];
    }
    [selectedCell setBackgroundColor:[UIColor colorWithRed:(float)(1.0) green:(float)(1.0) blue:(float)(1.0) alpha:0.7]];
    [textField becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	// if backspace is pressed
	const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, "\b");
    if (isBackSpace == -8) {
		[cells[selectedX][selectedY] setTitle:@"" forState: UIControlStateNormal];
		return NO;
    }
	
    int inputValue = [string intValue];
    if (inputValue <= 0 | inputValue > 9) {
        return NO;
    }
    
    cells[selectedX][selectedY].inputValue = inputValue;
    [cells[selectedX][selectedY] setTitle:[NSString stringWithFormat:@"%d", inputValue] forState: UIControlStateNormal];
    return NO;
}

- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollContent;
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    [self addButtonToKeyboard];
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    // If select cell is hidden by keyboard, scroll it so it's visible
    // otherwise do nothing
    CGPoint op2 = cells[selectedX][selectedY].frame.origin;
	CGPoint contentOffset = [scrollView contentOffset];
    CGRect aRect = scrollView.frame;
	
	CGFloat overlap = kbSize.height - (aRect.size.height - op2.y + contentOffset.y + 20 - cellSize);
	if (overlap > 0) {
		CGPoint scrollPoint = CGPointMake(0.0, contentOffset.y + overlap);
        [scrollView setContentOffset:scrollPoint animated:YES];
	}
}

- (IBAction)backToMainMenu:(id)sender {
	[FailedView setHidden:YES];
	[WonView setHidden:YES];
	[[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)backToGame:(id)sender {
	[FailedView setHidden:YES];
}

- (IBAction)backToScoreBoard:(id)sender {
	HighScoresController* highScores = [[HighScoresController alloc] init];
	highScores.context = context;
	
	// core data, init sql data base for high scores if there is not one.
	[highScores initEntityWithName:@"Easy"];
	[highScores initEntityWithName:@"Hard"];
	[highScores initEntityWithName:@"Hell"];
	
	int time = timeHour * 10000 + timeMin * 100 + timeSec;
	[highScores updateScoreWithCurrentDifficulty:difficulty.text AndTime: time];
	[self.navigationController pushViewController:(highScores) animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [super viewWillDisappear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // create clock if there is no one
    if (!clock)
        clock = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(increaseTime:) userInfo:nil repeats:YES];
    
	// create Sudoku;
	SudokuCreator* sc = [[SudokuCreator alloc]init];
	[sc createMatrix];
	[sc FillBlankCellsAccordingToDifficulty:[difficulty text]];
	
    // create each cell
    int i,j;
    CGRect scrollContentRect = [scrollContent bounds];
	CGRect scrollViewRect = [scrollView bounds];
    CGFloat scrollContentWidth = scrollContentRect.size.width;
    CGFloat scrollContentHeight = scrollContentRect.size.height;
    int shortSide = scrollContentHeight < scrollContentWidth ? scrollContentHeight : scrollContentWidth;
    int longSide = scrollContentHeight > scrollContentWidth ? scrollContentHeight : scrollContentWidth;
    cellSize = (shortSide - 10) / 9;
    int leftMargin = ((shortSide - 10) % 9) / 2;
    int topMargin = longSide / 2 - 6 - 4 * cellSize;
    [scrollView setContentOffset:CGPointMake(0, (scrollContentHeight - scrollViewRect.size.height) / 2)];
    //scrollView.showsVerticalScrollIndicator = NO;
    [scrollView setBounces:NO];
    for (i = 0; i < 9; ++i) {
        for (j = 0; j < 9; ++j) {
            cells[i][j] = [[Cell alloc] initWithFrame:CGRectMake(
            leftMargin + (cellSize + 1) * i + (i / 3),
            topMargin +  j * (cellSize + 1) + (j / 3),
            cellSize,
            cellSize)];
            
            cells[i][j].x = i;
            cells[i][j].y = j;
            cells[i][j].checkValue = [sc getCellValueX:i Y:j];
			cells[i][j].isBlank = [sc isCellBlankX:i Y:j];
			
			[cells[i][j]setBackgroundColor:[UIColor colorWithRed:(float)(170.0/255.0) green:(float)(170.0/255.0) blue:(float)(170.0/255.0) alpha:0.7]];
            [cells[i][j] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			
			if (![sc isCellBlankX:i Y:j])
			{
				cells[i][j].inputValue = cells[i][j].checkValue;
				[cells[i][j] setTitle:[NSString stringWithFormat:@"%d", cells[i][j].inputValue] forState: UIControlStateNormal];
				[cells[i][j]setBackgroundColor:[UIColor colorWithRed:(float)(111.0/255.0) green:(float)(111.0/255.0) blue:(float)(111.0/255.0) alpha:0.7]];
			}
			
            [cells[i][j] addTarget:self action:@selector(CellButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [scrollContent addSubview:cells[i][j]];
        }
    }
   
}

- (void) viewDidDisappear:(BOOL)animated
{
    [clock invalidate];
    clock = nil;
}

- (void)viewDidUnload
{
    for (int i=0; i<9; i++) {
        for (int j=0; j<9; j++) {
            cells[i][j] = nil;
        }
    }
    
[super viewDidUnload];
}

@end
