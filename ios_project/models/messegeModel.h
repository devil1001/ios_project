//
//  messegeModel.h
//  ios_project
//
//  Created by devil1001 on 25.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface messegeModel : NSObject

@property (strong, nonatomic) NSString *messege;
@property (strong, nonatomic) NSString *sender;

-(instancetype) initMessege:(NSString *)messege sender:(NSString *)sender;

@end
