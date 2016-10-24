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

@interface vkTableViewController ()
{
    NSMutableArray *_modelArray;
}
@end

@implementation vkTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupModel];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void) setupModel{
    _modelArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<20; i++) {
        cellModel *model = [[cellModel alloc] initWithName:[NSString stringWithFormat:@"Ivan Ivanov"] imageName:@"avat.png" messege:[NSString stringWithFormat:@"messege"]];
        [_modelArray addObject:model];
    }
    
}

/* - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
} */

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



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
