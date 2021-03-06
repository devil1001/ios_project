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
#import <Realm/Realm.h>

@interface DialogHistory : RLMObject
@property NSString *message;
@property NSInteger id;
@property NSString *time;
@property NSInteger sender;
@end

@implementation DialogHistory
+ (NSString *) primaryKey {
    return @"id";
}
@end

@interface messegeViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_modelArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewMessege;
@property (weak, nonatomic) IBOutlet UITextField *messegeTextfield;
@property (strong, nonatomic) IBOutlet UIView *ScrollView;
@property (nonatomic) BOOL keybWillChange;

@end

@implementation messegeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _keybWillChange = false;
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
    [self loadFromRealm];
    [self loadMessages];
   // [self sendingPhoto];

}

- (void) loadMessages{
    [_modelArray removeAllObjects];
    _modelArray = [[NSMutableArray alloc] init];
    NSString *chat_id;
    if (self.isChat) {
        NSInteger iden = [self.userID integerValue] + 2000000000;
        chat_id = [NSString stringWithFormat:@"%ld", iden];
    }
    else {
        chat_id = self.userID;
    }
    VKRequest *req = [VKRequest requestWithMethod:@"messages.getHistory" parameters:@{VK_API_COUNT : @"20" ,  VK_API_USER_ID:chat_id}];
    [req executeWithResultBlock:^(VKResponse *response){
        DialogHistory *dialogHistory = [[DialogHistory alloc] init];
        NSInteger dialogsCount = [[response.json valueForKey:@"count"] integerValue];
        dialogsCount = [(NSArray *)[response.json valueForKey:@"items"] count];
        if (dialogsCount>=20){
            dialogsCount = 20;
        }
        for (int i = 0; i<dialogsCount; i++) {
            NSString *message = [[[response.json valueForKey:@"items" ] objectAtIndex:dialogsCount-i-1] valueForKey:@"body"];
            NSString *sender = [[[response.json valueForKey:@"items" ] objectAtIndex:dialogsCount-i-1] valueForKey:@"from_id"];
            NSString *time = [[[response.json valueForKey:@"items"] objectAtIndex:dialogsCount-i-1] valueForKey:@"date"];
            messegeModel *model = [[messegeModel alloc] initMessege:message sender:sender];
            [_modelArray addObject:model];
            dialogHistory.message = message;
            dialogHistory.id = [sender integerValue];
            dialogHistory.time = time;
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


- (void) loadFromRealm{
    [_modelArray removeAllObjects];
    _modelArray = [[NSMutableArray alloc] init];
    RLMResults *result = [[DialogHistory allObjects] sortedResultsUsingProperty:@"time" ascending:NO];
    NSUInteger count = [result count];
    for (int i = 0; i<count; i++) {
        NSString *sender = [[result objectAtIndex:i] valueForKey:@"id"];
        NSString *message = [[result objectAtIndex:i] valueForKey:@"message"];
        messegeModel *model = [[messegeModel alloc] initMessege:message sender:sender];
        [_modelArray addObject:model];
    }
    [_tableViewMessege reloadData];

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
        [_ScrollView endEditing:YES];
        
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
}

#pragma mark - keyboard


- (void)keyboardWillChange:(NSNotification *)notification
{
    if (_keybWillChange) {
        [UIView beginAnimations:nil context:nil];
        //[UIView setAnimationDuration:0.3];
        _ScrollView.frame = CGRectMake(_ScrollView.frame.origin.x, 0, _ScrollView.frame.size.width, _ScrollView.frame.size.height);
        [UIView commitAnimations];

        _keybWillChange = false;
        return;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _ScrollView.frame = CGRectMake(_ScrollView.frame.origin.x, -260, _ScrollView.frame.size.width, _ScrollView.frame.size.height);
    [UIView commitAnimations];
    _keybWillChange = true;
}





@end
