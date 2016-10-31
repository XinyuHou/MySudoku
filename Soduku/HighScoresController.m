//
//  HighScoresController.m
//  Sudoku
//
//  Created by Xinyu on 10/09/2013.
//  Copyright (c) 2013 Xinyu. All rights reserved.
//

#import "HighScoresController.h"

@interface HighScoresController ()

@end

@implementation HighScoresController
@synthesize HighScoresCollection, context;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		HighScoresCollection = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self updateScoreBoard];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chinesepainting1.jpg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateScoreBoard
{
	Easy1.text = [self formatScoreStringFromInteger: [[HighScoresCollection objectAtIndex:0] integerValue]];
	Easy2.text = [self formatScoreStringFromInteger: [[HighScoresCollection objectAtIndex:1] integerValue]];
	Easy3.text = [self formatScoreStringFromInteger: [[HighScoresCollection objectAtIndex:2] integerValue]];
	
	Hard1.text = [self formatScoreStringFromInteger: [[HighScoresCollection objectAtIndex:3] integerValue]];
	Hard2.text = [self formatScoreStringFromInteger: [[HighScoresCollection objectAtIndex:4] integerValue]];
	Hard3.text = [self formatScoreStringFromInteger: [[HighScoresCollection objectAtIndex:5] integerValue]];
	
	Hell1.text = [self formatScoreStringFromInteger: [[HighScoresCollection objectAtIndex:6] integerValue]];
	Hell2.text = [self formatScoreStringFromInteger: [[HighScoresCollection objectAtIndex:7] integerValue]];
	Hell3.text = [self formatScoreStringFromInteger: [[HighScoresCollection objectAtIndex:8] integerValue]];
}

-(NSString*)formatScoreStringFromInteger:(NSInteger) number
{
	NSMutableString *result = [NSMutableString stringWithFormat:@"%06ld", (long)number];
	[result insertString:@":" atIndex:2];
	[result insertString:@":" atIndex:5];
	return result;
}

- (void)initEntityWithName: (NSString*) entityName
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSError *error;
	
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:entityName inManagedObjectContext:context];
	[fetchRequest setEntity:entityDescription];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	id result = [fetchedObjects lastObject];
	if (result == nil) {
		NSManagedObject *obj = [NSEntityDescription
								 insertNewObjectForEntityForName:entityName
								 inManagedObjectContext:context];
		NSNumber* zero = [NSNumber numberWithInt:95959];
		[obj setValue:zero forKey:@"first"];
		[obj setValue:zero forKey:@"second"];
		[obj setValue:zero forKey:@"third"];
		
		if (![context save:&error]) {
			NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		}
		
		[HighScoresCollection addObject:zero];
		[HighScoresCollection addObject:zero];
		[HighScoresCollection addObject:zero];
	}
	else {
		for (NSManagedObject *info in fetchedObjects) {
			[HighScoresCollection addObject:[info valueForKey:@"first"]];
			[HighScoresCollection addObject:[info valueForKey:@"second"]];
			[HighScoresCollection addObject:[info valueForKey:@"third"]];
			
			// delete every thing
//			[context deleteObject:info];
//			[context save:&error];
		}
	}
}

- (void)updateScoreWithCurrentDifficulty: (NSString*)difficulty AndTime: (int)time
{
	// index in HighScoresCollection is
	// Easy 1 2 3 Hard 1 2 3 Hell 1 2 3
	int offset = [self getOffsetAccordingTo: difficulty];
	
	if ([[HighScoresCollection objectAtIndex:offset + 2]integerValue] < time) {
		// time is greater than the third high score
		return;
	}
	else if ([[HighScoresCollection objectAtIndex:offset + 1]integerValue] < time) {
		// time is less than the third high score but greater than the second
		[HighScoresCollection replaceObjectAtIndex:offset + 2 withObject: [NSNumber numberWithInt:time]];
		return;
	}
	else if ([[HighScoresCollection objectAtIndex:offset]integerValue] < time) {
		// time is less than the second high score but greater than the first
		[HighScoresCollection replaceObjectAtIndex:offset + 1 withObject: [NSNumber numberWithInt:time]];
		return;
	}
	else {
		// time is less than the first high score
		[HighScoresCollection replaceObjectAtIndex:offset withObject: [NSNumber numberWithInt:time]];
		return;
	}
}

-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if (![[self.navigationController viewControllers] containsObject:self]) {
        [self saveCoreData:@"Easy"];
		[self saveCoreData:@"Hard"];
		[self saveCoreData:@"Hell"];
	}
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    // parent is nil if this view controller was removed
	if (parent == nil) {
		[self saveCoreData:@"Easy"];
		[self saveCoreData:@"Hard"];
		[self saveCoreData:@"Hell"];
	}
}

-(void)saveCoreData: (NSString*)entityName
{
	int offset = [self getOffsetAccordingTo: entityName];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSError *error;
	
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:entityName inManagedObjectContext:context];
	[fetchRequest setEntity:entityDescription];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	id result = [fetchedObjects lastObject];
	if (result != nil) {
		for (NSManagedObject *info in fetchedObjects) {
			[context deleteObject:info];
			[context save:&error];
		}
		
		NSManagedObject *object = [NSEntityDescription
								 insertNewObjectForEntityForName:entityName
								 inManagedObjectContext:context];
		NSNumber* num = [NSNumber numberWithInt:[[HighScoresCollection objectAtIndex:offset] intValue]];
		[object setValue:num forKey:@"first"];
		num = [NSNumber numberWithInt:[[HighScoresCollection objectAtIndex:offset + 1] intValue]];
		[object setValue:num forKey:@"second"];
		num = [NSNumber numberWithInt:[[HighScoresCollection objectAtIndex:offset + 2] intValue]];
		[object setValue:num forKey:@"third"];
		
		if (![context save:&error]) {
			NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		}
	}
}

-(int)getOffsetAccordingTo: (NSString*) difficulty
{
	int offset = 0;
	if ([difficulty isEqual: @"Hard"]) {
		offset += 3;
	}
	else if ([difficulty isEqual: @"Hell"]) {
		offset += 6;
	}
	return offset;
}
@end
