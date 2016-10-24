//
//  cellModel.h
//  ios_project
//
//  Created by devil1001 on 22.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cellModel : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageName;
//@property (strong, nonatomic) NSString *messege;

- (instancetype) initWithName:(NSString *)name imageName:(NSString *)imageName ;

@end
