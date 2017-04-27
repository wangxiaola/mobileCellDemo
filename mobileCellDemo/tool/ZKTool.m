//
//  ZKTool.m
//  mobileCellDemo
//
//  Created by 王小腊 on 2017/4/27.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "ZKTool.h"

@implementation ZKTool

+ (BOOL)cacheUserValue:(id)value key:(NSString *)key;
{
    if (key.length >0)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:value forKey:key];
        return [defaults synchronize];
    }
    else
    {
        return NO;
    }
}

+ (id)getUserDataForKey:(NSString *)key;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (key.length>0)
    {
        return [defaults objectForKey:key];
    }
    else
    {
        return nil;
    }
    
}
@end
