//
//  ViewController.m
//  ios_project
//
//  Created by devil1001 on 22.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import "ViewController.h"
#import "vkTableViewController.h"

static NSString *const TOKEN_KEY = @"my_application_access_token";
static NSString *const NEXT_CONTROLLER_SEGUE_ID = @"authSegue";
static NSArray *SCOPE = nil;

@interface ViewController () <UIAlertViewDelegate, VKSdkUIDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];
    [super viewDidLoad];
    [[VKSdk initializeWithAppId:@"5715415"] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            [self startWorking];
        } else if (error) {
            //
        }
    }];
}

- (void)startWorking {
    VKRequest *req = [[VKApi users] get];
    [req executeWithResultBlock:^(VKResponse *response) {
        NSString *yourId = [[response.json firstObject] valueForKey:@"id"];
        UIStoryboard *storyBoard = [self storyboard];
        vkTableViewController *vkDialogView = [storyBoard instantiateViewControllerWithIdentifier:@"vkDIalogsVIew"];
        vkDialogView.yourId = yourId;
        [self.navigationController pushViewController:vkDialogView animated:true];
        //[self performSegueWithIdentifier:NEXT_CONTROLLER_SEGUE_ID sender:self];
    }
                     errorBlock:^(NSError *error){
                         NSLog(@"%@", error);
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)authorize:(id)sender {
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            [self startWorking];
        } else if (error) {
            //
        }
    }];
    [VKSdk authorize:SCOPE];
}




- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self.navigationController.topViewController];
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

- (void)vkSdkUserAuthorizationFailed {
    //
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self.navigationController.topViewController presentViewController:controller animated:YES completion:nil];
}


@end
