//
//  vkTableViewController.h
//  ios_project
//
//  Created by devil1001 on 24.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk.h>


@interface vkTableViewController : UITableViewController <VKSdkDelegate>
@property (strong,nonatomic) NSString *yourId;

@end
