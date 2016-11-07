//
//  startNavViewController.m
//  ios_project
//
//  Created by devil1001 on 07.11.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import "startNavViewController.h"

static NSString *const TOKEN_KEY = @"my_application_access_token";
static NSString *const NEXT_CONTROLLER_SEGUE_ID = @"vkShow";
static NSArray *SCOPE = nil;


@interface startNavViewController () <UIAlertViewDelegate, VKSdkUIDelegate>

@end

@implementation startNavViewController

- (void)viewDidLoad {
    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];
    [super viewDidLoad];
    [[VKSdk initializeWithAppId:@"5696268"] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            [self startWorking];
        } else if (error) {
            NSLog(@"%@", error);
        }
        [VKSdk authorize:SCOPE];
        //[self startWorking];
    }];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)startWorking {
    [self performSegueWithIdentifier:NEXT_CONTROLLER_SEGUE_ID sender:self];
}

- (IBAction)authorize:(id)sender {
    [VKSdk authorize:SCOPE];
}
- (void)vkSdkUserAuthorizationFailed {
    //
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self.navigationController.topViewController presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
    [self authorize:nil];
}

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.token) {
        [self startWorking];
    } else if (result.error) {
        //
    }
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self.navigationController.topViewController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
