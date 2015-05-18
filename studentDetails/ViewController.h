//
//  ViewController.h
//  studentDetails
//
//  Created by Priya on 15/05/15.
//  Copyright (c) 2015 Priya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ViewController : UIViewController<UIAlertViewDelegate>
{
    sqlite3 *database;
    sqlite3_stmt *statement;
}
@property (strong, nonatomic) IBOutlet UITextField *registerNo;
@property (strong, nonatomic) IBOutlet UITextField *nameText;
@property (strong, nonatomic) IBOutlet UITextField *totalText;
@property (strong, nonatomic) IBOutlet UITextField *rankText;
@property (strong, nonatomic) IBOutlet UIButton *insertbutton;
@property (strong, nonatomic) IBOutlet UITextField *registerNoDelete;
@property (strong, nonatomic) IBOutlet UIButton *deletebutton;
@property (strong, nonatomic) IBOutlet UIButton *retrievebutton;
@property (strong, nonatomic) IBOutlet UIButton *updatebutton;


- (IBAction)insertbutton:(UIButton *)sender;

- (IBAction)deletebutton:(UIButton *)sender;
- (IBAction)retrievebutton:(UIButton *)sender;
- (IBAction)updatebutton:(UIButton *)sender;

@end

