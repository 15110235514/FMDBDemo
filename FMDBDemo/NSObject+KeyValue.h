//
//  NSObject+KeyValue.h
//  FMDBDemo
//
//  Created by 彭伟 on 16/8/17.
//  Copyright © 2016年 彭伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KeyValue)
//获取某个对象的属性列表
- (NSMutableArray *)objectPropertyNameList;
//获取某个对象的属性类型列表
- (NSMutableDictionary *)objectPropertyTypeList;
//获取某个对象所有属性值列表
- (NSMutableArray *)objectPropertyValueList;
//将类名转换成字符串
- (NSString *)objectName;
//重写 NSObject 的 valueForKey 方法
- (NSString *)PWValueForKey:(NSString *)key;
@end
