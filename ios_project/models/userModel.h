//
//  userModel.h
//  ios_project
//
//  Created by devil1001 on 07.11.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userModel : NSObject
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *title;


- (instancetype) initWithid:(NSString *)id title:(NSString *)title;

@end
