//
//  vkMessegeCell.m
//  ios_project
//
//  Created by devil1001 on 25.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import "vkMessegeCell.h"
#import "messegeModel.h"

@interface vkMessegeCell ()
@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UILabel *messegeLabel;

@end

@implementation vkMessegeCell

- (void)fillCellWithMessege:(messegeModel *)model{
    if ([model.sender integerValue] == 23653477) {
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
}

@end
