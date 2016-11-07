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
    _modelArray = [[NSMutableArray alloc] init];
    if (self.isChat) {
        NSInteger iden = [self.userID integerValue] + 2000000000;
        NSString *chat_id = [NSString stringWithFormat:@"%ld", iden];
        VKRequest *req = [VKRequest requestWithMethod:@"messages.getHistory" parameters:@{VK_API_COUNT : @"20" , VK_API_USER_ID:chat_id}];
        [req executeWithResultBlock:^(VKResponse *response){
            for (int i = 0; i<20; i++) {
                NSString *message = [NSString stringWithFormat:@"%@", [[[response.json valueForKey:@"items" ] objectAtIndex:19-i] valueForKey:@"body"]];
                NSString *sender = [NSString stringWithFormat:@"%@", [[[response.json valueForKey:@"items" ] objectAtIndex:19-i] valueForKey:@"from_id"]];
                messegeModel *model = [[messegeModel alloc] initMessege:message sender:sender];
                [_modelArray addObject:model];
            }
            [_tableViewMessege reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_modelArray.count-1 inSection:0];
            [_tableViewMessege scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
        }
                         errorBlock:^(NSError *errorWithName) {
                             NSLog(@"Error: %@", errorWithName);
                         }
         ];
    }
    else {
        VKRequest *req = [VKRequest requestWithMethod:@"messages.getHistory" parameters:@{VK_API_COUNT : @"20" , VK_API_USER_ID:self.userID}];
        [req executeWithResultBlock:^(VKResponse *response){
            for (int i = 0; i<20; i++) {
                NSString *message = [[[response.json valueForKey:@"items" ] objectAtIndex:19-i] valueForKey:@"body"];
                NSString *sender = [[[response.json valueForKey:@"items" ] objectAtIndex:19-i] valueForKey:@"from_id"];
                messegeModel *model = [[messegeModel alloc] initMessege:message sender:sender];
                [_modelArray addObject:model];
            }
            [_tableViewMessege reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_modelArray.count-1 inSection:0];
            [_tableViewMessege scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
            
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
        [cell fillCellWithMessege:model];
    }
    return cell;
}

- (IBAction)sendMessegeClicked:(UIButton *)sender {
    if (_messegeTextfield!= nil) {
    
        messegeModel *model = [[messegeModel alloc] initMessege:[NSString stringWithFormat:@"%@", _messegeTextfield.text] sender:[NSString stringWithFormat:@"You"]];
        [_modelArray addObject:model];
        [_tableViewMessege reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_modelArray.count-1 inSection:0];
        [_tableViewMessege scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
        _messegeTextfield.text = nil;
        
    }
    
    
}

@end
