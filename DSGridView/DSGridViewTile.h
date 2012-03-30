//
//  DSGridViewTile.h
//  DSGridView
//
//  Created by J. Bradford Dillon on 3/13/12.
//  Copyright (c) 2012 Dreamsocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSGridViewTile : UIView

@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;
- (void)prepareForReuse;

@end
