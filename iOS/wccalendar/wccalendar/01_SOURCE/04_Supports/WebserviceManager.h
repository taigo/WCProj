//
//  WebserviceManager.h
//  YardClub
//
//  Created by Kha Huynh on 3/31/14.
//  Copyright (c) 2014 siliconprime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

#ifndef STRING_REQUEST_ROOT
#define STRING_REQUEST_ROOT                                      @"http://ttreader.herokuapp.com/ttwc"
#endif

#define STRING_REQUEST_GET_MATCHS_INFO                           @"/matchs"

typedef enum {
    ENUM_API_REQUEST_INVALID = 0,
    ENUM_API_REQUEST_GET_MATCHS_INFO,
    ENUM_API_REQUEST_NUM
}ENUM_API_REQUEST_TYPE;

typedef void(^WebserviceManagerUploadProgressBlock)(NSUInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite);
typedef void(^WebserviceManagerCompleteBlock)(id responseObject);
typedef void(^WebserviceManagerFailureBlock)(NSError *error);


@interface WebserviceManager : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;

+ (WebserviceManager *)sharedInstance;

// normal request
- (AFHTTPRequestOperation *)operationWithType:(ENUM_API_REQUEST_TYPE)type andPostMethodKind:(BOOL)methodKind andParams:(NSMutableDictionary *)params inView:(UIView *)view completeBlock:(void (^)(id responseObject))block failureBlock:(void (^)(NSError *error))failureBlock;

// multipart request
- (AFHTTPRequestOperation *)operationMultiPartWithType:(ENUM_API_REQUEST_TYPE)type andParams:(NSMutableDictionary *)params withValues:(NSArray *)values andKeys:(NSArray*)keys inView:(UIView *)view progressBlock:(WebserviceManagerUploadProgressBlock)progressBlock completeBlock:(WebserviceManagerCompleteBlock)completeBlock failureBlock:(WebserviceManagerFailureBlock)failureBlock;

@end
