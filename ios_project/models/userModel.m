//
//  userModel.m
//  ios_project
//
//  Created by devil1001 on 07.11.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import "userModel.h"

@implementation userModel
- (instancetype) initWithid:(NSString *)id title:(NSString *)title {
    if( self = [super init]){
        _id = id;
        _title = title;
    }
    return self;
}

@end
