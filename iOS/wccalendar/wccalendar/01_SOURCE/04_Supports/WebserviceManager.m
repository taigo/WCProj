//
//  WebserviceManager.m
//  YardClub
//
//  Created by Kha Huynh on 3/31/14.
//  Copyright (c) 2014 siliconprime. All rights reserved.
//

#import "WebserviceManager.h"

@interface WebserviceManager (local)

// Local business methods
- (NSString *)fullURLRequestWithAPI:(NSString *)strApiUrl;

@end

@implementation WebserviceManager

+ (WebserviceManager *)sharedInstance {
    
    static dispatch_once_t once;
    static WebserviceManager *sharedInstanceObj;
    dispatch_once(&once, ^{
        sharedInstanceObj = [[self alloc] init];
        sharedInstanceObj.requestManager = [AFHTTPRequestOperationManager manager];
    });
    
    return sharedInstanceObj;
}

#pragma mark --
#pragma mark - Local business methods

- (NSString *)fullURLRequestWithAPI:(NSString *)strApiUrl {
    
    return [STRING_REQUEST_ROOT stringByAppendingString:strApiUrl];
}

- (AFHTTPRequestOperation *)operationWithType:(ENUM_API_REQUEST_TYPE)type andPostMethodKind:(BOOL)methodKind andParams:(NSMutableDictionary *)params inView:(UIView *)view completeBlock:(void (^)(id responseObject))block failureBlock:(void (^)(NSError *error))failureBlock
{
    NSString *path = nil;
    switch (type) {
        case ENUM_API_REQUEST_GET_MATCHS_INFO:
        {
            path = STRING_REQUEST_GET_MATCHS_INFO;
            break;
        }
            
        default:
            break;
    }
    if (!path) {
        return nil;
    }
    
    // get full path
    path = [self fullURLRequestWithAPI:path];
    
    AFHTTPRequestOperation *op;
    if (methodKind) { // POST
        if (view) [MBProgressHUD showHUDAddedTo:view animated:YES];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        op = [self.requestManager POST:path
                           parameters:params
                              success:^(AFHTTPRequestOperation *operation, id responseObject)
              {
                  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                  if (view) [MBProgressHUD hideHUDForView:view animated:YES];
                  
                  // call complete block
                  if (block) {
                  block(responseObject);
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                  if (view) [MBProgressHUD hideHUDForView:view animated:YES];
                  
                  // call fail block
                  if (failureBlock) {
                  failureBlock(error);
                  }
              }];
    }
    else { // GET
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        if (view) [MBProgressHUD showHUDAddedTo:view animated:YES];
        op = [self.requestManager GET:path
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             if (view) [MBProgressHUD hideAllHUDsForView:view animated:YES];
             
             // call complete block
             if (block) {
             block(responseObject);
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             if (view) [MBProgressHUD hideAllHUDsForView:view animated:YES];
             
             // call fail block
             if (failureBlock) {
             failureBlock(error);
             }
         }];
    }
    return op;
}

-(AFHTTPRequestOperation *)operationMultiPartWithType:(ENUM_API_REQUEST_TYPE)type andParams:(NSMutableDictionary *)params withValues:(NSArray *)values andKeys:(NSArray *)keys inView:(UIView *)view progressBlock:(WebserviceManagerUploadProgressBlock)progressBlock completeBlock:(WebserviceManagerCompleteBlock)completeBlock failureBlock:(WebserviceManagerFailureBlock)failureBlock
{
    // path
    NSString *path = nil;
    switch (type) {
//        case ENUM_API_REQUEST_UPLOAD_INSPECTION_TO_RENTAL:
//        {
//            path = [NSString stringWithFormat:API_URL_INSPECTION_UPLOAD_PHOTO, [params[@"active_rental_id"] intValue]];
//            [params removeObjectForKey:@"active_rental_id"];
//            break;
//        }
        default:
            break;
    }
    if (!path) {
        return nil;
    }
    
    path = [[WebserviceManager sharedInstance] fullURLRequestWithAPI:path];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (view) [MBProgressHUD showHUDAddedTo:view animated:YES];
    AFHTTPRequestOperation *op = [self.requestManager POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // append data
        for (int i = 0; i < values.count; i++) {
            id object = [values objectAtIndex:i];
            id key = [keys objectAtIndex:i];
            if ([object isKindOfClass:[NSData class]]) {
                [formData appendPartWithFileData:object name:key fileName:@"photo.jpg" mimeType:@"image/jpg"];
            }
            else {
                if ([object respondsToSelector:@selector(dataUsingEncoding:)]) {
                    [formData appendPartWithFormData:[object dataUsingEncoding:NSUTF8StringEncoding] name:key];
                } else if ([object isKindOfClass:[NSNumber class]]) {
                    [formData appendPartWithFormData:[[object stringValue] dataUsingEncoding:NSUTF8StringEncoding] name:[keys objectAtIndex:i]];
                }
            }
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (view) [MBProgressHUD hideHUDForView:view animated:YES];
        
        // call complete block
        if (completeBlock) {
            completeBlock(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (view) [MBProgressHUD hideHUDForView:view animated:YES];
        
        // call fail block
        if (failureBlock) {
            failureBlock(error);
        }
    }];
    
    // add progress block
    if (progressBlock) {
        [op setUploadProgressBlock:^(NSUInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            progressBlock(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        }];
    }
    // start operation
    [op start];
    
    return op;
}
@end
