//
//  DataBase+Select.m
//  FMDBDemo
//
//  Created by 彭伟 on 16/8/22.
//  Copyright © 2016年 彭伟. All rights reserved.
//

#import "DataBase+Select.h"

@implementation DataBase (Select)
//查找所有的数据模型
- (void)selectAllItems:(id)item selectCompletionBlock:(selectArrayCompletionBlock)block
{
    [self selectAllItems:item equalPropertyNameArray:nil notEqualPropertyNameArray:nil selectCompletionBlock:block];
}

- (void)selectAllItems:(id)item equalPropertyNameArray:(NSArray*)equalArray notEqualPropertyNameArray:(NSArray*)notEqualArray selectCompletionBlock:(selectArrayCompletionBlock)block
{
    __block NSMutableArray *resultArray=[NSMutableArray arrayWithCapacity:0];
    dispatch_async([self queue], ^{
        [[self dataBaseQueue] inDatabase:^(FMDatabase *db) {
            
            NSString *selectAllSql=[item selectItemEqualPropertyNameArray:equalArray notEqualPropertyNameArray:notEqualArray];
            
            FMResultSet *rs=[db executeQuery:selectAllSql];
            
            NSMutableArray *propertyNameArray=[item objectPropertyNameList];
            while ([rs next]) {
                id tempItem=[[[item class] alloc] init];
                
                for (NSString *propertyName in propertyNameArray) {
                    
                    id value=[rs objectForColumnName:propertyName];
                    
                    [tempItem setValue:value forKey:propertyName];
                }
                
                [resultArray addObject:tempItem];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                block(resultArray);
            });
            
        }];
        
    });
    
}

//查找某个字段多值的数据模型
- (void)selectItems:(id)item equalPropertyName:(NSString *)propertyName valuesArray:(NSArray *)valuesArray selectCompletionBlock:(selectArrayCompletionBlock)block
{
    __block NSMutableArray *resultArray=[NSMutableArray arrayWithCapacity:0];
    
    dispatch_async([self queue], ^{
        
        [[self dataBaseQueue] inDatabase:^(FMDatabase *db) {
            NSString *selectInSql = [item selectItemEqualPropertyName:propertyName valuesArray:valuesArray];
            FMResultSet *rs = [db executeQuery:selectInSql];
            NSMutableArray *propertyNameArray=[item objectPropertyNameList];
            while ([rs next]) {
                id tempItem=[[[item class] alloc] init];
                
                for (NSString *propertyName in propertyNameArray) {
                    
                    id value=[rs objectForColumnName:propertyName];
                    
                    [tempItem setValue:value forKey:propertyName];
                }
                
                [resultArray addObject:tempItem];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                block(resultArray);
            });
            
        }];
    });
}

//查找指定的数据模型
- (void)selectItem:(id)item equalPropertyNameArray:(NSArray*)equalArray notEqualPropertyNameArray:(NSArray*)notEqualArray selectCompletionBlock:(selectItemCompletionBlock)block
{
    dispatch_async([self queue], ^{
        [[self dataBaseQueue] inDatabase:^(FMDatabase *db) {
            
            NSString *selectAllSql=[item selectItemEqualPropertyNameArray:equalArray notEqualPropertyNameArray:notEqualArray];
            FMResultSet *rs=[db executeQuery:selectAllSql];
            
            NSMutableArray *propertyNameArray=[item objectPropertyNameList];
            
            if ([rs next]) {
                id tempItem=[[[item class] alloc] init];
                
                for (NSString *propertyName in propertyNameArray) {
                    
                    id value=[rs objectForColumnName:propertyName];
                    
                    [tempItem setValue:value forKey:propertyName];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(tempItem);
                });
                
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(nil);
                });
            }
        }];
    });
    
}

//查找某一列的和
- (void)selectItemPropertyCount:(id)item propertyName:(NSString*)propertyName equalArray:(NSArray*)keyArray notEqualArray:(NSArray*)notEqualArray selectCompletionBlock:(selectItemPropertyCountCompletionBlock)block
{
    __block int messageCount=0;
    dispatch_async([self queue], ^{
        [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
            
            NSString *selectSql=[item selectItemPropertySum:propertyName equalPropertyNameArray:keyArray notEqualArray:notEqualArray];
            
            messageCount=[db intForQuery:selectSql];
            dispatch_async(dispatch_get_main_queue(), ^{
                block(messageCount);
            });
        }];
        
    });
    
}

//某个模型是否存在
- (void)selectIsExitItem:(id)item equalPropertyNameArray:(NSArray*)equalArray notEqualPropertyNameArray:(NSArray*)notEqualArray completionBlock:(selectIsExitItemCompletionBlock)block
{
    dispatch_async([self queue], ^{
        [[self dataBaseQueue] inDatabase:^(FMDatabase *db) {
            
            NSString *selectAllSql=[item selectItemEqualPropertyNameArray:equalArray notEqualPropertyNameArray:notEqualArray];
            FMResultSet *rs=[db executeQuery:selectAllSql];
            
            if ([rs next]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(YES);
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(NO);
                });
            }
        }];
    });
    
}

//查找指定模型的数量
- (void)selectItemCount:(id)item equalPropertyNameArray:(NSArray*)equalArray notEqualPropertyNameArray:(NSArray*)notEqualArray completionBlock:(selectItemCountCompletionBlock)block
{
    __block int itemCount=0;
    dispatch_async([self queue], ^{
        [[self dataBaseQueue] inDatabase:^(FMDatabase *db) {
            
            NSString *selectCountSql=[item selectItemCountEqualArray:equalArray notEqualArray:notEqualArray];
            
            itemCount=[db intForQuery:selectCountSql];
            dispatch_async(dispatch_get_main_queue(), ^{
                block(itemCount);
            });
        }];
        
    });
    
}

//根据属性去排序
- (void)selectItems:(id)item equalPropertyNameArray:(NSArray*)equalArray notEqualPropertyNameArray:(NSArray*)notEqualArray orderByPropertyName:(NSString*)propertyName isAsc:(BOOL)isAsc completionBlock:(selectArrayCompletionBlock)block
{
    __block NSMutableArray *resultArray=[NSMutableArray arrayWithCapacity:0];
    dispatch_async([self queue], ^{
        [[self dataBaseQueue] inDatabase:^(FMDatabase *db) {
            
            NSString *selectAllSql=[item selectItemEqualPropertyNameArray:equalArray notEqualPropertyNameArray:notEqualArray orderByPropertyName:propertyName isAsc:isAsc];
            
            FMResultSet *rs=[db executeQuery:selectAllSql];
            
            NSMutableArray *propertyNameArray=[item objectPropertyNameList];
            while ([rs next]) {
                id tempItem=[[[item class] alloc] init];
                
                for (NSString *propertyName in propertyNameArray) {
                    
                    id value=[rs objectForColumnName:propertyName];
                    
                    [tempItem setValue:value forKey:propertyName];
                }
                
                [resultArray addObject:tempItem];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                block(resultArray);
            });
        }];
        
    });
    
}

@end
