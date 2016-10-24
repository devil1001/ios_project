//
//  cellModel.m
//  ios_project
//
//  Created by devil1001 on 22.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import "cellModel.h"

@implementation cellModel

-(instancetype) initWithName:(NSString *)name imageName:(NSString *)imageName  messege:(NSString *)messege {
    if( self = [super init]){
        _name = name;
        _imageName = imageName;
        _messege = messege;
    }
    return self;
}

@end
