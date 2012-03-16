//
//  DSGridView.h
//  TENNetworkIPhone
//
//  Created by J. Bradford Dillon on 2/17/12.
//  Copyright (c) 2012 Dreamsocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSGridViewTile.h"

@protocol DSGridViewDataSource;
@protocol DSGridViewDelegate;

typedef CGPoint DSTileMargin;
DSTileMargin DSTileMarginMake(CGFloat x, CGFloat y);
const DSTileMargin DSTileMarginZero;

@interface DSGridView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, unsafe_unretained) IBOutlet id <DSGridViewDelegate> delegate;
@property (nonatomic, unsafe_unretained) IBOutlet id <DSGridViewDataSource> dataSource;
@property (nonatomic, unsafe_unretained) IBOutlet UIView *tableHeaderView;
@property (nonatomic) DSTileMargin tileMargin;
@property (nonatomic) UIEdgeInsets contentInset;
@property (nonatomic) CGFloat rowHeight;
@property (nonatomic) NSInteger tilesPerRow;
@property (nonatomic) UITableViewCellSeparatorStyle rowSeparatorStyle;

- (void)reloadData;
- (DSGridViewTile *)dequeueReusableViewWithIdentifier:(NSString *)identifier;
- (DSGridViewTile *)tileForRowAtIndexPath:(NSIndexPath *)indexPath;

@end






@protocol DSGridViewDataSource <NSObject>
- (NSInteger)numberOfSectionsInGridView:(DSGridView *)gridView;
- (NSInteger)gridView:(DSGridView *)gridView numberOfTilesInSection:(NSInteger)section;
- (DSGridViewTile *)gridView:(DSGridView *)gridView viewForGridTileAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSString *)gridView:(DSGridView *)gridView titleForHeaderInSection:(NSInteger)section;
@end



// COMING SOON!
// Not currently implemented. Use UIGestureRecognizers in your dataSource or tile subclasses instead. -JBD
@protocol DSGridViewDelegate <NSObject>
- (void)gridView:(DSGridView *)gridView didSelectTileAtIndexPath:(NSIndexPath *)indexPath;
@end