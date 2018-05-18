//
//  DataBase.h
//  FMDBDemo
//
//  Created by 彭伟 on 16/3/3.
//  Copyright © 2016年 彭伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "NSObject+DataBase.h"
#import "NSObject+KeyValue.h"

typedef void(^completionBlock)(BOOL isSuccess);

@interface DataBase : NSObject

//单例
+ (instancetype)shareDataBase;

//返回数据库操作手柄
- (FMDatabaseQueue *)dataBaseQueue;
//解决嵌套操作的崩溃问题
- (dispatch_queue_t)queue;

//建表，根据传入数据模型
- (void)createTableWithItemArray:(NSArray *)itemsArray completionBlock:(completionBlock)block;

//删表，根据传入数据模型
- (void)deleteTableWithItemArray:(NSArray *)itemsArray completionBlock:(completionBlock)block;

//增加表字段，字段名放到数组里面
- (void)addRowForItem:(id)item propertyNameArray:(NSArray *)nameArray completionBlock:(completionBlock)block;

//删除表字段，字段名放到数组里面
- (void)deleteRowForItem:(id)item propertyNameArray:(NSArray *)nameArray completionBlock:(completionBlock)block;

//清除表
- (void)emptyTable:(id)item completionBlcok:(completionBlock)block;

@end
