//
//  vkTableViewCell.h
//  ios_project
//
//  Created by devil1001 on 24.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class cellModel;

@interface vkTableViewCell : UITableViewCell

- (void) fillCellWithModel:(cellModel *)model;

@end
