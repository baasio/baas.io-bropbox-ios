//
//  BoxListViewController+.m
//  BropBox
//
//  Created by cetauri on 12. 9. 18..
//  Copyright (c) 2012년 kth. All rights reserved.
//

#import "BoxListViewController.h"

@interface BoxListViewController ()    {
    UITableView *_tableView ;
}
@end

@implementation BoxListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Bropbox";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];

        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49  - 44);
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return self;
}
							

#pragma mark UITableViewDelegate

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return [NSArray arrayWithArray:@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]];
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 200;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
//    footerView.backgroundColor = [UIColor clearColor];
//
//    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    loginButton.frame = CGRectMake(10, 10, 300, 44);
//    [loginButton setTitle:@"BropBox에 로그인" forState:UIControlStateNormal];
//    [loginButton addTarget:self action:@selector(signInButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    loginButton.enabled = false;
//    loginButton.tag = 3;
//    [footerView addSubview:loginButton];
//
//    UIButton *signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    signUpButton.frame = CGRectMake(10, 50, 300, 44);
//    signUpButton.titleLabel.font = [UIFont systemFontOfSize:13.];
//    [signUpButton setTitle:@"▶ BropBox 처음 사용함. (계정생성)" forState:UIControlStateNormal];
//    [signUpButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [signUpButton addTarget:self action:@selector(signUpButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:signUpButton];
//
//    return footerView;
//}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"listCell";

    UITableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (listCell == nil) {
        listCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
//
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 44)];
//        label.backgroundColor = [UIColor clearColor];
//        label.tag = 1;
//        [loginCell addSubview:label];
//
//        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 200, 44)];
//        field.delegate = self;
//
//        field.backgroundColor = [UIColor clearColor];
//        field.tag = 20 + indexPath.row;
//
//        if (indexPath.row == 1){
//            field.secureTextEntry = YES;
//        }
//
//        field.placeholder = @"필수 입력 항목";
//
//        [loginCell addSubview:field ];
    }

//    UILabel *label = (UILabel*)[loginCell viewWithTag:1];
//    UITextField *field = (UITextField*)[loginCell viewWithTag:2 + indexPath.row];
//    field.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    switch (indexPath.row){
//        case 0:
//            label.text = @"아이디";
//            break;
//        case 1:
//            label.text = @"암호";
//            break;
//    }
    listCell.imageView.image = [UIImage imageNamed:@"directory-icon.png"];
    listCell.textLabel.text = [NSString stringWithFormat:@"%i-111" , indexPath.row];
    listCell.textLabel.font = [UIFont boldSystemFontOfSize:17.];
    NSLog(@"%@", listCell.textLabel.font.description);
    return listCell;
}
@end
