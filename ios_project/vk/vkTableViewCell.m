//
//  vkTableViewCell.m
//  ios_project
//
//  Created by devil1001 on 24.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import "vkTableViewCell.h"
#import "cellModel.h"

@interface vkTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellName;
@property (weak, nonatomic) IBOutlet UILabel *cellMessege;

@end

@implementation vkTableViewCell
//NSString * const kFilename = @"avat.jpg";

- (void)fillCellWithModel:(cellModel *)model {
    //self.cellImageView.image = [UIImage imageNamed:kFilename];
    //self.cellImageView.image = [UIImage imageWithContentsOfFile:model.imageName];
   // [self startDownload:model.imageName];
    [self probLoad:model.imageName];
    self.cellName.text = model.name;
    self.cellMessege.text = model.messege;
    [self layoutIfNeeded];
    self.cellImageView.layer.masksToBounds = YES;
    self.cellImageView.layer.cornerRadius = self.cellImageView.frame.size.width / 1.75;//25.f;
}

- (void) probLoad:(NSString *)url {
    self.imageView.image = nil;
    NSURL *url2 = [NSURL URLWithString:url];
    NSData *data = [NSData dataWithContentsOfURL:url2];
    UIImage *img = [[UIImage alloc] initWithData:data];
    self.cellImageView.image=img;
}

/*- (void) startDownload:(NSString *)url {
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSURL* downloadTaskURL = [NSURL URLWithString:url];
    [[session downloadTaskWithURL: downloadTaskURL
                completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                    
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    
                    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
                    NSURL *documentsDirectory = [urls objectAtIndex:0];
                    
                    NSURL *originalUrl = [NSURL URLWithString:[downloadTaskURL lastPathComponent]];
                    NSURL *destinationUrl = [documentsDirectory URLByAppendingPathComponent:[originalUrl lastPathComponent]];
                    NSError *fileManagerError;
                    
                    [fileManager removeItemAtURL:destinationUrl error:NULL];
                    //ключевая  строчка!
                    [fileManager copyItemAtURL:location toURL:destinationUrl error:&fileManagerError];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *stringPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                        NSString *fullURLString  = [stringPath stringByAppendingPathComponent:kFilename];
                        self.cellImageView.image = [UIImage imageWithContentsOfFile:fullURLString];;

                    });
                }] resume];
    
}
 */


@end
