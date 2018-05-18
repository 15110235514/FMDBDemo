//
//  DataBase+insert.m
//  FMDBDemo
//
//  Created by 彭伟 on 16/3/8.
//  Copyright © 2016年 彭伟. All rights reserved.
//

#import "DataBase+insert.h"
@implementation DataBase (insert)

- (void)insertItemNotRepeat:(id)item keyPropertyNameArray:(NSArray *)keyPropertyNameArray completionBlock:(insertCompletionBlock)block
{
    dispatch_async([self queue], ^{
        [[self dataBaseQueue] inDatabase:^(FMDatabase *db) {
            NSString *selectSql = [item selectItemCountEqualArray:keyPropertyNameArray notEqualArray:nil];
            NSInteger count = [db intForQuery:selectSql];
            if (count) {
                //数据库已存在此条数据，就更新
                NSString *updateSql = [item updateSetValuesArray:[item objectPropertyNameList] equalPropertyNameArray:keyPropertyNameArray notEqualPropertyNameArray:nil];
                if ([db executeUpdate:updateSql]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(YES);
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(NO);
                    });
                }
            }else{
                NSString *insertSql = [item insertItemSql];
                if ([db executeUpdate:insertSql]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(YES);
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(NO);
                    });
                }
            }
        }];
    });
}

- (void)insertItemCanRepeat:(id)item completionBlock:(insertCompletionBlock)block
{
    dispatch_async([self queue], ^{
        [[self dataBaseQueue] inDatabase:^(FMDatabase *db) {
            NSString *insertSql = [item insertItemSql];
            if ([db executeUpdate:insertSql]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(YES);
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(NO);
                });
            }
        }];
    });
}

- (void)insertItemsNotRepeat:(NSArray *)itemsArray keyPropertyNameArray:(NSArray *)keyPropertyArray completionBlock:(insertCompletionBlock)block
{
    dispatch_async([self queue], ^{
        [[self dataBaseQueue] inDatabase:^(FMDatabase *db) {
            [db beginTransaction];
            BOOL isRollBack = NO;
            
            @try {
                for (id item in itemsArray) {
                    NSString *selectSql = [item selectItemCountEqualArray:keyPropertyArray notEqualArray:nil];
                    NSInteger count = [db intForQuery:selectSql];
                    if (count) {
                        NSString *updateSql = [item updateSetValuesArray:[item objectPropertyNameList] equalPropertyNameArray:keyPropertyArray notEqualPropertyNameArray:nil];
                        [db executeUpdate:updateSql];
                    }else{
                        NSString *insertSql = [item insertItemSql];
                        [db executeUpdate:insertSql];
                    }
                }
                
            } @catch (NSException *exception) {
                isRollBack = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(NO);
                });
                [db rollback];
                
            } @finally {
                if ([db commit]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(YES);
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(NO);
                    });
                }
            }
        }];
    });
}

- (void)insertItemsCanRepeat:(NSArray *)itemsArray completionBlock:(insertCompletionBlock)block
{
    dispatch_async([self queue], ^{
        [[self dataBaseQueue] inDatabase:^(FMDatabase *db) {
            [db beginTransaction];
            BOOL isRollBack = NO;
            
            @try {
                for (id item in itemsArray) {
                    NSString *insertSql = [item insertItemSql];
                    [db executeUpdate:insertSql];
                }
                
            } @catch (NSException *exception) {
                isRollBack = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(NO);
                });
                [db rollback];
                
            } @finally {
                if ([db commit]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(YES);
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(NO);
                    });
                }
            }
        }];
    });
}

- (void)insertItemsNotRepeat:(NSArray *)itemsArray keyPropertyNameArray:(NSArray *)keyPropertyNameArray updateValueArray:(NSArray *)updateValueArray completionBlock:(insertCompletionBlock)block
{
    dispatch_async([self queue], ^{
        [[self dataBaseQueue] inDatabase:^(FMDatabase *db) {
            [db beginTransaction];
            BOOL isRollBack = NO;
            
            @try {
                for (id item in itemsArray) {
                    NSString *selectSql = [item selectItemCountEqualArray:keyPropertyNameArray notEqualArray:nil];
                    NSInteger count = [db intForQuery:selectSql];
                    if (count) {
                        NSString *updateSql = [item updateSetValuesArray:updateValueArray equalPropertyNameArray:keyPropertyNameArray notEqualPropertyNameArray:nil];
                        [db executeUpdate:updateSql];
                    }else{
                        NSString *insertSql = [item insertItemSql];
                        [db executeUpdate:insertSql];
                    }
                }
                
            } @catch (NSException *exception) {
                isRollBack = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(NO);
                });
                [db rollback];
                
            } @finally {
                if ([db commit]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(YES);
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(NO);
                    });
                }
            }
        }];
    });
}




@end
