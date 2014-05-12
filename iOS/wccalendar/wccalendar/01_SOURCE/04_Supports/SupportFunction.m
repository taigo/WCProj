//
//  SupportFunction.m
//  
//
//  Created by Tai Truong on 2/27/14.
//  Copyright (c) 2014 Aigo. All rights reserved.
//

#import "SupportFunction.h"

#pragma mark - Debug log
void TTLoga(NSString *format,...)
{
#if VKDEBUG
    {
        va_list args;
        va_start(args,format);
        NSLogv(format, args);
        va_end(args);
    }
#endif
}


@implementation SupportFunction

typedef enum {
	libUserInterfaceIdiomUnknown = -1,
    libUserInterfaceIdiomPhone,
    libUserInterfaceIdiomPad,
} libUserInterfaceIdiom;

static libUserInterfaceIdiom g_interfaceIdiom = libUserInterfaceIdiomUnknown;
+ (BOOL)deviceIsIPad
{

	if ( g_interfaceIdiom == libUserInterfaceIdiomUnknown ) {
		switch ( UI_USER_INTERFACE_IDIOM() ) {
			case UIUserInterfaceIdiomPhone:
				g_interfaceIdiom = libUserInterfaceIdiomPhone;
				break;
				
			case UIUserInterfaceIdiomPad:
				g_interfaceIdiom = libUserInterfaceIdiomPad;
				break;
		}
	}
	return (g_interfaceIdiom == libUserInterfaceIdiomPad);
}


+ (int)getDeviceHeight
{
#ifdef IS_SUPPORTED_LANDSCAPE
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        if (IS_IPAD) {
            return _WIDTH_IPAD;
        }
        else if ([[UIDevice currentDevice] resolution] == UIDeviceResolution_iPhoneRetina4) {
            return _WIDTH_IPHONE_5;
        }
        else {
            return _WIDTH_IPHONE;
        }
    }
    else {
        if (IS_IPAD) {
            return _HEIGHT_IPAD;
        }
        else if ([[UIDevice currentDevice] resolution] == UIDeviceResolution_iPhoneRetina4) {
            return _HEIGHT_IPHONE_5;
        }
        else {
            return _HEIGHT_IPHONE;
        }
    }
#else
    if (IS_IPAD) {
        return _HEIGHT_IPAD;
    }
    else if ([[UIDevice currentDevice] resolution] == UIDeviceResolution_iPhoneRetina4) {
        return _HEIGHT_IPHONE_5;
    }
    else {
        return _HEIGHT_IPHONE;
    }
#endif
}

+ (int)getDeviceWidth
{
#ifdef IS_SUPPORTED_LANDSCAPE
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
        if (IS_IPAD) {
            return _HEIGHT_IPAD;
        }
        else if ([[UIDevice currentDevice] resolution] == UIDeviceResolution_iPhoneRetina4) {
            return _HEIGHT_IPHONE_5;
        }
        else {
            return _HEIGHT_IPHONE;
        }
    }
    else {
        if (IS_IPAD) {
            return _WIDTH_IPAD;
        }
        else if ([[UIDevice currentDevice] resolution] == UIDeviceResolution_iPhoneRetina4) {
            return _WIDTH_IPHONE_5;
        }
        else {
            return _WIDTH_IPHONE;
        }
    }
#else
    if (IS_IPAD) {
        return _WIDTH_IPAD;
    }
    else if ([[UIDevice currentDevice] resolution] == UIDeviceResolution_iPhoneRetina4) {
        return _WIDTH_IPHONE_5;
    }
    else {
        return _WIDTH_IPHONE;
    }
#endif
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (id)objectForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? @"" : object;
}

+(NSDate*)dateForString:(NSString*)dateStr
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    NSDate *date = [formatter dateFromString:dateStr];
    
    formatter = nil;
    return date;
}

@end

#pragma mark - UIImage

@implementation UIImage (Extras)

- (UIImage *)imageByScalingToSize:(CGSize)size withOption:(enumImageScalingType)type {
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize targetSize;
    CGRect drawRect;
    
    if (type == enumImageScalingType_Top) {
        targetSize = CGSizeMake(size.width, size.height);
        drawRect = CGRectMake(0, 0, size.width, sourceImage.size.height*size.width/sourceImage.size.width);
    }
    else if (type == enumImageScalingType_TargetSize) {
        targetSize = CGSizeMake(sourceImage.size.width, size.height*sourceImage.size.width/size.width);
        drawRect = CGRectMake(0, 0, targetSize.width, targetSize.height);
    }
    else if (type == enumImageScalingType_Center_ScaleSize) {
        CGFloat scaleFactor;
        CGFloat widthFactor = sourceImage.size.width/size.width;
        CGFloat heightFactor = sourceImage.size.height/size.height;
        
        if (widthFactor < heightFactor)
            scaleFactor = heightFactor;
        else
            scaleFactor = widthFactor;
        
        CGFloat scaledWidth  = size.width*scaleFactor;
        CGFloat scaledHeight = size.height*scaleFactor;
        targetSize = CGSizeMake(scaledWidth, scaledHeight);
        
        drawRect = CGRectMake((scaledWidth - sourceImage.size.width)/2, (scaledHeight - sourceImage.size.height)/2, sourceImage.size.width, sourceImage.size.height);
    }
    else if (type == enumImageScalingType_Center_FullSize) {
        //TaiT: 06/24/13 update scale full size, just scale one side (width or height)
        CGFloat scaleFactor;
        CGFloat widthFactor = sourceImage.size.width/size.width;
        CGFloat heightFactor = sourceImage.size.height/size.height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        CGFloat scaledWidth  = sourceImage.size.width/scaleFactor;
        CGFloat scaledHeight = sourceImage.size.height/scaleFactor;
        
        targetSize = size;
        drawRect = CGRectMake(-(scaledWidth - size.width)/2, -(scaledHeight - size.height)/2, scaledWidth, scaledHeight);
    } else if (type == enumImageScalingType_FullSize) {
        CGFloat scaleFactor;
        CGFloat widthFactor = sourceImage.size.width/size.width;
        CGFloat heightFactor = sourceImage.size.height/size.height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        CGFloat scaledWidth  = sourceImage.size.width/scaleFactor;
        CGFloat scaledHeight = sourceImage.size.height/scaleFactor;
        
        drawRect = CGRectMake(0, 0, scaledWidth, scaledHeight);
        targetSize = drawRect.size;
    }
    else if (type == enumImageScalingType_FitSize)
    {
        CGFloat scaleFactor;
        CGFloat widthFactor = sourceImage.size.width/size.width;
        CGFloat heightFactor = sourceImage.size.height/size.height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        CGFloat scaledWidth  = sourceImage.size.width/scaleFactor;
        CGFloat scaledHeight = sourceImage.size.height/scaleFactor;
        
        drawRect = CGRectMake(0, 0, scaledWidth, scaledHeight);
        targetSize = drawRect.size;
    }
    else {
        targetSize = CGSizeMake(size.width*sourceImage.size.height/size.height, sourceImage.size.height);
        drawRect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height);
    }
    
    if ([[UIDevice currentDevice] resolution] != UIDeviceResolution_iPhoneStandard) {
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(targetSize);
    }
    
    // draw image
    [sourceImage drawInRect:drawRect];
    
    // grab image
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    return newImage;
}

@end


#pragma mark - UIDevice

@implementation UIDevice (Resolutions)

- (UIDeviceResolution)resolution
{
    UIDeviceResolution resolution = UIDeviceResolution_Unknown;
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if (scale == 2.0f) {
            if (pixelHeight == 960.0f)
                resolution = UIDeviceResolution_iPhoneRetina35;
            else if (pixelHeight == 1136.0f)
                resolution = UIDeviceResolution_iPhoneRetina4;
            
        } else if (scale == 1.0f && pixelHeight == 480.0f)
            resolution = UIDeviceResolution_iPhoneStandard;
        
    } else {
        if (scale == 2.0f && pixelHeight == 2048.0f) {
            resolution = UIDeviceResolution_iPadRetina;
            
        } else if (scale == 1.0f && pixelHeight == 1024.0f) {
            resolution = UIDeviceResolution_iPadStandard;
        }
    }
    
    return resolution;
}

@end

