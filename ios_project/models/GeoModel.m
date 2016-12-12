//
//  GeoModel.m
//  ios_project
//
//  Created by devil1001 on 13.12.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import "GeoModel.h"

@implementation GeoModel
-(instancetype) initWithImageName:(NSString *)image {
    if (self = [super init]){
        _image = image;
    }
    return self;
}

@end
