//
//  ViewController.m
//  FMDBDemo
//
//  Created by wepie on 2021/4/7.
//

#import "ViewController.h"
#import <FMDatabase.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbFilePath = [document stringByAppendingPathComponent:@"datas.db"];
    FMDatabase *fmdb = [FMDatabase databaseWithPath:dbFilePath];
    if ([fmdb open]) {
        NSLog(@"open success");
    } else {
        NSLog(@"open failed");
    }
    
//    BOOL insertSuccess = [fmdb executeUpdate:@"INSERT INTO test_table (name) VALUES (?)", @"test"];
//    if (insertSuccess) {
//        NSLog(@"insert success");
//    } else {
//        NSLog(@"insert failed");
//    }
    
    FMResultSet *resultSet = [fmdb executeQuery:@"SELECT * FROM test_table;"];
    while (resultSet.next) {
        NSLog(@"%@, %@", [resultSet objectForColumnIndex:0], [resultSet objectForColumn:@"name"]);
    }
    
}


@end
