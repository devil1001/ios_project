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
    
    self.title=[NSString stringWithFormat:@"%@", self.userID];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_modelArray.count-1 inSection:0];
    [_tableViewMessege scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
    
    //self.navigationController.navigationBar.description;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupModel{
    _modelArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<=20; i++) {
        messegeModel *model = [[messegeModel alloc] initMessege:[NSString stringWithFormat:@"messege"] sender:[NSString stringWithFormat:@"Ivan"]];
        [_modelArray addObject:model];
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
