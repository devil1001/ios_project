//
//  messegeViewController.m
//  ios_project
//
//  Created by devil1001 on 26.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import "messegeViewController.h"
#import "messegeModel.h"
#import "vkMessegeCell.h"
#import <VKSdk.h>

@interface messegeViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_modelArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewMessege;
@property (weak, nonatomic) IBOutlet UITextField *messegeTextfield;

@end

@implementation messegeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupModel];
    self.tableViewMessege.dataSource = self;
    self.tableViewMessege.delegate = self;
    
    self.title=[NSString stringWithFormat:@"%@", self.userName];
    
    //self.navigationController.navigationBar.description;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupModel{
    //_modelArray = [[NSMutableArray alloc] init];
    [self loadMessages];
   // [self sendingPhoto];

}

- (void) loadMessages{
    [_modelArray removeAllObjects];
    _modelArray = [[NSMutableArray alloc] init];
    if (self.isChat) {
        NSInteger iden = [self.userID integerValue] + 2000000000;
        NSString *chat_id = [NSString stringWithFormat:@"%ld", iden];
        VKRequest *req = [VKRequest requestWithMethod:@"messages.getHistory" parameters:@{VK_API_COUNT : @"20" ,  VK_API_USER_ID:chat_id}];
        [req executeWithResultBlock:^(VKResponse *response){
            NSInteger dialogsCount = [[response.json valueForKey:@"count"] integerValue];
            if (dialogsCount>=20){
                dialogsCount = 20;
            }
            for (int i = 0; i<dialogsCount; i++) {
                NSString *message = [NSString stringWithFormat:@"%@", [[[response.json valueForKey:@"items" ] objectAtIndex:dialogsCount-i-1] valueForKey:@"body"]];
                NSString *sender = [NSString stringWithFormat:@"%@", [[[response.json valueForKey:@"items" ] objectAtIndex:dialogsCount-i-1] valueForKey:@"from_id"]];
                messegeModel *model = [[messegeModel alloc] initMessege:message sender:sender];
                [_modelArray addObject:model];
            }
            [_tableViewMessege reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_modelArray.count-1 inSection:0];
            [_tableViewMessege scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:false];
        }
                         errorBlock:^(NSError *errorWithName) {
                             NSLog(@"Error: %@", errorWithName);
                         }
         ];
    }
    else {
        VKRequest *req = [VKRequest requestWithMethod:@"messages.getHistory" parameters:@{VK_API_COUNT : @"20" , VK_API_USER_ID:self.userID}];
        [req executeWithResultBlock:^(VKResponse *response){
            NSInteger dialogsCount = [[response.json valueForKey:@"count"] integerValue];
            if (dialogsCount>=20){
                dialogsCount = 20;
            }
            for (int i = 0; i<dialogsCount; i++) {
                NSString *message = [[[response.json valueForKey:@"items" ] objectAtIndex:dialogsCount-i-1] valueForKey:@"body"];
                NSString *sender = [[[response.json valueForKey:@"items" ] objectAtIndex:dialogsCount-i-1] valueForKey:@"from_id"];
                messegeModel *model = [[messegeModel alloc] initMessege:message sender:sender];
                [_modelArray addObject:model];
            }
            [_tableViewMessege reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_modelArray.count-1 inSection:0];
            [_tableViewMessege scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:false];
            
        }
                         errorBlock:^(NSError *errorWithName) {
                             NSLog(@"Error: %@", errorWithName);
                         }
         ];
    }
}

- (NSInteger)tableView:(UITableView *)tableViewMessege numberOfRowsInSection:(NSInteger)section {
    return _modelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableViewMessege heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}



- (UITableViewCell *)tableView:(UITableView *)tableViewMessege cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    vkMessegeCell *cell = [tableViewMessege dequeueReusableCellWithIdentifier:@"vkMessegeCell" forIndexPath:indexPath];
    messegeModel *model;
    if ([_modelArray[indexPath.row] isMemberOfClass:[messegeModel class]]) {
        model = _modelArray[indexPath.row];
        [cell fillCellWithMessege:model you:_yourId];
    }
    return cell;
}

- (IBAction)sendMessegeClicked:(UIButton *)sender {
    if (_messegeTextfield!= nil) {
    
      //  messegeModel *model = [[messegeModel alloc] initMessege:[NSString stringWithFormat:@"%@", _messegeTextfield.text] sender:[NSString stringWithFormat:@"You"]];
       // [_modelArray addObject:model];
        if(self.isChat){
            NSInteger iden = [self.userID integerValue] + 2000000000;
            NSString *user_id = [NSString stringWithFormat:@"%ld", iden];
            VKRequest *req = [VKRequest requestWithMethod:@"messages.send" parameters:@{@"peer_id" : user_id, VK_API_MESSAGE : [NSString stringWithFormat:@"%@", self.messegeTextfield.text]}];
            [req executeWithResultBlock:^(VKResponse *response) {
                [self loadMessages];
            } errorBlock:^(NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        }
        else {
            VKRequest *req = [VKRequest requestWithMethod:@"messages.send" parameters:@{VK_API_USER_IDS : self.userID, VK_API_MESSAGE : [NSString stringWithFormat:@"%@", self.messegeTextfield.text]}];
            [req executeWithResultBlock:^(VKResponse *response) {
                [self loadMessages];
            } errorBlock:^(NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_modelArray.count-1 inSection:0];
        [_tableViewMessege scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
        _messegeTextfield.text = nil;
        
    }
    
    
}


- (void)sendingPhoto{
    //VKRequest *req = [VKRequest requestWithMethod:@"photos.getMessagesUploadServer"];
    VKRequest *req = [VKRequest requestWithMethod:@"photos.getMessagesUploadServer" parameters:@{}];
    [req executeWithResultBlock:^(VKResponse *response){
        NSString *upload_url = [response.json valueForKey:@"upload_url"];
        NSLog(@"response = %@", upload_url);
    }
                     errorBlock:^(NSError *error) {
                         NSLog(@"Error: %@", error);
    }];
    
}



@end
