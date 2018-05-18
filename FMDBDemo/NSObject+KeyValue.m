//
//  NSObject+KeyValue.m
//  FMDBDemo
//
//  Created by 彭伟 on 16/8/17.
//  Copyright © 2016年 彭伟. All rights reserved.
//

#import "NSObject+KeyValue.h"
#import <objc/runtime.h>
@implementation NSObject (KeyValue)

- (NSMutableArray *)objectPropertyNameList
{
    NSMutableArray *propertyList = [NSMutableArray arrayWithCapacity:0];
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
        NSString *property = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        [propertyList addObject:property];
    }
    return propertyList;
}

- (NSMutableDictionary *)objectPropertyTypeList
{
    NSMutableDictionary *propertyTypeDict = [NSMutableDictionary dictionaryWithCapacity:0];
    u_int ivarNum;
    NSString *key = nil;
    NSString *value = nil;
    Ivar *vars = class_copyIvarList([self class], &ivarNum);
    for (int i = 0; i < ivarNum; i++) {
        Ivar thisVar = vars[i];
        const char *ivar = ivar_getName(thisVar);
        key = [NSString stringWithUTF8String:ivar];
        value = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisVar)];
        if ([key hasPrefix:@"_"]) {
            key = [key substringFromIndex:1];
        }
        [propertyTypeDict setValue:[self changeString:value] forKey:key];
    }
    free(vars);
    return propertyTypeDict;
}

- (NSMutableArray *)objectPropertyValueList
{
    NSMutableArray *propertyValueList = [NSMutableArray arrayWithCapacity:0];
    u_int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    id value = nil;
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
        NSString *property = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        value = [self valueForKey:property];
        if (value == nil || [value isKindOfClass:[NSNull class]]) {
            value = @"";
        }
        [propertyValueList addObject:value];
    }
    return propertyValueList;
}

- (NSString *)changeString:(NSString *)value
{
    NSArray *subArr = [value componentsSeparatedByString:@"\""];
    if (subArr.count == 1) {
        return value;
    }else{
        return [subArr objectAtIndex:1];
    }
    return nil;
}

- (NSString *)objectName
{
    return NSStringFromClass([self class]);
}

- (NSString *)PWValueForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        value = @"";
    }
    return value;
}

@end
