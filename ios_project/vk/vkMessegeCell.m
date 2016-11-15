//
//  vkMessegeCell.m
//  ios_project
//
//  Created by devil1001 on 25.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import "vkMessegeCell.h"
#import "messegeModel.h"
#import <VKSdk.h>

@interface vkMessegeCell ()
@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UILabel *messegeLabel;

@end

@implementation vkMessegeCell

- (void)fillCellWithMessege:(messegeModel *)model you:(NSString *)you{
        if ([model.sender isEqual:you]) {
            //if (true) {
            //self.senderLabel.text = model.sender;
            self.messegeLabel.hidden = false;
            self.messegeLabel.text = model.messege;
            self.senderLabel.hidden = true;
        }
        else {
            self.senderLabel.hidden = false;
            self.senderLabel.text = model.messege;
            self.messegeLabel.hidden = true;
        }
        [self layoutIfNeeded];
    //VKRequest *req = [VKRequest requestWithMethod:@"messages.getHistory" parameters:@{VK_API_COUNT : @"20" , VK_API_USER_ID:chat_id}];
    //[req executeWithResultBlock:^(VKResponse *response){
    }

@end
