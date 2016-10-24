//
//  vkEntry.m
//  ios_project
//
//  Created by devil1001 on 24.10.16.
//  Copyright © 2016 devil1001. All rights reserved.
//

#import "vkEntry.h"
#import "loginModel.h"

@interface vkEntry ()
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) loginModel *model;

@end

@implementation vkEntry

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[loginModel alloc] init];
    // Do any additional setup after loading the view.
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
- (IBAction)loginButtonPressed:(id)sender {
    self.model.login = self.loginTextField.text;
    self.model.password = self.passwordTextField.text;
    _passwordTextField.text = [NSString stringWithFormat:@"%@%@", self.model.login, self.model.password];
}

@end
