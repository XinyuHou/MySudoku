//
//  HighScoresController.h
//  Sudoku
//
//  Created by Xinyu on 10/09/2013.
//  Copyright (c) 2013 Xinyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface HighScoresController : UIViewController
{
	IBOutletCollection(UILabel) NSMutableArray *HighScoresCollection;
	
	__weak IBOutlet UILabel *Easy1;
	__weak IBOutlet UILabel *Easy2;
	__weak IBOutlet UILabel *Easy3;
	__weak IBOutlet UILabel *Hard1;
	__weak IBOutlet UILabel *Hard2;
	__weak IBOutlet UILabel *Hard3;
	__weak IBOutlet UILabel *Hell1;
	__weak IBOutlet UILabel *Hell2;
	__weak IBOutlet UILabel *Hell3;
	
	NSManagedObjectContext *context;
}

@property IBOutletCollection(UILabel) NSMutableArray* HighScoresCollection;
@property (strong, nonatomic) NSManagedObjectContext *context;

- (void)updateScoreBoard;
- (void)initEntityWithName: (NSString*) entityName;
- (void)updateScoreWithCurrentDifficulty: (NSString*)difficulty AndTime: (int)time;
@end
