//
//  DSGridViewTile.m
//  DSGridView
//
//  Created by J. Bradford Dillon on 3/13/12.
//  Copyright (c) 2012 Dreamsocket. All rights reserved.
//

#import "DSGridViewTile.h"

@implementation DSGridViewTile
@synthesize reuseIdentifier;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)identifier {
	if((self = [super initWithFrame:frame])) {
		reuseIdentifier = identifier;
	}
	return self;
}



- (void)prepareForReuse {
	return;
}

@end
