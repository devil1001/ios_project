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
    //NSString *userArray [20];
    //NSString *messageArray [20];
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
    _modelArray = [[NSMutableArray alloc] init];
    _messageArray = [[NSMutableArray alloc] init];
    _userArray = [[NSMutableArray alloc] init];
    VKRequest *req = [VKRequest requestWithMethod:@"messages.getDialogs" parameters:@{VK_API_COUNT : @"20"}];
    [req executeWithResultBlock:^(VKResponse *response){
        NSData *rsp = [NSData dataWithData:response.json];
        for (int i=0; i<20; i++) {
            NSString *messageVK = [NSString stringWithFormat:@"%@", [[[[rsp valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"message"] valueForKey:@"body"]];
            [_messageArray addObject: messageVK];
            if ([[[[rsp valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"message"] objectForKey:@"chat_id"]) {
                NSString *ident = [NSString stringWithFormat:@"%@",[[[[rsp valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"message"] valueForKey:@"chat_id"]];
                NSString *title = [NSString stringWithFormat:@"%@",[[[[rsp valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"message"] valueForKey:@"title"]];
                userModel *umodel = [[userModel alloc] initWithid:ident title:title];
                [_userArray addObject: umodel];
            }
            else {
                NSString *ident = [NSString stringWithFormat:@"%@",[[[[rsp valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"message"] valueForKey:@"user_id"]];
                NSString *title = [NSString stringWithFormat:@"%@",[[[[rsp valueForKey:@"items" ] objectAtIndex:i] valueForKey:@"message"] valueForKey:@"title"]];
                 userModel *umodel = [[userModel alloc] initWithid:ident title:title];
                [_userArray addObject: umodel];
            }
        }
        VKRequest *req1 = [[VKApi users] get:@{VK_API_FIELDS : @"first_name, last_name, photo_100", VK_API_USER_IDS : [_userArray valueForKey:@"id"]}];
        [req1 executeWithResultBlock: ^(VKResponse *response2) {
            NSData *resp12 = [NSData dataWithData:response2.json];
            for (int i=0; i<20; i++) {
                if ([[[_userArray objectAtIndex:i] valueForKey:@"title" ] isEqual: @" ... "]){
                    NSString *firstname = [[resp12 valueForKey:@"first_name"] objectAtIndex:i];
                    NSString *lastname = [[resp12 valueForKey:@"last_name"] objectAtIndex:i];
                    NSString *name = [NSString stringWithFormat:@"%@ %@", firstname, lastname];
                    NSString *user_id = [[resp12 valueForKey:@"id"] objectAtIndex:i];
                    cellModel *model = [[cellModel alloc] initWithName:name imageName:@"avat.jpg" messege:[_messageArray objectAtIndex:i] user_id:user_id isChat:false];
                    [_modelArray addObject:model];
                }
                else {
                    NSString *name = [[_userArray objectAtIndex:i] valueForKey:@"title"];
                    NSString *user_id = [[resp12 valueForKey:@"id"] objectAtIndex:i];
                    cellModel *model = [[cellModel alloc] initWithName:name imageName:@"avat.jpg" messege:[_messageArray objectAtIndex:i] user_id:user_id isChat:true];
                    [_modelArray addObject:model];
                }
            }
            [[self tableView] reloadData];
           // NSString *firstname = [[response2.json valueForKey:@"first_name"] firstObject];
            //NSString *lastname = [[response2.json valueForKey:@"last_name"] firstObject];
           // NSString *nameVK = [NSString stringWithFormat:@"%@ %@", firstname, lastname];
            //cellModel *model = [[cellModel alloc] initWithName:nameVK imageName:@"avat.jpg" messege:messageVK];
            //[_modelArray addObject:model];
            
        } errorBlock:^(NSError *errorWithName) {
            NSLog(@"Error: %@", errorWithName);
        }
         ];
       // [[self tableView] reloadData];

        
        
        
        
        NSLog(@"SKR");
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
    mvC.isChat = model.isChat;
    [self.navigationController pushViewController:mvC animated:true];
 }


@end
