//
//  DataBase+insert.h
//  FMDBDemo
//
//  Created by 彭伟 on 16/3/8.
//  Copyright © 2016年 彭伟. All rights reserved.
//

#import "DataBase.h"

typedef void(^insertCompletionBlock)(BOOL isSuccess);

@interface DataBase (insert)

//插入数据。去重
- (void)insertItemNotRepeat:(id)item keyPropertyNameArray:(NSArray *)keyPropertyNameArray completionBlock:(insertCompletionBlock)block;

//插入数据，不去重
- (void)insertItemCanRepeat:(id)item completionBlock:(insertCompletionBlock)block;

//插入数组，去重
- (void)insertItemsNotRepeat:(NSArray *)itemsArray keyPropertyNameArray:(NSArray *)keyPropertyArray completionBlock:(insertCompletionBlock)block;

//插入数组，不去重
- (void)insertItemsCanRepeat:(NSArray *)itemsArray completionBlock:(insertCompletionBlock)block;

/**
 *  插入数组，传入主键，去重，更新对应的值
 *
 *  @param items                被操作的模型
 *  @param keyPropertyNameArray 字段名（主键，用于去重）
 *  @param updateValueArray     根据keyPropertyNameArray查找到符合条件的数据，然后更新updateValueArray对应字段的值
 *  @param block                完成回调
 */
- (void)insertItemsNotRepeat:(NSArray*)items keyPropertyNameArray:(NSArray*)keyPropertyNameArray updateValueArray:(NSArray*)updateValueArray completionBlock:(insertCompletionBlock)block;

@end
