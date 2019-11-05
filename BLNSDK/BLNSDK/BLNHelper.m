//
//  BLNHelper.m
//  BLNSDK
//
//  Created by 齐科 on 2019/8/28.
//  Copyright © 2019 齐科. All rights reserved.
//

#import "BLNHelper.h"
#import "NSString+BLNMD5.h"
#import "BLNAlertView.h"
@interface BLNHelper()
{
    NSString *blnAppId;
//    BLNAlertView *alertView;
}
@end
@implementation BLNHelper
- (instancetype)initWithAppId:(NSString *)appId {
    self = [super init];
    if (self) {
        blnAppId = appId;
    }
    return self;
}

- (void)uploadFile:(NSString *)filePath type:(NSInteger)type Success:(void(^)(NSString *))success  failed:(void(^)(NSString *))failed {
    if (!filePath) {
        if (failed) {
            failed(@"路径为空");
        }
        return;
    }
    NSString *path = NSHomeDirectory();
    NSArray *paths = [path componentsSeparatedByString:@"/"];
    if (![filePath containsString:[paths lastObject]]) {//不是本地沙盒文件不需要上传
        success(filePath);
        return;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        failed(@"文件不存在");
        return;
    }
    NSData *fileData = [[NSData alloc] initWithContentsOfFile:filePath];
    [self uploadData:fileData filePath:filePath Success:^(NSString *uploadUrl) {
        if (success) {
            success(uploadUrl);
        }
    } failed:^(NSString *errReason) {
        if (failed) {
            failed(errReason);
        }
    }];
}
- (void)uploadImage:(NSData *)imageData filePath:(NSString *)filePath Success:(void(^)(NSString *uploadUrl))success  failed:(void(^)(NSString *errReason))failed {
    [self uploadData:imageData filePath:filePath Success:^(NSString *uploadUrl) {
        if (success) {
            success(uploadUrl);
        }
    } failed:^(NSString *errReason) {
        if (failed) {
            failed(errReason);
        }
    }];
}
- (void)uploadDataFile:(NSData *)fileData filePath:(NSString *)filePath Success:(void (^)(NSString * _Nonnull))success failed:(void (^)(NSString * _Nonnull))failed {
    [self uploadData:fileData filePath:filePath Success:^(NSString *uploadUrl) {
        if (success) {
            success(uploadUrl);
        }
    } failed:^(NSString *errReason) {
        if (failed) {
            failed(errReason);
        }
    }];
}
- (void)uploadData:(NSData *)data filePath:(NSString *)filePath Success:(void(^)(NSString *uploadUrl))success  failed:(void(^)(NSString *errReason))failed {
    if (data == nil || data.length == 0) {
        if (failed) {
            failed(@"文件为空");
        }
    }
    if ([data length]/1000 > 10*1000){
        //超过10M ....
        if (failed) {
            failed(@"文件超过10M");
        }
        NSLog(@"文件超过10M");
        return;
    }
    NSString *typeString = [filePath getFileName];
//    if (type == 0) {
//        //Image
//        typeString = @"shareImage.jpg";
//    }else if (type == 1) {
//        //Video
//        typeString = @"shareVideo";
//    }else if (type == 2) {
//        //File
//        typeString = @"shareFile";
//    }
    NSString *fileUrl = [NSString stringWithFormat:@"http://eleios.1stdream.cn/bln_upload.aspx?fileName=%@_%@",blnAppId, typeString];
    NSURL *uploadUrl = [NSURL URLWithString:[fileUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    // 2. 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:uploadUrl];
    // 设置请求的为POST
    request.HTTPMethod = @"POST";
    //3.设置request的body
    request.HTTPBody = data;
    // 设置请求头 Content-Length
    NSString *dataLength = [NSString stringWithFormat:@"%lu", (unsigned long)data.length];
    [request setValue:dataLength forHTTPHeaderField:@"Content-Length"];
    // 设置请求头 Content-Type
    [request setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%--@",@"BLN"] forHTTPHeaderField:@"Content-Type"];
    
    // 4. 创建会话
    NSURLSession *session = [NSURLSession sharedSession];
//    session.configuration.requestCachePolicy.
    BLNAlertView *alertView = [[BLNAlertView alloc] initAlert];
    [alertView showAlert];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSError *jsonError = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            dispatch_async(dispatch_get_main_queue(), ^{
                [alertView dismissAlert];
            });
            if (success) {
                success(dic[@"url"]);
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [alertView dismissAlert];
            });
            // 上传失败, 打印error信息
            if (failed) {
                failed(error.localizedDescription);
            }
        }
    }];
    // 恢复线程 启动任务
    [uploadTask resume];
}

///**
// 获取上传文件后的文件URL
//
// @param url 上传url
// @param success 成功回调
// @param failed 失败回调
// */
//- (void)getResourcesUrl:(NSURL *)url Success:(void(^)(NSString *fileUrl))success  failed:(void(^)(NSString *errReason))failed {
//    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
//    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *sharedSession = [NSURLSession sessionWithConfiguration:configuration];
//    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error) {
//            failed(error.localizedFailureReason);
//        }else{
//            if (success) {
//                NSError *jsonError = nil;
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
//                if (jsonError) {
//                    failed(error.localizedFailureReason);
//                }else {
//                    success(dic[@"url"]);
//                }
//            }
//        }
//    }];
//    [dataTask resume];
//}

#pragma mark ----- 是否需要上传

/**
 判断改路径文件是否需要上传
系统路径、URL链接等不需要上传
 沙盒内文件需要上传
 @param filePath 文件路径
 @return YES/NO
 */
- (BOOL)isNeedUpload:(NSString *)filePath {
    BOOL isNeed = NO;
    if (!filePath) {
        return NO;
    }
    NSString *homePath = NSHomeDirectory();
    NSString *bundlePath = [NSBundle mainBundle].bundlePath;
    if ([filePath containsString:bundlePath] || [filePath containsString:homePath]) {//本地沙盒文件,需要上传
        isNeed = YES;
    }else if ([self isUrl:filePath]) {
        isNeed = NO;
    }else {
        isNeed = YES;
    }
    
    return isNeed;
}

/**
 判断字符串是否为网络地址

 @param filePath 文件路径
 @return YES/NO
 */
- (BOOL)isUrl:(NSString *)filePath {
    if(filePath == nil) {
        return NO;
    }
    NSString *url;
    if (filePath.length>4 && [[filePath substringToIndex:4] isEqualToString:@"www."]) {
        url = [NSString stringWithFormat:@"http://%@",self];
    }else{
        url = filePath;
    }
    NSString *urlRegex = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:url];
}
@end
