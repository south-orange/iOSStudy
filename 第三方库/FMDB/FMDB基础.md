## FMDB基础

[参考链接](https://www.jianshu.com/p/3682795d3f38)

### FMDB简介

FMDB是一个使用OC封装SQLite的C语言API框架

使用面向对象的方式，省去了C语言代码

比Core Data更加轻量级和灵活

提供了多线程安全的数据库操作方式

### FMDB的使用

#### 读取数据库文件

```
  NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  NSString *dbFilePath = [document stringByAppendingPathComponent:@"datas.db"];
  FMDatabase *fmdb = [FMDatabase databaseWithPath:dbFilePath];
  if ([fmdb open]) {
      NSLog(@"open success");
  } else {
      NSLog(@"open failed");
  }
```

#### 执行SQL语句

```
  BOOL createTableSuccess = [fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS test_table (id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL);"];
  if (createTableSuccess) {
      NSLog(@"create table success");
  } else {
      NSLog(@"create table failed");
  }

  BOOL insertSuccess = [fmdb executeUpdate:@"INSERT INTO test_table (name) VALUES (?)", @"test"];
  if (insertSuccess) {
      NSLog(@"insert success");
  } else {
      NSLog(@"insert failed");
  }
  FMResultSet *resultSet = [fmdb executeQuery:@"SELECT * FROM test_table;"];
  while (resultSet.next) {
    NSLog(@"%@, %@", [resultSet objectForColumnIndex:0], [resultSet objectForColumn:@"name"]);
  }
```
