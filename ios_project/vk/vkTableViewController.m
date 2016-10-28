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

@interface vkTableViewController ()
{
    NSMutableArray *_modelArray;
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
    for (int i = 0; i<20; i++) {
        cellModel *model = [[cellModel alloc] initWithName:[NSString stringWithFormat:@"Ivan Ivanov%d", i] imageName:@"avat.jpg" messege:[NSString stringWithFormat:@"messege"]];
        [_modelArray addObject:model];
    }
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
    mvC.userID = model.name;
    NSLog(@"%@", mvC.userID);
    [self.navigationController pushViewController:mvC animated:true];
 }


@end
