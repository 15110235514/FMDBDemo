//
//  DataBase+Select.h
//  FMDBDemo
//
//  Created by 彭伟 on 16/8/22.
//  Copyright © 2016年 彭伟. All rights reserved.
//

#import "DataBase.h"

typedef void (^selectArrayCompletionBlock)(NSMutableArray *selectArray);

typedef void (^selectItemCompletionBlock)(id item);

typedef void (^selectItemCountCompletionBlock) (int count);

typedef void (^selectItemPropertyCountCompletionBlock)(int count);

typedef void (^selectIsExitItemCompletionBlock)(BOOL isExit);


@interface DataBase (Select)

//查找所有的数据模型
- (void)selectAllItems:(id)item selectCompletionBlock:(selectArrayCompletionBlock)block;
//查找符合条件的所有数据v
- (void)selectAllItems:(id)item equalPropertyNameArray:(NSArray*)equalArray notEqualPropertyNameArray:(NSArray*)notEqualArray selectCompletionBlock:(selectArrayCompletionBlock)block;

//查找指定的数据模型
- (void)selectItem:(id)item equalPropertyNameArray:(NSArray*)equalArray notEqualPropertyNameArray:(NSArray*)notEqualArray selectCompletionBlock:(selectItemCompletionBlock)block;

//查找某一列的和
- (void)selectItemPropertyCount:(id)item propertyName:(NSString*)propertyName equalArray:(NSArray*)keyArray notEqualArray:(NSArray*)notEqualArray selectCompletionBlock:(selectItemPropertyCountCompletionBlock)block;

//某个模型是否存在
- (void)selectIsExitItem:(id)item equalPropertyNameArray:(NSArray*)equalArray notEqualPropertyNameArray:(NSArray*)notEqualArray completionBlock:(selectIsExitItemCompletionBlock)block;

//查找指定模型的数量
- (void)selectItemCount:(id)item equalPropertyNameArray:(NSArray*)equalArray notEqualPropertyNameArray:(NSArray*)notEqualArray completionBlock:(selectItemCountCompletionBlock)block;

//查找指定的数据模型，并且按照某个属性去排序，是升序还是降序
- (void)selectItems:(id)item equalPropertyNameArray:(NSArray*)equalArray notEqualPropertyNameArray:(NSArray*)notEqualArray orderByPropertyName:(NSString*)propertyName isAsc:(BOOL)isAsc completionBlock:(selectArrayCompletionBlock)block;

//查找某个字段多值的数据模型
- (void)selectItems:(id)item equalPropertyName:(NSString *)propertyName valuesArray:(NSArray *)valuesArray selectCompletionBlock:(selectArrayCompletionBlock)block;
@end
