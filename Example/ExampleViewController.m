//
//  ExampleViewController.m
//  DSGridView
//
//  Created by J. Bradford Dillon on 3/15/12.
//  Copyright (c) 2012 Dreamsocket. All rights reserved.
//

#import "ExampleViewController.h"

@interface ExampleViewController ()

@end

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	DSGridView *gridView = [[DSGridView alloc] initWithFrame:self.view.bounds];
	gridView.dataSource = self;
	gridView.tileMargin = DSTileMarginMake(10, 10);
	gridView.rowSeparatorStyle = UITableViewCellSeparatorStyleNone;
	gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		gridView.tilesPerRow = 4;
		gridView.rowHeight = 160;
	} else {
		gridView.tilesPerRow = 3;
		gridView.rowHeight = 100;
	}
	
	[self.view addSubview:gridView];
}



- (void)viewDidUnload {
    [super viewDidUnload];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}






#pragma mark - DSGridViewDataSource

- (NSInteger)numberOfSectionsInGridView:(DSGridView *)gridView {
	return 5;
}



- (NSInteger)gridView:(DSGridView *)gridView numberOfTilesInSection:(NSInteger)section {
	return 12;
}



// Uncomment this to add section headers to the grid. This is implemented, but has some issues with padding that may be undesirable.
//- (NSString *)gridView:(DSGridView *)gridView titleForHeaderInSection:(NSInteger)section {
//	return [NSString stringWithFormat:@"Section %i", section];
//}



- (DSGridViewTile *)gridView:(DSGridView *)gridView viewForGridTileAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *TileIdentifier = @"TileIdentifier";
	DSGridViewTile *tile = [gridView dequeueReusableViewWithIdentifier:TileIdentifier];
	if(!tile) {
		tile = [[DSGridViewTile alloc] initWithFrame:CGRectMake(0, 0, 100, 100) reuseIdentifier:TileIdentifier];
	}
	
	tile.backgroundColor = [UIColor grayColor];
	
	return tile;
}

@end
