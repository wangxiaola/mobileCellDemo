//
//  ZKTool.h
//  mobileCellDemo
//
//  Created by 王小腊 on 2017/4/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKTool : NSObject

/**
  保存在NSUserDefaults

 @param value 值
 @param key 键
 @return 是否保存成功
 */
+ (BOOL)cacheUserValue:(id)value key:(NSString *)key;

/**
 取出NSUserDefaults的值
 
 @param key 键
 @return 值
 */
+ (id)getUserDataForKey:(NSString *)key;


@end
