//
//  vkMessegeCell.h
//  ios_project
//
//  Created by devil1001 on 25.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class messegeModel;

@interface vkMessegeCell : UITableViewCell

- (void) fillCellWithMessege:(messegeModel *)model you:(NSString *)you;

@end
