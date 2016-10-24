//
//  loginModel.h
//  ios_project
//
//  Created by devil1001 on 23.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface loginModel : NSObject
@property (strong, nonatomic) NSString *login;
@property (strong, nonatomic) NSString *password;

-(instancetype) initWithLogin:(NSString *)login password:(NSString *)password;

@end
