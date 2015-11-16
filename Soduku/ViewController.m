//
//  ViewController.m
//  Sudoku
//
//  Created by Xinyu on 15/07/2013.
//  Copyright (c) 2013 Xinyu. All rights reserved.
//

#import "ViewController.h"
#import "GameController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize progressBar, musicSwitch, logoView, startView, difficultiesView, settingView, context;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.logoView];
    [self.view addSubview:self.startView];
    [self.view addSubview:self.difficultiesView];
	[self.view addSubview:self.settingView];
    [self.startView setHidden:YES];
    [self.difficultiesView setHidden:YES];
	[self.settingView setHidden:YES];
	[progressBar setProgress:0.0];
	enableMusic = [[NSUserDefaults standardUserDefaults] boolForKey:@"EnableMusic"];
	musicSwitch.on = enableMusic;
	self.logoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chinesepainting.jpg"]];
	self.startView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chinesepainting.jpg"]];
	self.difficultiesView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chinesepainting.jpg"]];
	self.settingView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chinesepainting1.jpg"]];
	[self performSelectorInBackground:@selector(loadGameData) withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadGameData {
	for (int i = 1; i <= 3;  ++i) {
		[self performSelectorOnMainThread:@selector(updateProgress:) withObject:[NSNumber numberWithInt:i] waitUntilDone:NO];
		[NSThread sleepForTimeInterval:1.0];
	}

    [self.logoView setHidden:YES];
    [self.startView setHidden:NO];
}

- (void)updateProgress:(NSNumber *)number
{
    [progressBar setProgress:(number.floatValue / 3) animated:YES];
}

- (IBAction)gotoDifficultiesView:(id)sender
{
    [self.startView setHidden:YES];
    [self.difficultiesView setHidden:NO];
}

- (IBAction)quitGame:(id)sender
{
    exit(0);
}

- (IBAction)newGame:(id)sender
{
    [self.difficultiesView setHidden:YES];
    [self.startView setHidden:NO];
    [self showGameScreen:sender];
}

- (IBAction)gameSettings:(id)sender
{
	[self.startView setHidden:YES];
    [self.settingView setHidden:NO];
}

- (IBAction)enableMusic:(UISwitch*)sender
{
	enableMusic = sender.on;
}

- (IBAction)backToStartView:(id)sender
{
	[self.startView setHidden:NO];
    [self.settingView setHidden:YES];

	if (enableMusic) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EnableMusic"];
	}
	else {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"EnableMusic"];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showGameScreen: (id)sender
{
    UIButton* button = (UIButton*) sender;
    NSString* text = button.titleLabel.text;
    
    GameController* gc = [[GameController alloc] init];
    if ([text length] != 0) {
        gc.difficultyString = text;
    }
	
	gc.enableMusic = enableMusic;
	gc.context = context;
	
    [self.navigationController pushViewController:(gc) animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (IBAction)gotoHighScoreBoard:(id)sender {
	highScores = [[HighScoresController alloc] init];
	highScores.context = context;
	
	// core data, init sql data base for high scores if there is not one.
	[highScores initEntityWithName:@"Easy"];
	[highScores initEntityWithName:@"Hard"];
	[highScores initEntityWithName:@"Hell"];
	
	[self.navigationController pushViewController:(highScores) animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
