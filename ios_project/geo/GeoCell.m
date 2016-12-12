//
//  GeoCell.m
//  ios_project
//
//  Created by devil1001 on 13.12.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import "GeoCell.h"
#import "GeoModel.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface GeoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageGeo;

@end

@implementation GeoCell
- (void) fillCellWithImage:(GeoModel *)model{
    [self.imageGeo sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"avat.jpg"]]];
}

@end
