//
//  vkTableViewController.m
//  ios_project
//
//  Created by devil1001 on 24.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import "vkTableViewController.h"
#import "vkTableViewCell.h"
#import "cellModel.h"
#import "messegeViewController.h"
#import <VKSdk.h>
#import "userModel.h"

@interface vkTableViewController ()
{
    NSMutableArray *_modelArray;
    NSMutableArray *_userArray;
    NSMutableArray *_messageArray;
    NSMutableArray *_chatArray;
}
@end

@implementation vkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void) setupModel{
    
    [self getDialogs];
}

- (void) getDialogs{
    [_modelArray removeAllObjects];
    [_userArray removeAllObjects];
    [_messageArray removeAllObjects];
    [_chatArray removeAllObjects];
    _modelArray = [[NSMutableArray alloc] init];
    _messageArray = [[NSMutableArray alloc] init];
    _userArray = [[NSMutableArray alloc] init];
    _chatArray = [[NSMutableArray alloc] init];
    VKRequest *req = [VKRequest requestWithMethod:@"messages.getDialogs" parameters:@{VK_API_COUNT : @"20"}];
    [req executeWithResultBlock:^(VKResponse *response){
        NSInteger dialogsCount = [[response.json valueForKey:@"count"] integerValue];
        if (dialogsCount>=20) {
            dialogsCount = 20;
        }
        for (int i=0; i<dialogsCount; i++) {
            if([[[[response.json valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"message"] objectForKey:@"fwd_messages"]){
                if ([[[[[response.json valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"message"] objectForKey:@"body"] isEqualToString:@""]){
                    NSString *messageVK = [NSString stringWithFormat:@"[Пересланные сообщения]"];
                    [_messageArray addObject: messageVK];
                }
                else{
                    NSString *messageVK = [NSString stringWithFormat:@"%@ [Пересланные сообщения]", [[[[response.json valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"message"] valueForKey:@"body"]];
                    [_messageArray addObject:messageVK];
                }
            }
            else {
                NSString *messageVK = [NSString stringWithFormat:@"%@", [[[[response.json valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"message"] valueForKey:@"body"]];
                [_messageArray addObject: messageVK];
            }
            if ([[[[response.json valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"message"] objectForKey:@"chat_id"]) {
                NSString *ident = [NSString stringWithFormat:@"%@",[[[[response.json valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"message"] valueForKey:@"chat_id"]];
                NSString *title = [NSString stringWithFormat:@"%@",[[[[response.json valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"message"] valueForKey:@"title"]];
                NSString *lastUser = [NSString stringWithFormat:@"%@", [[[[response.json valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"message"] valueForKey:@"user_id"]];
                userModel *umodel = [[userModel alloc] initWithid:ident title:title];
                [_userArray addObject: umodel];
                [_chatArray addObject:lastUser];
            }
            else {
                NSString *ident = [NSString stringWithFormat:@"%@",[[[[response.json valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"message"] valueForKey:@"user_id"]];
                NSString *title = [NSString stringWithFormat:@"%@",[[[[response.json valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"message"] valueForKey:@"title"]];
                userModel *umodel = [[userModel alloc] initWithid:ident title:title];
                [_userArray addObject: umodel];
                NSString *lastUser = @"...";
                [_chatArray addObject:lastUser];
            }
        }
        VKRequest *req1 = [[VKApi users] get:@{VK_API_FIELDS : @"first_name, last_name, photo_50", VK_API_USER_IDS : [_userArray valueForKey:@"id"]}];
        [req1 executeWithResultBlock: ^(VKResponse *response2) {
            for (int i=0; i<dialogsCount; i++) {
                if ([[[_userArray objectAtIndex:i] valueForKey:@"title" ] isEqual: @" ... "]){
                    NSString *firstname = [[response2.json valueForKey:@"first_name"] objectAtIndex:i];
                    NSString *lastname = [[response2.json valueForKey:@"last_name"] objectAtIndex:i];
                    NSString *name = [NSString stringWithFormat:@"%@ %@", firstname, lastname];
                    NSString *user_id = [[response2.json valueForKey:@"id"] objectAtIndex:i];
                    NSString *avat = [[response2.json valueForKey:@"photo_50"] objectAtIndex:i];
                    cellModel *model = [[cellModel alloc] initWithName:name imageName:avat messege:[_messageArray objectAtIndex:i] user_id:user_id is_Chat:false];
                    [_modelArray addObject:model];
                }
                else {
                    NSString *name = [[_userArray objectAtIndex:i] valueForKey:@"title"];
                    NSString *user_id = [[response2.json valueForKey:@"id"] objectAtIndex:i];
                    NSString *avat = [[response2.json valueForKey:@"photo_50"] objectAtIndex:i];
                    cellModel *model = [[cellModel alloc] initWithName:name imageName:avat messege:[_messageArray objectAtIndex:i] user_id:user_id is_Chat:true];
                    [_modelArray addObject:model];
                }
            }
           // if (first_time) {
                [[self tableView] reloadData];
             //   first_time = false;
            //}
            
            //          is_refreshing = false;
        } errorBlock:^(NSError *errorWithName) {
            NSLog(@"Error: %@", errorWithName);
        }
         ];
    }
                     errorBlock:^(NSError *error){
                         NSLog(@"Error: %@", error);
                     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (IBAction)RefreshTable:(id)sender {
//    if (!is_refreshing) {
        [self getDialogs];
    [[self tableView] reloadData];
//        is_refreshing = true;
  //  }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    vkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIndeficator" forIndexPath:indexPath];
    cellModel *model;
    if ([_modelArray[indexPath.row] isMemberOfClass:[cellModel class]]) {
        model = _modelArray[indexPath.row];
        [cell fillCellWithModel:model];
    }
    return cell;
}


/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 if ([segue.identifier isEqualToString:@"dialogChoosen"]) {
 
     NSIndexPath *indexPath = (NSIndexPath *)sender;
     messegeViewController *messegeView = [segue destinationViewController];
     cellModel *model;
     model = _modelArray[indexPath.row];
     messegeView.userID = model.name;
     NSLog(@"%@", messegeView.userID);
 //обращаемся к вью по айди и даем параметру нужные данныеl
     //UIViewController *view = [[UIViewController alloc] initWithNibName:@"messegeView" bundle:];
 
 }
 
 }*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.navigationController performSegueWithIdentifier:@"dialogChoose" sender:indexPath];
    UIStoryboard *storyBoard = [self storyboard];
    messegeViewController *mvC = [storyBoard instantiateViewControllerWithIdentifier:@"messegeView"];
    cellModel *model;
    model = _modelArray[indexPath.row];
    mvC.userName = model.name;
    mvC.userID = model.user_id;
    mvC.isChat = model.is_Chat;
    mvC.yourId = self.yourId;
    [self.navigationController pushViewController:mvC animated:true];
 }


//отрисовывать наоборот переворотами!!!


@end
