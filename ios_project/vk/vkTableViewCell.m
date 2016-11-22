//
//  vkTableViewCell.m
//  ios_project
//
//  Created by devil1001 on 24.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import "vkTableViewCell.h"
#import "cellModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface vkTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellName;
@property (weak, nonatomic) IBOutlet UILabel *cellMessege;

@end

@implementation vkTableViewCell
//NSString * const kFilename = @"avat.jpg";

- (void)fillCellWithModel:(cellModel *)model {
    //self.cellImageView.image = [UIImage imageNamed:kFilename];
    //self.cellImageView.image = [UIImage imageWithContentsOfFile:model.imageName];
   // [self startDownload:model.imageName];
    //[self probLoad:model.imageName];
    [self.cellImageView sd_setImageWithURL:[NSURL URLWithString:model.imageName] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"user%@.jpg",model.imageName]]];
    self.cellName.text = model.name;
    self.cellMessege.text = model.messege;
    [self layoutIfNeeded];
    self.cellImageView.layer.masksToBounds = YES;
    self.cellImageView.layer.cornerRadius = self.cellImageView.frame.size.width / 1.75;//25.f;
}



@end
