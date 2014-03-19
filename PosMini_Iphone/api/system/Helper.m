//
//  Helper.m
//  PosMini_Iphone
//
//  Created by chinapnr on 13-7-11.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "Helper.h"

@implementation Helper

/**
 将UIView转换为UIImage
 @param view 待转换的UIView
 @returns 转换后的UIImage
 */
+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.frame.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/**
 通过键值对存储数据
 @param values 存储值 Value
 @param key 存储键 Key
 */
+(void) saveValue:(id)value forKey:(id)key;
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

/**
 通过Key获取存储Value
 @param key 存储键 Key
 @returns 存储值 Value
 */
+(id) getValueByKey:(id)key
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}


/**
 计算UILabel的高度
 @param inputString 显示文字
 @param font 字体大小
 @param width Label的宽度
 @returns 返回Label的高度
 */
+(float) getLabelHeight:(NSString *)inputString setfont:(UIFont *)font setwidth:(float)width
{
	CGSize maximumLabelSize = CGSizeMake(width,INT32_MAX);
	
	CGSize expectedLabelSize = [inputString sizeWithFont:font
                                       constrainedToSize:maximumLabelSize
										   lineBreakMode:UILineBreakModeWordWrap];
	return expectedLabelSize.height;
}

/**
 计算UILabel的宽度
 @param inputString 显示文字
 @param font 字体大小
 @param height Label高度
 @returns 返回Label宽度
 */
+(float )getLabelWidth:(NSString *)inputString setFont:(UIFont *)font setHeight:(float)height
{
    CGSize titleSize = [inputString sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, height)];
    return titleSize.width;
}


/**
 计算屏幕宽度
 @returns 屏幕宽度
 */
+(float) screenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

/**
 计算屏幕高度
 @returns 屏幕高度
 */
+(float) screenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

/**
 判断字符串是否位空
 @param inputString 输入字符串
 @returns 返回结果
 */
+(Boolean)StringIsNullOrEmpty:(NSString *)inputString
{
    if (inputString!=nil&&inputString.length>0) {
        return NO;
    }
    return YES;
}

/*
 判断字符串的每个字符是否为数字或字母
 @param string 输入字符串
 @returns 返回结果
 */

+(BOOL)containInvalidChar:(NSString *)string{
    
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSRange foundRange = [string rangeOfCharacterFromSet:disallowedCharacters];
    if (foundRange.location != NSNotFound) {
        return YES;
    }
    return NO;
}

/**
 MD5加密
 @param str 输入初始参数
 @returns 加密后字符串
 */
+(NSString *)md5_16:(NSString *)str
{
    const char *cstr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, strlen(cstr), result);
    return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]];
}

/**
 将NSData转为Base64字符串
 @param theData 输入NSData
 @returns 输出Base64编码字符串
 */
+(NSString *)base64forData:(NSData*)theData
{
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}

/**
 将base64字符串转换为NSData
 @param string base64字符串
 @returns 返回NSData
 */
+(NSData*)base64DataFromString:(NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[3];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil)
    {
        return [NSData data];
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true)
    {
        if (ixtext >= lentext)
        {
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z'))
        {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z'))
        {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9'))
        {
            ch = ch - '0' + 52;
        }
        else if (ch == '+')
        {
            ch = 62;
        }
        else if (ch == '=')
        {
            flendtext = true;
        }
        else if (ch == '/')
        {
            ch = 63;
        }
        else
        {
            flignore = true;
        }
        
        if (!flignore)
        {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext)
            {
                if (ixinbuf == 0)
                {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2))
                {
                    ctcharsinbuf = 1;
                }
                else
                {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4)
            {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++)
                {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak)
            {
                break;
            }
        }
    }
    
    return theData;
}

@end
