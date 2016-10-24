//
//  loginModel.m
//  ios_project
//
//  Created by devil1001 on 23.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import "loginModel.h"

@implementation loginModel

-(instancetype)initWithLogin:(NSString *)login password:(NSString *)password {
    if (self = [super init]) {
        _login = login;
        _password = password;
    }
    return self;
}

-(instancetype) init{
    return [self initWithLogin:@"" password:@""];
}

@end
