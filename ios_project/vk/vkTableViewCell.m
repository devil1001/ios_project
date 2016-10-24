//
//  vkTableViewCell.m
//  ios_project
//
//  Created by devil1001 on 24.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import "vkTableViewCell.h"
#import "cellModel.h"

@interface vkTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;

@end

@implementation vkTableViewCell

- (void)fillCellWithModel:(cellModel *)model {
    self.cellImageView.image = [UIImage imageNamed:model.imageName];
    self.cellLabel.text = model.name;
    
    [self layoutIfNeeded];
    self.cellImageView.layer.masksToBounds = YES;
    self.cellImageView.layer.cornerRadius = self.cellImageView.frame.size.width / 2;//25.f;
}
@end
