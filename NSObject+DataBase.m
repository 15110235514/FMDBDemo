//
//  NSObject+DataBase.m
//  FMDBDemo
//
//  Created by 彭伟 on 16/3/3.
//  Copyright © 2016年 彭伟. All rights reserved.
//

#import "NSObject+DataBase.h"
#import <objc/runtime.h>
#import "NSObject+KeyValue.h"
@implementation NSObject (DataBase)

- (NSString *)createTableSql
{
    
    NSString *tableName = [NSString stringWithFormat:@"%@Table",[self objectName]];
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exist %@ (%@)", tableName, [self propertyNameTypeJoinString]];
    return createTableSql;
}

- (NSString *)deleteTableSql
{
    NSString *tableName = [NSString stringWithFormat:@"%@Table", [self objectName]];
    NSString *delTableSql = [NSString stringWithFormat:@"drop table if exist %@", tableName];
    return delTableSql;
}

- (NSString *)emptyTable
{
    NSString *tableName = [NSString stringWithFormat:@"%@Table", [self objectName]];
    NSString *emptySql = [NSString stringWithFormat:@"delete from %@", tableName];
    return emptySql;
}

- (NSString *)addRowSqlWithRowName:(NSString *)propertyName
{
    NSString *tableName = [NSString stringWithFormat:@"%@Table", [self objectName]];
    NSString *addRowSql = [NSString stringWithFormat:@"alert table %@ add column %@", tableName, [self propertyNameType:propertyName]];
    return addRowSql;
}

- (NSString *)deleteRowWithRowName:(NSString *)propertyName
{
    NSString *tableName = [NSString stringWithFormat:@"%@Table", [self objectName]];
    NSString *delRowSql = [NSString stringWithFormat:@"alert table %@ drop column %@", tableName, [self propertyNameType:propertyName]];
    return delRowSql;
}

#pragma mark - 插入操作
//不去重
- (NSString *)insertItemSql
{
    NSString *tableName = [NSString stringWithFormat:@"%@Table", [self objectName]];
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (%@) values (%@)", tableName, [self propertyNameTypeJoinString], [self propertyValueJoinString]];
    return insertSql;
}

//去重
- (NSString *)insertItemEqualPropertyNameArray:(NSArray *)equalPropertyNameArray notEqualPropertyNameArray:(NSArray *)notEqualPropertyNameArray
{
    if (equalPropertyNameArray == nil && notEqualPropertyNameArray == nil) {
        return [self insertItemSql];
    }
    NSString *tableName = [NSString stringWithFormat:@"%@Table", [self objectName]];
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (%@) values (%@) where %@", tableName, [self propertyNameTypeJoinString], [self propertyValueJoinString], [self conditionJoinStringWithEqualPropertyNameArrya:equalPropertyNameArray notEqualPropertyNameArray:notEqualPropertyNameArray]];
    return insertSql;
}

#pragma mark - 删除操作
//删除整张表的数据
- (NSString *)deleteAllItemSql
{
    NSString *tableName = [NSString stringWithFormat:@"%@Table", [self objectName]];
    NSString *sql = [NSString stringWithFormat:@"delete from %@", tableName];
    
    return sql;
}

//条件删除语句
- (NSString *)deleteItemEqualPropertyNameArray:(NSArray *)equalPropertyNameArray notEqualPropertyNameArray:(NSArray *)notEqualPropertyNameArray
{
    NSString *tableName = [NSString stringWithFormat:@"%@Table", [self objectName]];
    
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@", tableName, [self conditionJoinStringWithEqualPropertyNameArrya:equalPropertyNameArray notEqualPropertyNameArray:notEqualPropertyNameArray]];
    
    return deleteSql;
}

#pragma mark - 更新操作
//更新操作
- (NSString *)updateSetValuesArray:(NSArray *)valuesArray equalPropertyNameArray:(NSArray *)equalArray notEqualPropertyNameArray:(NSArray *)notEqualArray
{
    NSString *tableName = [NSString stringWithFormat:@"%@Table", [self objectName]];
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@ where %@", tableName, [self setValueSql:valuesArray], [self conditionJoinStringWithEqualPropertyNameArrya:equalArray notEqualPropertyNameArray:notEqualArray]];
    return sql;
}

//更新某一列的所有数据
- (NSString *)updateRowProperty:(NSString *)propertyName toValue:(id)toValue
{
    NSString *tableName = [NSString stringWithFormat:@"%@Table", [self objectName]];
    NSMutableDictionary *propertyTypeList = [self objectPropertyTypeList];
    NSString *toValueStr = nil;
    NSString *type = [propertyTypeList objectForKey:propertyName];
    if ([type isEqualToString:@"NSString"]) {
        toValueStr = [NSString stringWithFormat:@"'%@'", toValue];
    }else{
        toValueStr = [NSString stringWithFormat:@"%@", toValue];
    }
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@ = %@", tableName, propertyName, toValueStr];
    return sql;
}

//根据条件查找更新某一列的值
- (NSString *)updateRowProperty:(NSString *)propertyName toValue:(id)toValue equalPropertyNameArray:(NSArray *)equalArray
{
    NSString *tableName = [NSString stringWithFormat:@"%@Table", [self objectName]];
    NSMutableDictionary *propertyTypeList = [self objectPropertyTypeList];
    NSString *toValueStr = nil;
    NSString *type = [propertyTypeList objectForKey:propertyName];
    if ([type isEqualToString:@"NSString"]) {
        toValueStr = [NSString stringWithFormat:@"'%@'", toValue];
    }else{
        toValueStr = [NSString stringWithFormat:@"%@", toValue];
    }
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@ = %@ where %@", tableName, propertyName, toValueStr, [self conditionJoinStringWithEqualPropertyNameArrya:equalArray notEqualPropertyNameArray:nil]];
    return sql;
}

#pragma mark - 查找操作
- (NSString *)selectAllItems
{
    NSString *tableName = [NSString stringWithFormat:@"%@Table", [self objectName]];
    NSString *sql = [NSString stringWithFormat:@"select * from %@", tableName];
    return sql;
}

- (NSString *)selectItemEqualPropertyNameArray:(NSArray *)propertyNameArray notEqualPropertyNameArray:(NSArray *)notEqualArray
{
    if (propertyNameArray == nil && notEqualArray == nil) {
        [self selectAllItems];
    }
    NSString *tableName = [NSString stringWithFormat:@"%@Table", [self objectName]];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@", tableName, [self conditionJoinStringWithEqualPropertyNameArrya:propertyNameArray notEqualPropertyNameArray:notEqualArray]];
    return sql;
}

- (NSString *)selectItemEqualPropertyName:(NSString *)propertyName valuesArray:(NSArray *)valuesArray
{
    if (propertyName == nil) {
        [self selectAllItems];
    }
    NSString *tableName = [NSString stringWithFormat:@"%@Table", [self objectName]];
    NSString *inSql = [NSString stringWithFormat:@"(%@)", [self conditionJoinStringWithPropertyName:propertyName valuesArray:valuesArray]];
    if (inSql) {
        return [NSString stringWithFormat:@"select * from %@ where %@ in %@", tableName, propertyName, inSql];
    }
    return nil;
}


- (NSString *)selectItemEqualPropertyNameArray:(NSArray *)propertyNameArray notEqualPropertyNameArray:(NSArray *)notEqualArray orderByPropertyName:(NSString *)propertyName isAsc:(BOOL)isAsc
{
    NSString *orderString = isAsc ? @"asc" : @"desc";
    NSString *tableName = [NSString stringWithFormat:@"%@Table", [self objectName]];
    if (propertyNameArray == nil && notEqualArray == nil) {
        return [self selectAllItemsOrderByPropertyName:propertyName isAsc:orderString];
    }
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ order by %@ %@", tableName, [self conditionJoinStringWithEqualPropertyNameArrya:propertyNameArray notEqualPropertyNameArray:notEqualArray], propertyName, orderString];
    
    return sql;
}

- (NSString *)selectAllItemsOrderByPropertyName:(NSString *)propertyName isAsc:(NSString *)orderString
{
    NSString *tableName = [NSString stringWithFormat:@"%@Table", [self objectName]];
    NSString *sql = [NSString stringWithFormat:@"select * from %@ order by %@ %@", tableName, propertyName, orderString];
    return sql;
}

- (NSString *)selectItemPropertySum:(NSString *)propertyName equalPropertyNameArray:(NSArray *)equalArray notEqualArray:(NSArray *)notEqualArray
{
    NSString *tableName = [NSString stringWithFormat:@"%@Table", [self objectName]];
    NSString *sql = [NSString stringWithFormat:@"select sum(%@) from %@ where %@", propertyName, tableName, [self conditionJoinStringWithEqualPropertyNameArrya:equalArray notEqualPropertyNameArray:notEqualArray]];
    return sql;
}

- (NSString *)selectItemCountEqualArray:(NSArray *)equalArray notEqualArray:(NSArray *)notEqualArray
{
    NSString *tableName = [NSString stringWithFormat:@"%@Table", [self objectName]];
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where %@", tableName, [self conditionJoinStringWithEqualPropertyNameArrya:equalArray notEqualPropertyNameArray:notEqualArray]];
    return sql;
}

#pragma mark - 业务流程
//IN条件查询SQL
- (NSString *)conditionJoinStringWithPropertyName:(NSString *)propertyName valuesArray:(NSArray *)values
{
    if (propertyName == nil || values == nil) {
        return nil;
    }
    NSMutableString *str = [NSMutableString string];
    NSMutableDictionary *propertyTypeList = [self objectPropertyTypeList];
    NSString *type = [propertyTypeList objectForKey:propertyName];
    int i = 0;
    NSUInteger count = values.count;
    if ([type isEqualToString:@"NSString"]) {
        for (id value in values) {
            NSString *tempStr = [NSString stringWithFormat:@"'%@'", value];
            if (i == count - 1) {
                [str appendString:[NSString stringWithFormat:@"%@", tempStr]];
            }else{
                [str appendString:[NSString stringWithFormat:@"%@,", tempStr]];
            }
            i++;
        }
    }else{
        for (id value in values) {
            NSString *tempStr = [NSString stringWithFormat:@"%@", value];
            if (i == count - 1) {
                [str appendString:[NSString stringWithFormat:@"%@", tempStr]];
            }else{
                [str appendString:[NSString stringWithFormat:@"%@,", tempStr]];
            }
            i++;
        }
    }
    return str;
}

//更新属性值
- (NSString *)setValueSql:(NSArray *)valuesArray
{
    NSMutableString *str = [NSMutableString string];
    NSMutableDictionary *propertyTypeDict = [self objectPropertyTypeList];
    int i = 0;
    NSUInteger count = valuesArray.count;
    for (NSString *propertyName in valuesArray) {
        if (i == count - 1) {
            [str appendString:[NSString stringWithFormat:@"%@ = %@", propertyName, [self conditionJoinStringWithPropertyName:propertyName propertyTypeDict:propertyTypeDict]]];
        }else{
            [str appendString:[NSString stringWithFormat:@"%@ = %@,", propertyName, [self conditionJoinStringWithPropertyName:propertyName propertyTypeDict:propertyTypeDict]]];
        }
        i++;
    }
    return str;
}

//获取条件组合
- (NSString *)conditionJoinStringWithEqualPropertyNameArrya:(NSArray *)equalPropertyNameArray notEqualPropertyNameArray:(NSArray *)notEqualPropertyNameArray
{
    NSMutableString *str = [NSMutableString string];
    
    NSMutableDictionary *propertyTypeList = [self objectPropertyTypeList];
    
    
    
    if (equalPropertyNameArray == nil) {
        
    }else{
        
        NSUInteger count = equalPropertyNameArray.count;
        int i = 0;
        for (NSString *propertyName in equalPropertyNameArray) {
            
            if (i == count - 1) {
                [str appendString:[NSString stringWithFormat:@"%@=%@",propertyName, [self conditionJoinStringWithPropertyName:propertyName propertyTypeDict:propertyTypeList]]];
            }else{
                [str appendString:[NSString stringWithFormat:@"%@=%@ and",propertyName, [self conditionJoinStringWithPropertyName:propertyName propertyTypeDict:propertyTypeList]]];
            }
            i++;
        }
    }
    
    if (notEqualPropertyNameArray == nil) {
        
    }else{
        
        NSUInteger count = notEqualPropertyNameArray.count;
        int i = 0;
        
        for (NSString *propertyName in equalPropertyNameArray) {
            
            if (i == count - 1) {
                [str appendString:[NSString stringWithFormat:@"%@!=%@",propertyName, [self conditionJoinStringWithPropertyName:propertyName propertyTypeDict:propertyTypeList]]];
                
            }else{
                if (str.length == 0) {
                    [str appendString:[NSString stringWithFormat:@"%@!=%@ and",propertyName, [self conditionJoinStringWithPropertyName:propertyName propertyTypeDict:propertyTypeList]]];
                }else{
                    [str appendString:[NSString stringWithFormat:@"and %@!=%@ and",propertyName, [self conditionJoinStringWithPropertyName:propertyName propertyTypeDict:propertyTypeList]]];
                }
            }
            i++;
        }
        
    }
    return str;
}
//获取属性对应的值（类型判断）
- (NSString *)conditionJoinStringWithPropertyName:(NSString *)propertyName propertyTypeDict:(NSMutableDictionary *)propertyTypeList
{
    id value = [self valueForKey:propertyName];
    NSString *type = [propertyTypeList objectForKey:propertyTypeList];
    if ([type isEqualToString:@"NSString"]) {
        return [NSString stringWithFormat:@"'%@'", value];
    }else{
        return [NSString stringWithFormat:@"%@", value];
    }
    return nil;
}


//获取所有属性值的字符串组合
- (NSString *)propertyValueJoinString
{
    NSMutableString *str = [NSMutableString string];
    NSMutableArray *propertyNameList = [self objectPropertyNameList];
    NSMutableDictionary *propertyTypeDict = [self objectPropertyTypeList];
    int i = 0;
    NSUInteger count = propertyNameList.count;
    for (NSString *propertyName in propertyNameList) {
        NSString *tempStr = nil;
        id value = [self valueForKey:propertyName];
        if ([[propertyTypeDict objectForKey:propertyName] isEqualToString:@"NSString"]) {
            value = [NSString stringWithFormat:@"'%@'", value];
        }
        if (i == count - 1) {
            tempStr = [NSString stringWithFormat:@"%@", value];
        }else{
            tempStr = [NSString stringWithFormat:@"%@,", value];
        }
        [str appendString:tempStr];
        i++;
    }
    return str;
    
}

//获取所有属性名字字符串组合
- (NSString *)propertyNameJoinString
{
    NSMutableString *str = [NSMutableString string];
    NSMutableArray *propertyNameList = [self objectPropertyNameList];
    int i = 0;
    NSUInteger count = propertyNameList.count;
    for (NSString *propertyName in propertyNameList) {
        NSString *tempStr = nil;
        if (i == count - 1) {
            tempStr = propertyName;
        }else{
            tempStr = [NSString stringWithFormat:@"%@,", propertyName];
        }
        [str appendString:tempStr];
        i++;
    }
    return str;
}

//获取属性名字和类型组合
- (NSString *)propertyNameType:(NSString *)propertyName
{
    NSMutableDictionary *propertyTypeDict = [self objectPropertyTypeList];
    NSString *type = [self objectTypeString:[propertyTypeDict objectForKey:propertyName]];
    NSString *propertyNameType = [NSString stringWithFormat:@"%@ %@", propertyName, type];
    return propertyNameType;
}


//属性名字和类型
- (NSString *)propertyNameTypeJoinString
{
    NSMutableString *str = [NSMutableString string];
    NSMutableArray *propertyNameList = [self objectPropertyNameList];
    NSMutableDictionary *propertyTypeDict = [self objectPropertyTypeList];
    int i = 0;
    NSUInteger count = propertyNameList.count;
    for (NSString *propertyName in propertyNameList) {
        NSString *type = [self objectTypeString:[propertyTypeDict objectForKey:propertyName]];
        NSString *tempStr = nil;
        if (i == count - 1) {
            tempStr = [NSString stringWithFormat:@"%@ %@", propertyName, type];
        }else{
            tempStr = [NSString stringWithFormat:@"%@ %@,", propertyName, type];
        }
        [str appendString:tempStr];
        i++;
    }
    return str;
}

//值的类型
- (NSString*)objectTypeString:(NSString*)valueType
{
    if ([valueType isEqualToString:@"NSString"]) {
        return @"text";
    }else if ([valueType isEqualToString:@"f"]){
        return @"float";
    }else if ([valueType isEqualToString:@"q"]){
        return @"integer";
    }else if ([valueType isEqualToString:@"NSNumber"]){
        return @"number";
    }else if ([valueType isEqualToString:@"NSData"]){
        return @"binary";
    }else if ([valueType isEqualToString:@"NSDate"]){
        return @"time";
    }else if ([valueType isEqualToString:@"B"]){
        return @"boolean";
    }else if([valueType isEqualToString:@"i"]){
        return @"integer";
    }else if([valueType isEqualToString:@"c"]){
        return @"boolean";
    }else if([valueType isEqualToString:@"d"]){
        return @"double";
    }else if ([valueType isEqualToString:@"l"]){
        return @"integer";
    }
    return nil;
}

@end

