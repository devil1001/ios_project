//
//  GeoModel.h
//  ios_project
//
//  Created by devil1001 on 13.12.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeoModel : NSObject
@property (strong, nonatomic) NSString *image;

- (instancetype) initWithImageName:(NSString *)image;

@end
