//
//  DataBase.m
//  FMDBDemo
//
//  Created by 彭伟 on 16/3/3.
//  Copyright © 2016年 彭伟. All rights reserved.
//
#define DataBasePath @"toper.db"
#import "DataBase.h"
@interface DataBase()

@property (nonatomic,strong) FMDatabaseQueue *dataBaseQueue;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation DataBase

+ (NSString *)customerDataBasePath:(NSString *)dataBaseName
{
    NSString *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dataPath = [documentDirectory stringByAppendingPathComponent:dataBaseName];
    return dataPath;
}

+ (instancetype)shareDataBase
{
    static dispatch_once_t onceToken;
    static id _shareObject = nil;
    dispatch_once(&onceToken, ^{
        _shareObject = [[self alloc] init];
    });
    return _shareObject;
}

- (instancetype)init
{
    if (self = [super init]) {
        _dataBaseQueue = [[FMDatabaseQueue alloc] initWithPath:[DataBase customerDataBasePath:DataBasePath]];
        _queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
        NSLog(@"数据库path %@",[DataBase customerDataBasePath:DataBasePath]);
    }
    return self;
}

- (FMDatabaseQueue *)dataBaseQueue
{
    return _dataBaseQueue;
}

- (dispatch_queue_t)queue
{
    return _queue;
}


- (void)createTableWithItemArray:(NSArray *)itemsArray completionBlock:(completionBlock)block
{
    __block BOOL isSuccess = YES;
    for (id item in itemsArray) {
        [_dataBaseQueue inDatabase:^(FMDatabase *db) {
            NSString *createSql = [item createTableSql];
            if ([db executeUpdate:createSql]) {
                NSLog(@"建表%@成功", [item objectName]);
            }else{
                NSLog(@"建表%@失败", [item objectName]);
                isSuccess = NO;
            }
        }];
    }
    
    if (block) {
        block(isSuccess);
    }
}

- (void)deleteTableWithItemArray:(NSArray *)itemsArray completionBlock:(completionBlock)block
{
    __block BOOL isSuccess = YES;
    for (id item in itemsArray) {
        [_dataBaseQueue inDatabase:^(FMDatabase *db) {
            NSString *deleteSql = [item deleteTableSql];
            if ([db executeUpdate:deleteSql]) {
                NSLog(@"删表%@成功", [item objectName]);
            }else{
                NSLog(@"删表%@失败", [item objectName]);
                isSuccess = NO;
            }
        }];
    }
    
    if (block) {
        block(isSuccess);
    }
}

- (void)emptyTable:(id)item completionBlcok:(completionBlock)block
{
    __block BOOL isSuccess = YES;
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        NSString *emptySql = [item emptyTable];
        if ([db executeUpdate:emptySql]) {
            
        }else{
            isSuccess = NO;
        }
    }];
    if (block) {
        block(isSuccess);
    }
}

- (void)addRowForItem:(id)item propertyNameArray:(NSArray *)nameArray completionBlock:(completionBlock)block
{
    __block BOOL isSuccess = YES;
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        for (NSString *propertyName in nameArray) {
            NSString *addRowSql = [item addRowSqlWithRowName:propertyName];
            if ([db executeUpdate:addRowSql]) {
                
            }else{
                isSuccess = NO;
            }

        }
    }];
    if (block) {
        block(isSuccess);
    }

}

- (void)deleteRowForItem:(id)item propertyNameArray:(NSArray *)nameArray completionBlock:(completionBlock)block
{
    __block BOOL isSuccess = YES;
    [_dataBaseQueue inDatabase:^(FMDatabase *db) {
        for (NSString *propertyName in nameArray) {
            NSString *deleteRowSql = [item deleteRowWithRowName:propertyName];
            if ([db executeUpdate:deleteRowSql]) {
                
            }else{
                isSuccess = NO;
            }
        }
    }];
    if (block) {
        block(isSuccess);
    }

}
@end
