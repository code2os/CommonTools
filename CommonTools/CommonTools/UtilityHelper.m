//
//  UtilityHelper.m
//  inotemini
//
//  Created by Joe on 15/8/31.
//  Copyright (c) 2015年 Joe. All rights reserved.
//

#import "UtilityHelper.h"

@implementation UtilityHelper

// 将16位颜色代码转为UIColor
+ (UIColor *) stringTOColor:(NSString *)str
{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}

// 将配置信息存入本地plist文件中
+(void)writeUserConfig:(NSString *)strValue withKey:(NSString *)strKey
{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    // 存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
    [userData setObject:strValue forKey:strKey];
    // 这里建议同步存储到磁盘中，但是不是必须的
    [userData synchronize];
}

// 根据key读取缓存在本地plist文件中的配置信息
+(NSString *)readUserConfig:(NSString *)strKey
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    // 读取NSString类型的数据
    NSString *strValue = [userDefaultes stringForKey:strKey];
    
    return strValue;
}

// 弹出系统消息
+(void) showSystemMessage:(id)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统消息" message:[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

// NSDate转NSString
+(NSString *)dateToString:(NSDate *)date withFormat:(NSString *)format{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    // 设置时区，防止出现时间偏差
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CCD"]];
    [dateFormatter setDateFormat:format];
    NSString *dateString=[dateFormatter stringFromDate:date];
    
    return dateString;
}

// NSString转NSDate
+(NSDate *)stringToDate:(NSString *)dateString withFormat:(NSString *)format{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    // 设置时区，防止出现8小时偏差
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CCD"]];
    [dateFormatter setDateFormat:format];
    NSDate *date=[dateFormatter dateFromString:dateString];
    
    return date;
}

// 简化NSDate，清除不必要的时分秒信息。
+(NSDate *) simplifyDate:(NSDate *)date{
    NSString *dateStr = [self dateToString:date withFormat:@"yyyy-MM-dd"];
    NSString *str =[NSString stringWithFormat:@"%@ %@",dateStr,@"00:00:00"];
    NSDate *simpDate = [self stringToDate:str withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return simpDate;
}

// 获取文件流对应文件的类型
+(NSString *)getFileType:(NSData *)fileData{
    // 文件流对应文件的类型
    NSString *fileType = @"";
    NSArray *typeArray = [NSArray arrayWithObjects:@"13780", @"7173", @"6677", @"255216", @"9997", @"00", nil];
    
    if(fileData!=nil){
        int char1=0,char2=0;
        [fileData getBytes:&char1 range:NSMakeRange(0, 1)];
        [fileData getBytes:&char2 range:NSMakeRange(1, 1)];
        fileType = [NSString stringWithFormat:@"%i%i",char1,char2];
    }
    
    NSUInteger index = [typeArray indexOfObject:fileType];
    switch (index) {
        case 0:
            fileType = @".png";
            break;
        case 1:
            fileType = @".gif";
            break;
        case 2:
            fileType = @".bmp";
            break;
        case 3:
            fileType = @".jpg";
            break;
        case 4:
            fileType = @".caf";
            break;
        case 5:
            fileType = @".mov";
            break;
        default:
            fileType = @"";
            break;
    }
    
    return fileType;
}

// 截取部分图像
+(UIImage*)getSubImage:(UIImage *)image WithRect:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

// 等比例缩放
+(UIImage*)scaleToSize:(UIImage *)image WithSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(image.CGImage);
    CGFloat height = CGImageGetHeight(image.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
