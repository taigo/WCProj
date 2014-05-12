//
//  SupportFunction.h
//
//
//  Created by Tai Truong on 2/27/14.
//  Copyright (c) 2014 Aigo. All rights reserved.
//

#import <Foundation/Foundation.h>

void TTLoga(NSString *format,...);

@interface SupportFunction : NSObject
+ (BOOL)deviceIsIPad;
+ (int)getDeviceHeight;
+ (int)getDeviceWidth;

// device orientation
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (id)objectForKey:(id)aKey fromDictionary:(NSDictionary *)dict;
+ (NSDate*)dateForString:(NSString*)dateStr;
@end


typedef enum {
	enumImageScalingType_Invalid,
    enumImageScalingType_Left,
    enumImageScalingType_Top,
    enumImageScalingType_Right,
    enumImageScalingType_Bottom,
    enumImageScalingType_TargetSize,
    enumImageScalingType_Center_ScaleSize,
    enumImageScalingType_Center_FullSize,
    enumImageScalingType_FullSize,
    enumImageScalingType_FitSize // fit to size
} enumImageScalingType;

@interface UIImage (Extras)
- (UIImage *)imageByScalingToSize:(CGSize)size withOption:(enumImageScalingType)type;
@end

enum {
    UIDeviceResolution_Unknown          = 0,
    UIDeviceResolution_iPhoneStandard   = 1,    // iPhone 1,3,3GS Standard Display  (320x480px)
    UIDeviceResolution_iPhoneRetina35   = 2,    // iPhone 4,4S Retina Display 3.5"  (640x960px)
    UIDeviceResolution_iPhoneRetina4    = 3,    // iPhone 5 Retina Display 4"       (640x1136px)
    UIDeviceResolution_iPadStandard     = 4,    // iPad 1,2 Standard Display        (1024x768px)
    UIDeviceResolution_iPadRetina       = 5     // iPad 3 Retina Display            (2048x1536px)
}; typedef NSUInteger UIDeviceResolution;

@interface UIDevice (Resolutions)

- (UIDeviceResolution)resolution;

@end

