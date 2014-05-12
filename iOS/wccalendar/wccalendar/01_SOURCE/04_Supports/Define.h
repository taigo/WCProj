/*
 * $Author: kidbaw $
 * $Revision: 59 $
 * $Date: 2012-03-23 22:44:48 +0700 (Fri, 23 Mar 2012) $
 */

#import "SupportFunction.h"

#define VKDEBUG 1

#if VKDEBUG
#define TTLog(fmt, ...) TTLoga((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define TTLog(fmt, ...) TTLoga(fmt, ##__VA_ARGS__);
#endif

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IOS_7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

#define RGBCOLOR(r, g, b)             [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)         [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)/255.0f]

#define RELEASE_SAFE(p)                                 { if (p) { [(p) release]; (p) = nil;  } }

#define FONT_APP_REGULAR                                @"HelveticaNeue-Light"
#define FONT_APP_BOLD                                   @"HelveticaNeue"
#define FONT_APP_THIN                                   @"HelveticaNeue-Light"


// Do not use these constant have prefix _. Use the other have same name below.
#define _HEIGHT_IPHONE                                                       480.0f
#define _WIDTH_IPHONE                                                        320.0f
#define _HEIGHT_IPHONE_5                                                     568.0f
#define _WIDTH_IPHONE_5                                                      320.0f
#define _HEIGHT_IPAD                                                         1024.0f
#define _WIDTH_IPAD                                                          768.0f

#define HEIGHT_IPHONE                                                       [SupportFunction getDeviceHeight]
#define WIDTH_IPHONE                                                        [SupportFunction getDeviceWidth]
#define HEIGHT_IPHONE_5                                                     [SupportFunction getDeviceHeight]
#define WIDTH_IPHONE_5                                                      [SupportFunction getDeviceWidth]
#define HEIGHT_IPAD                                                         [SupportFunction getDeviceHeight]
#define WIDTH_IPAD                                                          [SupportFunction getDeviceWidth]
#define HEIGHT_STATUS_BAR                                                   20.0f
#define HEIGHT_AD_BANNER                                                    50.0f
#define IS_IPAD                                                             [SupportFunction deviceIsIPad]

#define HEIGHT_IPHONE_KEYBOARD                                              216.0f
#define HEIGHT_IPHONE_KEYBOARD_LANDSCAPE                                    162.0f
#define HEIGHT_IPAD_KEYBOARD                                                264.0f
#define HEIGHT_IPAD_KEYBOARD_LANDSCAPE                                      352.0f

// Screen ID
#define StoryboardIDMainVC  @"ViewController"

// CoreData
#define kSqliteFileName @"wccalendar"
