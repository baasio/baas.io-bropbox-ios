//
//  SignUpViewController.m
//  BropBox
//
//  Created by cetauri on 10/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignInViewController.h"
#import <baas.io/Baas.h>

@interface SignUpViewController ()  {
    UITableView *_tableView ;
}

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"회원가입";

        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return self;
}

#pragma mark - event

- (void)signUpButtonPressed
{
    UITextField *idField = (UITextField *)[self.view viewWithTag:20];
    UITextField *passwdField = (UITextField *)[self.view viewWithTag:21];
    UITextField *emailField = (UITextField *)[self.view viewWithTag:22];
    UITextField *nameField = (UITextField *)[self.view viewWithTag:23];
    [BaasioUser signUpInBackground:idField.text
                          password:passwdField.text
                              name:nameField.text
                             email:emailField.text
                      successBlock:^(void){
                          
                          //회원가입 성공
                          UITextField *idField = (UITextField *)[self.view viewWithTag:20];
                          UITextField *passwdField = (UITextField *)[self.view viewWithTag:21];
                          
                          
                          [BaasioUser signInBackground:idField.text
                                              password:passwdField.text
                                          successBlock:^(void){
                                              
                                              [[NSNotificationCenter defaultCenter] postNotificationName:APP_LOGIN_FINISH_NOTIFICATION object:nil];
                                              
                                          }
                                          failureBlock:^(NSError *error){
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"로그인에 실패하였습니다.\n다시 시도해주세요."
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                              
                                          }];
                          
                      }
                      failureBlock:^(NSError *error){
                          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"회원가입에 실패하였습니다.\n다시 시도해주세요."
                                                                              message:error.localizedDescription
                                                                             delegate:nil
                                                                    cancelButtonTitle:@"OK"
                                                                    otherButtonTitles:nil];
                          [alertView show];
                          
                      }];
    
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    footerView.backgroundColor = [UIColor clearColor];

    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(10, 10, 300, 44);
    [loginButton setTitle:@"무료 계정 생성" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(signUpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    loginButton.enabled = false;
    loginButton.tag = 3;
    [footerView addSubview:loginButton];

    return footerView;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self checkButtonEnable];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self checkButtonEnable];
}

- (BOOL)checkButtonEnable
{
    UITextField *idField = (UITextField *)[self.view viewWithTag:20];
    UITextField *passwdField = (UITextField *)[self.view viewWithTag:21];
    UITextField *emailField = (UITextField *)[self.view viewWithTag:22];
    UITextField *nameField = (UITextField *)[self.view viewWithTag:23];

    UIButton *button = (UIButton*)[self.view viewWithTag:3];

    if (![idField.text isEqualToString:@""] && ![passwdField.text isEqualToString:@""] &&! [emailField.text isEqualToString:@""] && ![nameField.text isEqualToString:@""]){
        button.enabled = YES;
    } else{
        button.enabled = NO;
    }

    return button.enabled;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    int tag = textField.tag;
    UIView *view = [self.view viewWithTag:(tag+1)];
    if(view != nil){
        [view becomeFirstResponder];
    } else{
        if ([self checkButtonEnable]){
            [self signUpButtonPressed];
        }
    }

    return YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"loginCell";

    UITableViewCell *loginCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (loginCell == nil) {
        loginCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 1;
        [loginCell addSubview:label];

        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 200, 44)];
        field.delegate = self;

        field.backgroundColor = [UIColor clearColor];
        field.tag = 20 + indexPath.row;

        field.autocapitalizationType = UITextAutocapitalizationTypeNone;
        switch (indexPath.row){
            case 0:
                label.text = @"아이디";
                field.placeholder = @"test";

                break;
            case 1:
                field.secureTextEntry = YES;
                label.text = @"암호";
                field.placeholder = @"필수 입력 항목";
                break;
            case 2:
                label.text = @"E-Mail";
                field.placeholder = @"test@baas.io";
                break;
            case 3:
                label.text = @"이름";
                field.placeholder = @"홍길동";
                break;
        }

        [loginCell addSubview:field ];
    }

    return loginCell;
}

@end
