//
//  messegeModel.m
//  ios_project
//
//  Created by devil1001 on 25.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import "messegeModel.h"

@implementation messegeModel

- (instancetype)initMessege:(NSString *)messege sender:(NSString *)sender{
    if(self = [super init] ) {
        _messege = messege;
        _sender = sender;
    }
    return self;
}

@end
