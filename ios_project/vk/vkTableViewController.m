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
#import <Realm/Realm.h>
#import "ViewController.h"



@interface DialogsBase : RLMObject
@property NSString *message;
@property NSInteger id;
@property NSString *photoName;
@property NSString *name;
@property NSString *time;
@property BOOL isChat;
@end

@implementation DialogsBase
+ (NSString *) primaryKey {
    return @"id";
}
@end


static NSArray *SCOPE = nil;

@interface vkTableViewController () <UIAlertViewDelegate, VKSdkUIDelegate>
{
    NSMutableArray *_modelArray;
    NSMutableArray *_userArray;
    NSMutableArray *_messageArray;
    NSMutableArray *_chatArray;
    NSMutableArray *_timeArray;
}
@property (nonatomic) BOOL isRefreshing;
@property (nonatomic) BOOL isReactDownload;
@end

@implementation vkTableViewController

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self.navigationController.topViewController];
}


- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.token) {
        [self startWorking];
    } else if (result.error) {
        //
    }
}

- (void)startWorking {
    VKRequest *req = [[VKApi users] get];
    [req executeWithResultBlock:^(VKResponse *response) {
        NSString *yourId = [[response.json firstObject] valueForKey:@"id"];
        self.yourId = yourId;
        [self downloadFromRealm];
        [self setupModel];
    }
                     errorBlock:^(NSError *error){
                         NSLog(@"%@", error);
                     }];
}

- (void)vkSdkUserAuthorizationFailed {
    //
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self.navigationController.topViewController presentViewController:controller animated:YES completion:nil];
}

- (void)viewDidLoad {
    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];
    [super viewDidLoad];
    [[VKSdk initializeWithAppId:@"5715415"] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state != VKAuthorizationAuthorized) {
            //UIStoryboard *storyBoard = [self storyboard];
            //ViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"login"];
            [self performSegueWithIdentifier:@"login" sender:self];
            //[self.navigationController ]
        }
        [self startWorking];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void) setupModel{
    _isRefreshing = true;
    [self getDialogs];
}

- (void) getDialogs{

    VKRequest *req = [VKRequest requestWithMethod:@"messages.getDialogs" parameters:@{VK_API_COUNT : @"20"}];
    [req executeWithResultBlock:^(VKResponse *response){
        [_modelArray removeAllObjects];
        [_userArray removeAllObjects];
        [_messageArray removeAllObjects];
        [_chatArray removeAllObjects];
        [_timeArray removeAllObjects];
        _modelArray = [[NSMutableArray alloc] init];
        _messageArray = [[NSMutableArray alloc] init];
        _userArray = [[NSMutableArray alloc] init];
        _chatArray = [[NSMutableArray alloc] init];
        _timeArray = [[NSMutableArray alloc] init];
        NSInteger dialogsCount = [[response.json valueForKey:@"count"] integerValue];
        if (dialogsCount>=15) {
            dialogsCount = 15;
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
            NSString *time = [NSString stringWithFormat:@"%@", [[[[response.json valueForKey:@"items"] objectAtIndex:i] valueForKey:@"message"] valueForKey:@"date"]];
            [_timeArray addObject:time];
        }
        if (([_userArray count]!=0)&&([_timeArray count] !=0)&&([_messageArray count]!=0)) {
        
        VKRequest *req1 = [[VKApi users] get:@{VK_API_FIELDS : @"first_name, last_name, photo_50", VK_API_USER_IDS : [_userArray valueForKey:@"id"]}];
        [req1 executeWithResultBlock: ^(VKResponse *response2) {
            DialogsBase *dialogBase = [[DialogsBase alloc] init];
            for (int i=0; i<dialogsCount; i++) {
                if ([[[_userArray objectAtIndex:i] valueForKey:@"title" ] isEqual: @" ... "]){
                    NSString *firstname = [[response2.json valueForKey:@"first_name"] objectAtIndex:i];
                    NSString *lastname = [[response2.json valueForKey:@"last_name"] objectAtIndex:i];
                    NSString *name = [NSString stringWithFormat:@"%@ %@", firstname, lastname];
                    NSString *user_id = [[response2.json valueForKey:@"id"] objectAtIndex:i];
                    NSString *avat = [[response2.json valueForKey:@"photo_50"] objectAtIndex:i];
                    cellModel *model = [[cellModel alloc] initWithName:name imageName:avat messege:[_messageArray objectAtIndex:i] user_id:user_id is_Chat:false];
                    [_modelArray addObject:model];
                    dialogBase.photoName = avat;
                    dialogBase.id = [user_id integerValue];
                    dialogBase.message = [_messageArray objectAtIndex:i];
                    dialogBase.name = name;
                    dialogBase.time = [_timeArray objectAtIndex:i];
                    dialogBase.isChat = false;
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    [realm beginWriteTransaction];
                    [DialogsBase createOrUpdateInRealm:realm withValue:dialogBase];
                    [realm commitWriteTransaction];
                }
                else {
                    NSString *name = [[_userArray objectAtIndex:i] valueForKey:@"title"];
                    NSString *user_id = [[response2.json valueForKey:@"id"] objectAtIndex:i];
                    NSString *avat = [[response2.json valueForKey:@"photo_50"] objectAtIndex:i];
                    cellModel *model = [[cellModel alloc] initWithName:name imageName:avat messege:[_messageArray objectAtIndex:i] user_id:user_id is_Chat:true];
                    [_modelArray addObject:model];
                    dialogBase.photoName = avat;
                    dialogBase.id = [user_id integerValue];
                    dialogBase.message = [_messageArray objectAtIndex:i];
                    dialogBase.time = [_timeArray objectAtIndex:i];
                    dialogBase.name = name;
                    dialogBase.isChat = true;
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    [realm beginWriteTransaction];
                    [DialogsBase createOrUpdateInRealm:realm withValue:dialogBase];
                    [realm commitWriteTransaction];
                }
            }
                _isRefreshing = false;
                [[self tableView] reloadData];
        } errorBlock:^(NSError *errorWithName) {
            NSLog(@"Error: %@", errorWithName);
        }
         ];
        }
    } errorBlock:^(NSError *error){
        NSLog(@"Error: %@", error);
        [self downloadFromRealm];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

- (IBAction)RefreshTable:(id)sender {
    if (!_isRefreshing) {
        _isRefreshing = true;
        [_modelArray removeAllObjects];
        [_userArray removeAllObjects];
        [_messageArray removeAllObjects];
        [_chatArray removeAllObjects];
        [_timeArray removeAllObjects];
        [self getDialogs];
        [[self tableView] reloadData];
        [self downloadFromRealm];
    }
        UIRefreshControl *refresh = (UIRefreshControl*)sender;
        [refresh endRefreshing];
//        is_refreshing = true;
  //  }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    vkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIndeficator" forIndexPath:indexPath];
    cellModel *model;
    if (([_modelArray[indexPath.row] isMemberOfClass:[cellModel class]])&&(!_isReactDownload||!_isRefreshing)) {
        model = _modelArray[indexPath.row];
        [cell fillCellWithModel:model];
    }
    return cell;
}


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

- (void) downloadFromRealm {
    _isReactDownload = true;
    [_modelArray removeAllObjects];
    _modelArray = [[NSMutableArray alloc] init];
    RLMResults *result = [[DialogsBase allObjects] sortedResultsUsingProperty:@"time" ascending:NO];
    //NSLog(@"%@", result);
    NSUInteger count = [result count];
    for (int i = 0; i<count; i++) {
        NSString *user_id = [[result objectAtIndex:i] valueForKey:@"id"];
        NSString *name = [[result objectAtIndex:i] valueForKey:@"name"];
        NSString *message = [[result objectAtIndex:i] valueForKey:@"message"];
        NSString *photo = [[result objectAtIndex:i] valueForKey:@"photoName"];
        cellModel *model = [[cellModel alloc] initWithName:name imageName:photo messege:message user_id:user_id is_Chat:NO];
        [_modelArray addObject:model];
    }
    _isReactDownload = false;
    [[self tableView] reloadData];
    
    //NSLog(@"%ld", count);
}

@end
