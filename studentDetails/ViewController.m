//
//  ViewController.m
//  studentDetails
//
//  Created by Priya on 15/05/15.
//  Copyright (c) 2015 Priya. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSArray *completePath;
    NSString *myPath, *thePath;
    NSFileManager *myfilemanager;
    NSString *registerno, *name, *total, *rank;
    char const *createQuery;
    char *error;
    NSMutableArray *myarray;
}

@end

@implementation ViewController
@synthesize registerNo,nameText,totalText,rankText,insertbutton,retrievebutton,registerNoDelete, deletebutton,updatebutton;

- (void)viewDidLoad {
    [super viewDidLoad];
    myarray=[[NSMutableArray alloc]init];
    thePath=[[self getPath] stringByAppendingPathComponent:@"studentTable.sqlite"];
    myfilemanager=[NSFileManager defaultManager];
    NSLog(@"%@",thePath);
    if (![myfilemanager fileExistsAtPath:thePath]) {
        createQuery ="create table if not exists students(RegisterNo integer primary key, Name text, Total integer, Rank integer)";
        if (sqlite3_open([thePath UTF8String], &database) == SQLITE_OK) {
            if (sqlite3_exec(database, createQuery, NULL, NULL, &error)== SQLITE_OK) {
                NSLog(@"Created successfully");
            }
        }
        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)insertbutton:(UIButton *)sender {
    if ((registerNo.text.length <1) || (nameText.text.length < 1) || (totalText.text.length < 1) || (rankText.text.length < 1)) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Enter All details" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
    if ([myfilemanager fileExistsAtPath:thePath]) {
        if (sqlite3_open([thePath UTF8String], &database)==SQLITE_OK) {
            NSString *insertQuery=[NSString stringWithFormat:@"insert into students(RegisterNo, Name, Total, Rank) values(\"%li\", \"%@\", \"%li\", \"%li\" )", [registerNo.text integerValue], nameText.text, [totalText.text integerValue],[rankText.text integerValue]];
            const char *insert_Query=[insertQuery UTF8String];
            if (sqlite3_prepare_v2(database, insert_Query, -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement)) {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Inserted Successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            sqlite3_reset(statement);
                                   
        }
    }
  }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex== 0) {
        registerNo.text=@"";
        nameText.text=@"";
        totalText.text=@"";
        rankText.text=@"";
        registerNoDelete.text=@"";

    }
}

- (IBAction)deletebutton:(UIButton *)sender {
    if ([myfilemanager fileExistsAtPath:thePath]) {
        if (sqlite3_open([thePath UTF8String], &database) == SQLITE_OK) {
            NSString *delete_query=[NSString stringWithFormat:@"delete from students where registerNo=%li",[registerNoDelete.text integerValue]];
            const char *deleteQuery=[delete_query UTF8String];
            if (sqlite3_prepare_v2(database, deleteQuery, -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_DONE) {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Deleted Successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
                sqlite3_reset(statement);
            }
        }
    }
    
}


- (IBAction)retrievebutton:(UIButton *)sender {
    if ([myfilemanager fileExistsAtPath:thePath]) {
        if (sqlite3_open([thePath UTF8String], &database)== SQLITE_OK) {
            NSString *retrieveQuery=[NSString stringWithFormat:@"select registerNo, Name, Total, Rank from students where registerNo = %li",[registerNoDelete.text integerValue] ];
            const char *retrieve_Query=[retrieveQuery UTF8String];
            if (sqlite3_prepare_v2(database, retrieve_Query, -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement)== SQLITE_ROW) {

                registerno=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                name=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                total=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                rank=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                registerNo.text=registerno;
                nameText.text=name;
                totalText.text=total;
                rankText.text=rank;
                    NSLog(@"RegisterNo: %@\nName: %@\nTotal: %@\n Rank: %@", registerno,name,total,rank);
                }
                sqlite3_reset(statement);
            }
        }
    }
}

- (IBAction)updatebutton:(UIButton *)sender {
    if ([myfilemanager fileExistsAtPath:thePath]) {
        if (sqlite3_open([thePath UTF8String], &database) == SQLITE_OK) {
            NSString *update_query=[NSString stringWithFormat:@"update students set registerNo=?, Name=?, Total=?, Rank=? where registerNo= ?"];
                const char *updateQuery=[update_query UTF8String];
            if (sqlite3_prepare_v2(database, updateQuery, -1, &statement, NULL)== SQLITE_OK) {
                sqlite3_bind_text(statement, 1, [registerNo.text UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 2, [nameText.text UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 3, [totalText.text UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [rankText.text UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 5, [registerNoDelete.text UTF8String], -1, SQLITE_TRANSIENT);
                if (sqlite3_step(statement) == SQLITE_DONE) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Updated Successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
                }
        sqlite3_reset(statement);
            }
        }
    }
}

-(NSString *)getPath
{
    completePath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    myPath=[completePath firstObject];
    return myPath;
}
@end
