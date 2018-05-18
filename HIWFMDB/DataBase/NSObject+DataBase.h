//
//  NSObject+DataBase.h
//  FMDBDemo
//
//  Created by 彭伟 on 16/3/3.
//  Copyright © 2016年 彭伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DataBase)
//生成创建表的sql语句
- (NSString *)createTableSql;
//删除指定表
- (NSString *)deleteTableSql;
//清空表
- (NSString *)emptyTable;

//增加字段
- (NSString *)addRowSqlWithRowName:(NSString *)propertyName;
//删除字段
- (NSString *)deleteRowWithRowName:(NSString *)propertyName;

#pragma mark - 插入操作
- (NSString *)insertItemSql;
- (NSString *)insertItemEqualPropertyNameArray:(NSArray *)equalPropertyNameArray notEqualPropertyNameArray:(NSArray *)notEqualPropertyNameArray;

#pragma mark - 删除操作
- (NSString *)deleteAllItemSql;
- (NSString *)deleteItemEqualPropertyNameArray:(NSArray *)equalPropertyNameArray notEqualPropertyNameArray:(NSArray *)notEqualPropertyNameArray;

#pragma mark - 更新操作
- (NSString *)updateSetValuesArray:(NSArray *)valuesArray equalPropertyNameArray:(NSArray *)equalArray notEqualPropertyNameArray:(NSArray *)notEqualArray;
- (NSString *)updateRowProperty:(NSString *)propertyName toValue:(id)toValue;

- (NSString *)updateRowProperty:(NSString *)propertyName toValue:(id)toValue equalPropertyNameArray:(NSArray *)equalArray;

#pragma mark - 查找操作
//查找所有
- (NSString*)selectAllItems;

//查找指定的数据
- (NSString*)selectItemEqualPropertyNameArray:(NSArray*)propertyNameArray notEqualPropertyNameArray:(NSArray*)notEqualArray;

//升序降序，按照某个属性去排序
- (NSString*)selectItemEqualPropertyNameArray:(NSArray *)propertyNameArray notEqualPropertyNameArray:(NSArray *)notEqualArray orderByPropertyName:(NSString*)propertyName isAsc:(BOOL)isAsc;

//查找某一列的和
- (NSString*)selectItemPropertySum:(NSString*)propertyName equalPropertyNameArray:(NSArray*)equalArray notEqualArray:(NSArray*)notEqualArray;

//查找全部数据的条数
- (NSString*)selectItemCountEqualArray:(NSArray*)equalArray notEqualArray:(NSArray*)notEqualArray;

//根据某个属性的多个值进行查找
- (NSString *)selectItemEqualPropertyName:(NSString *)propertyName valuesArray:(NSArray *)valuesArray;

@end
