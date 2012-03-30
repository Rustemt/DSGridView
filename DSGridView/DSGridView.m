//
//  DSGridView.m
//  DSGridView
//
//  Created by J. Bradford Dillon on 2/17/12.
//  Copyright (c) 2012 Dreamsocket. All rights reserved.
//

#import "DSGridView.h"

DSTileMargin DSTileMarginMake(CGFloat x, CGFloat y) {
	return (DSTileMargin) { x, y };
}

const DSTileMargin DSTileMarginZero = (DSTileMargin) { 0, 0 };

@class DSGridViewCell;

@interface DSGridView ()
@property (nonatomic) BOOL hasBeenSetup;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *tilesInSectionMap;
@property (nonatomic, strong) NSMutableDictionary *tileCaches;
- (void)setup;
- (void)cacheTilesInGridViewCell:(DSGridViewCell *)cell;
@end



@interface DSGridViewCell : UITableViewCell
@property (nonatomic, unsafe_unretained) DSGridView *gridView;
@end

@implementation DSGridViewCell
@synthesize gridView;
- (void)prepareForReuse {
	[super prepareForReuse];
	[gridView cacheTilesInGridViewCell:self];
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	DSTileMargin margin = self.gridView.tileMargin;
	int tilesPerRow = self.gridView.tilesPerRow;
	CGFloat height = self.gridView.rowHeight;
	
	int i = 0;
	for(UIView *subview in self.subviews) {
		if([subview isKindOfClass:[DSGridViewTile class]]) {
			DSGridViewTile *tileView = (DSGridViewTile *)subview;
			tileView.frame = ({
				CGRect r = tileView.frame;
				r.size.width = ((frame.size.width - margin.x) / tilesPerRow) - margin.x;
				r.size.height = height - margin.y;
				r.origin.x = (r.size.width * i) + (margin.x * (i + 1));
				r.origin.y = margin.y;
				r;
			});
			
			i++;
		}
	}
}
@end






@implementation DSGridView
@synthesize tilesPerRow;
@synthesize tileMargin;
@synthesize delegate;
@synthesize dataSource;

@synthesize hasBeenSetup;
@synthesize tableView;
@synthesize tilesInSectionMap;
@synthesize tileCaches;

- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        [self setup];
    }
    return self;
}



- (id)initWithCoder:(NSCoder *)aDecoder {
	if((self = [super initWithCoder:aDecoder])) {
		[self setup];
	}
	return self;
}



- (void)setup {
	if(self.hasBeenSetup) return;
	self.hasBeenSetup = YES;
	
	self.tilesInSectionMap = [[NSMutableDictionary alloc] init];
	
	self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.backgroundColor = [UIColor clearColor];
	
	self.rowHeight = 100;
	self.tilesPerRow = 3;
	self.tileMargin = DSTileMarginZero;
	
	self.tileCaches = [[NSMutableDictionary alloc] init];
	
	[self addSubview:self.tableView];
}



- (void)reloadData {
	[self.tableView reloadData];
}



- (void)setRowHeight:(CGFloat)newHeight {
	self.tableView.rowHeight = newHeight;
}

- (CGFloat)rowHeight {
	return self.tableView.rowHeight;
}

- (void)setRowSeparatorStyle:(UITableViewCellSeparatorStyle)style {
	self.tableView.separatorStyle = style;
}

- (UITableViewCellSeparatorStyle)rowSeparatorStyle {
	return self.tableView.separatorStyle;
}

- (void)setTableHeaderView:(UIView *)tableHeaderView {
	self.tableView.tableHeaderView = tableHeaderView;
}

- (UIView *)tableHeaderView {
	return self.tableView.tableHeaderView;
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
	self.tableView.contentInset = contentInset;
}

- (UIEdgeInsets)contentInset {
	return self.tableView.contentInset;
}

- (void)setTileMargin:(DSTileMargin)newMargin {
	tileMargin = newMargin;
	self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.tileMargin.y, 0);
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.dataSource numberOfSectionsInGridView:self];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger tilesInSection = [self.dataSource gridView:self numberOfTilesInSection:section];
	[self.tilesInSectionMap setObject:[NSNumber numberWithInt:tilesInSection] forKey:[NSNumber numberWithInt:section]];
	return (NSInteger)ceil((float)tilesInSection / (float)self.tilesPerRow);
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if([self.dataSource respondsToSelector:@selector(gridView:titleForHeaderInSection:)])
		return [self.dataSource gridView:self titleForHeaderInSection:section];
	return nil;
}



- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CellIdentifier";
	DSGridViewCell *cell = (DSGridViewCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(!cell) {
		cell = [[DSGridViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.gridView = self;
	}
	
	NSInteger tilesInSection = [[tilesInSectionMap objectForKey:[NSNumber numberWithInt:indexPath.section]] integerValue];
	NSInteger firstTileInRow = indexPath.row * self.tilesPerRow;
	for(int i = 0; i < self.tilesPerRow; i++) {
		NSInteger tileIndex = firstTileInRow + i;
		if(tileIndex >= tilesInSection) break;
		
		DSGridViewTile *tileView = [self.dataSource gridView:self viewForGridTileAtIndexPath:[NSIndexPath indexPathForRow:tileIndex inSection:indexPath.section]];
		tileView.frame = ({
			CGRect r = tileView.frame;
			r.size.width = ((self.frame.size.width - tileMargin.x) / self.tilesPerRow) - self.tileMargin.x;
			r.size.height = self.rowHeight - self.tileMargin.y;
			r.origin.x = (r.size.width * i) + (self.tileMargin.x * (i + 1));
			r.origin.y = self.tileMargin.y;
			r;
		});
		
		tileView.tag = i;
		[cell addSubview:tileView];
	}
	
	return cell;
}



- (DSGridViewTile *)dequeueReusableViewWithIdentifier:(NSString *)identifier {
	NSMutableSet *cache = [self.tileCaches objectForKey:identifier];
	if(!cache) return nil;
	DSGridViewTile *tile = [cache anyObject];
	if(!tile) return nil;
	[cache removeObject:tile];
	[self.tileCaches setObject:cache forKey:identifier];
	return tile;
}



- (void)cacheTilesInGridViewCell:(DSGridViewCell *)cell {
	for(UIView *subview in cell.subviews) {
		if([subview isKindOfClass:[DSGridViewTile class]]) {
			DSGridViewTile *tile = (DSGridViewTile *)subview;
			if(tile.reuseIdentifier) {
				[tile prepareForReuse];
				
				NSMutableSet *cache = [tileCaches objectForKey:tile.reuseIdentifier];
				if(!cache) 
					cache = [NSMutableSet set];
				[cache addObject:tile];
				[self.tileCaches setObject:cache forKey:tile.reuseIdentifier];
			}
			[tile removeFromSuperview];
		}
	}
}



- (DSGridViewTile *)tileForRowAtIndexPath:(NSIndexPath *)indexPath {
	int tileInCell = indexPath.row % self.tilesPerRow;
	int rowIndex = indexPath.row / self.tilesPerRow;
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:indexPath.section]];
	for(UIView *subview in cell.subviews) {
		if([subview isKindOfClass:[DSGridViewTile class]] && subview.tag == tileInCell)
			return (DSGridViewTile *)subview;
	}
	return nil;	
}



@end
