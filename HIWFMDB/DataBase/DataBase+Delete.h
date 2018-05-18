//
//  DataBase+Delete.h
//  FMDBDemo
//
//  Created by 彭伟 on 16/8/22.
//  Copyright © 2016年 彭伟. All rights reserved.
//

#import "DataBase.h"

typedef void(^deleteCompletionBlock)(BOOL isSuccess);

@interface DataBase (Delete)

- (void)deleteItem:(id)item equalPropertyNameArray:(NSArray *)equalArray commpletionBlock:(deleteCompletionBlock)block;

- (void)deleteItem:(id)item equalPropertyNameArray:(NSArray *)equalArray notEqualPropertyNameArray:(NSArray *)notEqualArray completionBlock:(deleteCompletionBlock)block;

- (void)deleteItems:(NSArray *)itemsArray equalPropertyNameArray:(NSArray *)equalArray notEqualPropertyNameArray:(NSArray *)notEqualArray completionBlock:(deleteCompletionBlock)block;


@end
