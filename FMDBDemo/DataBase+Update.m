//
//  DataBase+Update.m
//  FMDBDemo
//
//  Created by 彭伟 on 16/8/22.
//  Copyright © 2016年 彭伟. All rights reserved.
//

#import "DataBase+Update.h"

@implementation DataBase (Update)

//更新，传入属性的名字列表，前提是这个属性对应的值是有的
- (void)updateItem:(id)item setPropertyNameArray:(NSArray*)setArray equalProperNameArray:(NSArray*)equalArray completionBlock:(updateCompletionBlock)block
{
    [self updateItem:item setPropertyNameArray:setArray equalProperNameArray:equalArray notEqualPropertyNameArray:nil completionBlock:block];
}


//更新,传入相等的属性  不相等的属性
- (void)updateItem:(id)item setPropertyNameArray:(NSArray*)setArray equalProperNameArray:(NSArray *)equalArray notEqualPropertyNameArray:(NSArray*)notEqualArray completionBlock:(updateCompletionBlock)block
{
    dispatch_async([self queue], ^{
        [[self dataBaseQueue] inDatabase:^(FMDatabase *db) {
            
            NSString *updateSql=[item updateSetValuesArray:setArray equalPropertyNameArray:equalArray notEqualPropertyNameArray:notEqualArray];
            if ([db executeUpdate:updateSql]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block?  block(YES) : nil;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    block?  block(NO) : nil;
                });
            }
        }];
        
    });
}


- (void)updateItems:(NSArray *)items setPropertyNameArray:(NSArray*)setArray equalArray:(NSArray *)equalArray completionBlock:(updateCompletionBlock)block
{
    [self updateItems:items setPropertyNameArray:(NSArray*)setArray equalArray:equalArray notEqualArray:nil completionBlock:block];
}


- (void)updateItems:(NSArray *)items setPropertyNameArray:(NSArray*)setArray equalArray:(NSArray *)equalArray notEqualArray:(NSArray *)notEqualArray completionBlock:(updateCompletionBlock)block
{
    dispatch_async([self queue], ^{
        [[self dataBaseQueue] inDatabase:^(FMDatabase *db) {
            
            [db beginTransaction];
            
            BOOL isRollBack=NO;
            @try {
                for (id item in items) {
                    NSString *updateSql=[item updateSetValuesArray:setArray equalPropertyNameArray:equalArray notEqualPropertyNameArray:notEqualArray];
                    [db executeUpdate:updateSql];
                }
            }
            @catch (NSException *exception) {
                isRollBack=YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    block?  block(NO) : nil;
                });
                [db rollback];
            }
            @finally {
                if (!isRollBack) {
                    if ([db commit]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block?  block(YES) : nil;
                        });
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            block?  block(NO) : nil;
                        });
                    }
                }
            }
        }];
        
    });
}

//更新表中某一列的所有数据，toValue是最终的值
- (void)updateItem:(id)item rowPropertyName:(NSString *)propertyName  toValue:(id)toValue completionBlock:(updateCompletionBlock)block
{
    dispatch_async([self queue], ^{
        [[self dataBaseQueue] inDatabase:^(FMDatabase *db) {
            
            NSString *updateRowSql=[item updateRowProperty:propertyName toValue:toValue];
            if ([db executeUpdate:updateRowSql]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block?  block(YES) : nil;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    block?  block(NO) : nil;
                });
            }
        }];
        
    });
}

//更新，传入设置的sql语句，根据查找
- (void)updateItem:(id)item rowPropertyName:(NSString *)propertyName  toValue:(id)toValue equalProperNameArray:(NSArray*)equalArray completionBlock:(updateCompletionBlock)block;
{
    dispatch_async([self queue], ^{
        [[self dataBaseQueue] inDatabase:^(FMDatabase *db) {
            
            NSString *updateSql=[item updateRowProperty:propertyName toValue:toValue equalPropertyNameArray:equalArray];
            
            if ([db executeUpdate:updateSql]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block?  block(YES) : nil;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    block?  block(NO) : nil;
                });
            }
        }];
    });
}

@end
