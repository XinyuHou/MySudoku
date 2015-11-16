//
//  ViewController.h
//  Sudoku
//
//  Created by Xinyu on 15/07/2013.
//  Copyright (c) 2013 Xinyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "HighScoresController.h"

@interface ViewController : UIViewController
{
    IBOutlet UIView *logoView;
    IBOutlet UIView *difficultiesView;
    IBOutlet UIView *startView;
	IBOutlet UIView *settingView;
	
	__weak IBOutlet UIProgressView *progressBar;
	__weak IBOutlet UISwitch *musicSwitch;
	
	NSManagedObjectContext *context;
	HighScoresController *highScores;
	
	BOOL enableMusic;
}

@property (strong, nonatomic) IBOutlet UIView *logoView;
@property (strong, nonatomic) IBOutlet UIView *startView;
@property (strong, nonatomic) IBOutlet UIView *difficultiesView;
@property (strong, nonatomic) IBOutlet UIView *settingView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UISwitch *musicSwitch;
@property (strong, nonatomic) NSManagedObjectContext *context;

- (IBAction)gotoDifficultiesView:(id)sender;
- (IBAction)quitGame:(id)sender;
- (IBAction)newGame:(id)sender;
- (IBAction)gameSettings:(id)sender;
- (IBAction)enableMusic:(UISwitch*)sender;
- (IBAction)backToStartView:(id)sender;
- (IBAction)gotoHighScoreBoard:(id)sender;

-(void)loadGameData;
-(void)updateProgress:(NSNumber *)number;
@end
