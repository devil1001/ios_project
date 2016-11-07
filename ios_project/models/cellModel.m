//
//  cellModel.m
//  ios_project
//
//  Created by devil1001 on 22.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import "cellModel.h"

@implementation cellModel

-(instancetype) initWithName:(NSString *)name imageName:(NSString *)imageName  messege:(NSString *)messege user_id:(NSString *)user_id isChat:(BOOL)isChat {
    if( self = [super init]){
        _name = name;
        _user_id = user_id;
        _imageName = imageName;
        _messege = messege;
        _isChat = isChat;
    }
    return self;
}

@end
