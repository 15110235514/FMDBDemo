//
//  DataBase+Delete.m
//  FMDBDemo
//
//  Created by 彭伟 on 16/8/22.
//  Copyright © 2016年 彭伟. All rights reserved.
//

#import "DataBase+Delete.h"

@implementation DataBase (Delete)

- (void)deleteItem:(id)item equalPropertyNameArray:(NSArray *)equalArray commpletionBlock:(deleteCompletionBlock)block
{
    [self deleteItem:item equalPropertyNameArray:equalArray notEqualPropertyNameArray:nil completionBlock:block];
}

- (void)deleteItem:(id)item equalPropertyNameArray:(NSArray *)equalArray notEqualPropertyNameArray:(NSArray *)notEqualArray completionBlock:(deleteCompletionBlock)block
{
    dispatch_async(self.queue, ^{
        [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
            NSString *delSql = [item deleteItemEqualPropertyNameArray:equalArray notEqualPropertyNameArray:notEqualArray];
            if ([db executeUpdate:delSql]) {
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


- (void)deleteItems:(NSArray *)itemsArray equalPropertyNameArray:(NSArray *)equalArray notEqualPropertyNameArray:(NSArray *)notEqualArray completionBlock:(deleteCompletionBlock)block
{
    dispatch_async(self.queue, ^{
        [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
            [db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                for (id item in itemsArray) {
                    NSString *delSql = [item deleteItemEqualPropertyNameArray:equalArray notEqualPropertyNameArray:notEqualArray];
                    [db executeUpdate:delSql];
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
