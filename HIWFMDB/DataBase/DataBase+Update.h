//
//  DataBase+Update.h
//  FMDBDemo
//
//  Created by 彭伟 on 16/8/22.
//  Copyright © 2016年 彭伟. All rights reserved.
//

#import "DataBase.h"

typedef void (^updateCompletionBlock)(BOOL isSuccess);

@interface DataBase (Update)
//更新，传入属性的名字列表，前提是这个属性对应的值是有的
- (void)updateItem:(id)item setPropertyNameArray:(NSArray*)setArray equalProperNameArray:(NSArray*)equalArray completionBlock:(updateCompletionBlock)block;

//更新,传入相等的属性  不相等的属性
- (void)updateItem:(id)item setPropertyNameArray:(NSArray*)setArray equalProperNameArray:(NSArray *)equalArray notEqualPropertyNameArray:(NSArray*)notEqualArray completionBlock:(updateCompletionBlock)block;

//更新数组
- (void)updateItems:(NSArray*)items setPropertyNameArray:(NSArray*)setArray equalArray:(NSArray*)equalArray completionBlock:(updateCompletionBlock)block;

//更新数组
- (void)updateItems:(NSArray *)items setPropertyNameArray:(NSArray*)setArray equalArray:(NSArray *)equalArray notEqualArray:(NSArray*)notEqualArray completionBlock:(updateCompletionBlock)block;

//更新表中某一列的所有数据，toValue是最终的值
- (void)updateItem:(id)item rowPropertyName:(NSString *)propertyName  toValue:(id)toValue completionBlock:(updateCompletionBlock)block;

//更新，传入设置的sql语句，根据查找
- (void)updateItem:(id)item rowPropertyName:(NSString *)propertyName  toValue:(id)toValue equalProperNameArray:(NSArray*)equalArray completionBlock:(updateCompletionBlock)block;

@end
