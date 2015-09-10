//
//  UtilityHelper.h
//  inotemini
//
//  Created by Joe on 15/8/31.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIkit.h"
#import "Macro.pch"

@interface UtilityHelper : NSObject

// 将16位颜色代码转为UIColor
+(UIColor *)stringTOColor:(NSString *)str;

// 将配置信息存入本地plist文件中
+(void)writeUserConfig:(NSString *)strValue withKey:(NSString *)strKey;

// 根据key读取缓存在本地plist文件中的配置信息
+(NSString *)readUserConfig:(NSString *)strKey;

// 弹出系统消息
+(void) showSystemMessage:(id)message;

// NSDate转NSString
+(NSString *)dateToString:(NSDate *)date withFormat:(NSString *)format;

// NSString转NSDate
+(NSDate *)stringToDate:(NSString *)dateString withFormat:(NSString *)format;

// 简化NSDate，清除不必要的时分秒信息。
+(NSDate *) simplifyDate:(NSDate *)date;

// 获取文件流对应文件的类型
+(NSString *)getFileType:(NSData *)fileData;

// 截取部分图像
+(UIImage*)getSubImage:(UIImage *)image WithRect:(CGRect)rect;

// 等比例缩放
+(UIImage*)scaleToSize:(UIImage *)image WithSize:(CGSize)size;

@end
