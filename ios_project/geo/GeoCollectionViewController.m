//
//  GeoCollectionViewController.m
//  ios_project
//
//  Created by devil1001 on 13.12.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import "GeoCollectionViewController.h"
#import <VKSdk.h>
#import "GeoModel.h"
#import "GeoCell.h"

@interface GeoCollectionViewController () <UICollectionViewDelegate ,UICollectionViewDataSource> {
    NSMutableArray *_modelArray;
}

@end

@implementation GeoCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self getPhotos];
    
    // Do any additional setup after loading the view.
}

- (void) getPhotos {
    [_modelArray removeAllObjects];
    _modelArray = [[NSMutableArray alloc]init];
    VKRequest *req = [VKRequest requestWithMethod:@"photos.search" parameters:@{@"lat": @"60", @"long": @"60", @"radius": @"5000"}];
    [req executeWithResultBlock:^(VKResponse *response){
        NSInteger count;
        if ([[response.json valueForKey:@"count"] integerValue]<15) {
            count = [[response.json valueForKey:@"count"] integerValue];
        }
        else {
            count = 15;
        }
        for (int i=0; i<count; i++) {
            NSString *imageName = [[[response.json valueForKey:@"items"]objectAtIndex:i] valueForKey:@"photo_75"];
            GeoModel *model = [[GeoModel alloc] initWithImageName: imageName];
            [_modelArray addObject:model];
        }
        [[self collectionView] reloadData];
        
    }errorBlock:^(NSError *error){
        NSLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GeoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GeoImage" forIndexPath:indexPath];
    GeoModel *model;
    if ([_modelArray[indexPath.row] isMemberOfClass:[GeoModel class]]) {
        model = _modelArray[indexPath.row];
        [cell fillCellWithImage:model];
    }
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
