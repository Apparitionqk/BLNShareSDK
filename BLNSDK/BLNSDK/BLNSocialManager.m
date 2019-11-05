
//
//  WaHuSocialManager.m
//  test
//
//  Created by Apple on 2019/8/16.
//  Copyright © 2019 shandianyun. All rights reserved.
//

#import "BLNSocialManager.h"
#import "NSString+BLNMD5.h"
#import "NSDictionary+blnJsonString.h"
#import "NSString+blnJsonToDic.h"
#import "BLNHelper.h"

#define ServerDomian @"api.ahqichu.com"

@interface BLNSocialManager ()
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *appSecret;
//@property (nonatomic, copy) void(^block)(BLNUserInfo *user);
@property (nonatomic, copy) void (^resultBlock)(BLNRespObject *respObject);

@end

static BLNSocialManager *blnManager;

@implementation BLNSocialManager

+(BLNSocialManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        blnManager = [[BLNSocialManager alloc]init];
    });
    return blnManager;
}

- (void)verifyAppId:(NSString *)appId secret:(NSString *)secret complete:(nonnull void (^)(BLNRespObject * _Nonnull))complete{

    if (appId && secret) {
        long time = (long)[[NSDate date] timeIntervalSince1970];
        NSString *timeStr = [NSString stringWithFormat:@"%ld",time];
        NSDictionary *params = @{@"time":timeStr, @"appSecret":secret, @"secret":[self getSecret:secret appId:appId time:timeStr], @"appId":appId};
        __weak typeof(self) wself = self;
        NSString *urlString = [NSString stringWithFormat:@"http://%@:8092/open/authorization?time=%@&appSecret=%@&secret=%@&appId=%@", ServerDomian, params[@"time"], params[@"appSecret"], params[@"secret"], params[@"appId"]];
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *sharedSession = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (error == nil) {
                wself.appId = appId;
                wself.appSecret = secret;
            }
            if (complete && data.length > 0) {
                NSError *jsonError = nil;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                NSLog(@"resultDIc ===%@", dic);
                BLNRespObject *resObject = [[BLNRespObject alloc] init];
                resObject.result = [dic[@"resultCode"] boolValue];
                resObject.infoDic = dic;
                if (error == nil) {
                    if (!resObject.result) {
                        resObject.blnError = [self getErrorCode:[dic[@"resultCode"]integerValue] description:dic[@"resultMsg"]];
                    }
                } else {
                    resObject.blnError = error;
                }
                complete(resObject);
            }
        }];
        [dataTask resume];
    }else {
        BLNRespObject *resObject = [[BLNRespObject alloc] init];
        resObject.result = NO;
        resObject.blnError = [self getErrorCode:NSKeyValueValidationError description:@"玻璃牛APP授权失败,请检查您的appId等参数不可为空"];
    }
}


- (void)loginAuthCallBack:(void (^)(BLNRespObject * _Nonnull))block {
    if (_appId && _appSecret) {
        if (block) {
            self.resultBlock = block;
        }
        [self authLogin];
    }else  {
        NSLog(@"玻璃牛APP授权失败,请检查您的appId等参数");
    }
}


- (void)actionShareWithUrl:(NSURL *)url {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL isCanOpen = [[UIApplication sharedApplication] canOpenURL:url];
        if (isCanOpen) {
#ifdef NSFoundationVersionNumber_iOS_10_0
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                
            }];
#else
            [[UIApplication sharedApplication] openURL:url];
            NSLog(@"App1打开App2");
#endif
        }else{
            NSLog(@"设备没有安装App2");
        }
    });
}

#pragma mark ---- 回调
- (BOOL)handleOpenURL:(NSURL *)url callBack:(nonnull void (^)(BLNRespObject * _Nonnull))block {
    NSString *urlString = url.absoluteString.stringByRemovingPercentEncoding;
    NSString *hostString = [NSString stringWithFormat:@"%@/",url.host];
    NSRange range = [urlString rangeOfString:hostString];
    if (range.location != NSNotFound) {
        NSString *contentString = [urlString substringFromIndex:(range.location + range.length)];
        NSDictionary *infoDic = [contentString jsonStringToDictionary];
        NSInteger type = [infoDic[@"type"] integerValue];
        if (type == 1) {
            BLNRespObject *object = [[BLNRespObject alloc] init];
            object.userInfo = [[BLNUserInfo alloc] initWith:infoDic[@"info"]];
            object.result = [infoDic[@"result"] boolValue];
            if (self.resultBlock) {
                BLNRespObject *obj = [[BLNRespObject alloc] init];
                obj.result = [infoDic[@"result"] boolValue];
                obj.userInfo = [[BLNUserInfo alloc] initWith:infoDic[@"info"]];
                self.resultBlock(obj);
            }
            return YES;
        }else {
            if (self.resultBlock) {
                BLNRespObject *obj = [[BLNRespObject alloc] init];
                if (type == 2) {
                    obj.shareType = BLNShareTypeText;
                }else if (type == 3) {
                    obj.shareType = BLNShareTypeImage;
                }else if (type == 4) {
                    obj.shareType = BLNShareTypeLink;
                }else if (type == 5) {
                    obj.shareType = BLNShareTypeAudio;
                }else if (type == 6) {
                    obj.shareType = BLNShareTypeVideo;
                }else if (type == 7) {
                    obj.shareType = BLNShareTypeFile;
                }
                obj.result = [infoDic[@"result"] boolValue];
                obj.infoDic = infoDic[@"info"];
                self.resultBlock(obj);
            }
            return YES;
        }
    }
    return NO;
}


#pragma mark ---- app授权接口加密
- (NSString *)getSecret:(NSString *)appSecret appId:(NSString *)appId time:(NSString *)time {
    NSString *secret;
    NSMutableString *str1 = [NSMutableString string];
    [str1 appendString:appId];
    [str1 appendString:[time MD5]];
    [str1 appendString:[appSecret MD5]];
    str1 = [[str1 MD5] mutableCopy];
    secret = [str1 copy];
    return secret;
}


- (void)showError:(NSError *)error callBack:(void (^)(id _Nonnull))block {
    if ([error.localizedDescription containsString:@"The request timed out"]) {
        NSString *str = @"网络超时,请检查您的网络";
        NSLog(@"%@",str);
        block(@{@"code":@"0",@"result":str});
    }else {
        NSString *str = @"玻璃牛APP授权验证失败,请检查您的appId及appSecret";
        //[self showAlert:nil title:str];
        NSLog(@"%@",str);
        block(@{@"code":@"0",@"result":str});
        
    }
}


#pragma mark ------ 登录
- (void)authLogin {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *icon = [[infoDictionary valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    [self handleImageWithImage:[UIImage imageNamed:icon] type:@"BLNLogin"];
    NSDictionary *loginDic = @{@"type":@(BLNShareTypeLogin), @"info":@{@"appId":_appId, @"appName": app_Name, @"appSecret":_appSecret, @"logo":@"logo"}};
    
    NSString *loginString = [NSString stringWithFormat:@"boliniu://%@/BLN/%@", _appId,[loginDic blnJsonString]];

   
    loginString = [loginString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"loginString == %@", loginString);
    NSURL *data = [NSURL URLWithString:loginString];
    [self actionShareWithUrl:data];
}
#pragma mark ------ 分享
- (void)shareMessage:(BLNMsgBase *)shareObject callBack:(void (^)(BLNRespObject *respObject))block{
    if (shareObject.content.length == 0 || shareObject.content == nil || [shareObject.content isKindOfClass:[NSNull class]]) {
        if (block) {
            self.resultBlock = block;
            BLNRespObject *resp = [[BLNRespObject alloc] init];
            resp.shareType = shareObject.shareType;
            resp.result = NO;
            resp.blnError = [self getErrorCode:200 description:@"分享数据为空"];
            block(resp);
        }
        [self alertForNullContent];
        return;
    }
    if (shareObject.shareType == BLNShareTypeText) {
        NSDictionary *shareDic = @{@"type":@(shareObject.shareType),@"content":shareObject.content};
        NSString *shareString = [NSString stringWithFormat:@"boliniu://%@/%@/%@", _appId, SDKIdentifier,[shareDic blnJsonString]];
        NSString *urlString = [shareString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *shareUrl = [NSURL URLWithString:urlString];
        self.resultBlock = block;
        [self actionShareWithUrl:shareUrl];
    }else if(shareObject.shareType == BLNShareTypeImage || shareObject.shareType == BLNShareTypeAudio || shareObject.shareType == BLNShareTypeVideo || shareObject.shareType == BLNShareTypeFile) {
        BLNHelper *helper = [[BLNHelper alloc] initWithAppId:_appId];
        if (![helper isNeedUpload:shareObject.content]) {//优先选择链接方式分享
            NSDictionary *shareDic = @{@"type":@(shareObject.shareType),@"content":shareObject.content};
            NSString *shareString = [NSString stringWithFormat:@"boliniu://%@/%@/%@", _appId, SDKIdentifier,[shareDic blnJsonString]];
            NSString *urlString = [shareString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *shareUrl = [NSURL URLWithString:urlString];
            self.resultBlock = block;
            [self actionShareWithUrl:shareUrl];
        }else if (shareObject.content.length > 0) {//先上传文件到服务器，在进行URL的分享
            __block NSString *wAppId = _appId;
            __weak typeof(self) weakSelf = self;
            NSError *readError = nil;
            NSData *shareData = [NSData dataWithContentsOfFile:shareObject.content options:NSDataReadingMappedIfSafe error:&readError];
            if (readError) {
                self.resultBlock = block;
                BLNRespObject *resp = [[BLNRespObject alloc] init];
                resp.shareType = shareObject.shareType;
                resp.result = NO;
                resp.blnError = [self getErrorCode:readError.code description:readError.localizedFailureReason];
//                block(resp);
                return;
            }
            [helper uploadDataFile:shareData filePath:shareObject.content Success:^(NSString * _Nonnull uploadUrl) {
                NSLog(@"Image uploadUrl === %@", uploadUrl);
                
                __strong typeof(self) strongSelf = weakSelf;
                NSDictionary *shareDic = @{@"type":@(shareObject.shareType),@"content":uploadUrl};
                NSString *shareString = [NSString stringWithFormat:@"boliniu://%@/%@/%@", wAppId, SDKIdentifier, [shareDic blnJsonString]];
                NSString *urlString = [shareString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                NSURL *shareUrl = [NSURL URLWithString:urlString];
                strongSelf.resultBlock = block;
                [strongSelf actionShareWithUrl:shareUrl];
            } failed:^(NSString * _Nonnull errReason) {
                NSLog(@"error == %@", errReason);
            }];
        }
    }
    
}
- (void)shareLink:(BLNLinkMsg *)shareObject callBack:(void (^)(BLNRespObject *respObject))block {
    NSDictionary *linkDic = @{@"title":shareObject.title, @"url":shareObject.content, @"subTitle":shareObject.subTitle, @"img":shareObject.img};
    NSDictionary *shareDic = @{@"type":@(BLNShareTypeLink),@"content":[linkDic blnJsonString]};
    NSString *shareString = [NSString stringWithFormat:@"boliniu://%@/BLN/%@", _appId,[shareDic blnJsonString]];
    NSString *urlString = [shareString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *shareUrl = [NSURL URLWithString:urlString];
    self.resultBlock = block;
    [self actionShareWithUrl:shareUrl];
}
- (void)shareImage:(BLNMsgBase *)shareObject callBack:(void (^)(BLNRespObject *respObject))block {
    if (shareObject.content.length == 0 || shareObject.content == nil || [shareObject.content isKindOfClass:[NSNull class]]) {
        [self alertForNullContent];
        return;
    }
//    [self handleImageWithPath:shareObject.content type:@"Image"];
    BLNHelper *helper = [[BLNHelper alloc] initWithAppId:_appId];
    if (![helper isNeedUpload:shareObject.content]) {//优先选择链接方式分享
        NSDictionary *shareDic = @{@"type":@"Image",@"info":@{@"Image":shareObject.content}};
        NSString *shareString = [NSString stringWithFormat:@"boliniu://%@/BLN/%@", _appId,[shareDic blnJsonString]];
        NSString *urlString = [shareString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *shareUrl = [NSURL URLWithString:urlString];
        self.resultBlock = block;
        [self actionShareWithUrl:shareUrl];
    }else if (shareObject.content.length > 0) {
        __block NSString *wAppId = _appId;
        __weak typeof(self) weakSelf = self;
        
        NSData *shareData = [NSData dataWithContentsOfFile:shareObject.content];
        [helper uploadDataFile:shareData filePath:shareObject.content Success:^(NSString * _Nonnull uploadUrl) {
            NSLog(@"Image uploadUrl === %@", uploadUrl);
            
            __strong typeof(self) strongSelf = weakSelf;
            NSDictionary *shareDic = @{@"type":@"Image",@"info":@{@"Image":uploadUrl}};
            NSString *shareString = [NSString stringWithFormat:@"boliniu://%@/BLN/%@", wAppId, [shareDic blnJsonString]];
            NSString *urlString = [shareString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *shareUrl = [NSURL URLWithString:urlString];
            strongSelf.resultBlock = block;
            [strongSelf actionShareWithUrl:shareUrl];
        } failed:^(NSString * _Nonnull errReason) {
            NSLog(@"error == %@", errReason);
        }];
    }
}
- (void)shareAudio:(BLNMsgBase *)shareObject callBack:(void (^)(BLNRespObject *respObject))block {
    if (shareObject.content.length == 0 || shareObject.content == nil || [shareObject.content isKindOfClass:[NSNull class]]) {
        [self alertForNullContent];
        return;
    }
    BLNHelper *helper = [[BLNHelper alloc] initWithAppId:_appId];
    if (![helper isNeedUpload:shareObject.content]) {//优先选择链接方式分享
        NSDictionary *shareDic = @{@"type":@"Audio",@"info":@{@"Audio":shareObject.content}};
        NSString *shareString = [NSString stringWithFormat:@"boliniu://%@/%@", _appId,[shareDic blnJsonString]];
        NSString *urlString = [shareString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *shareUrl = [NSURL URLWithString:urlString];
        self.resultBlock = block;
        [self actionShareWithUrl:shareUrl];
    }else if(shareObject.content.length > 0) {
        __block NSString *wAppId = _appId;
        __weak typeof(self) weakSelf = self;
        NSData *shareData = [NSData dataWithContentsOfFile:shareObject.content];
        [helper uploadDataFile:shareData filePath:shareObject.content Success:^(NSString * _Nonnull uploadUrl) {
            NSLog(@"Video uploadUrl === %@", uploadUrl);
            NSDictionary *shareDic = @{@"type":@"Audio",@"info":@{@"Audio":shareObject.content}};
            NSString *shareString = [NSString stringWithFormat:@"boliniu://%@/%@", wAppId,[shareDic blnJsonString]];
            NSString *urlString = [shareString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *shareUrl = [NSURL URLWithString:urlString];
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.resultBlock = block;
            [strongSelf actionShareWithUrl:shareUrl];
        } failed:^(NSString * _Nonnull errReason) {
            NSLog(@"error == %@", errReason);
        }];
    }
}
- (void)shareVideo:(BLNMsgBase *)shareObject callBack:(void (^)(BLNRespObject *respObject))block {
    if (shareObject.content.length == 0 || shareObject.content == nil || [shareObject.content isKindOfClass:[NSNull class]]) {
        [self alertForNullContent];
        return;
    }
    BLNHelper *helper = [[BLNHelper alloc] initWithAppId:_appId];
    if (![helper isNeedUpload:shareObject.content]) {//优先选择链接方式分享
        NSDictionary *shareDic = @{@"type":@"Video",@"info":@{@"Video":shareObject.content}};
        NSString *shareString = [NSString stringWithFormat:@"boliniu://%@/%@", _appId,[shareDic blnJsonString]];
        NSString *urlString = [shareString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *shareUrl = [NSURL URLWithString:urlString];
        self.resultBlock = block;
        [self actionShareWithUrl:shareUrl];
    }else if(shareObject.content.length > 0) {
        __block NSString *wAppId = _appId;
        __weak typeof(self) weakSelf = self;
        NSData *shareData = [NSData dataWithContentsOfFile:shareObject.content];
        [helper uploadDataFile:shareData filePath:shareObject.content Success:^(NSString * _Nonnull uploadUrl) {
            NSLog(@"Video uploadUrl === %@", uploadUrl);
            NSDictionary *shareDic = @{@"type":@"Video",@"info":@{@"Video":shareObject.content}};
            NSString *shareString = [NSString stringWithFormat:@"boliniu://%@/%@", wAppId,[shareDic blnJsonString]];
            NSString *urlString = [shareString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *shareUrl = [NSURL URLWithString:urlString];
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.resultBlock = block;
            [strongSelf actionShareWithUrl:shareUrl];
        } failed:^(NSString * _Nonnull errReason) {
            NSLog(@"error == %@", errReason);
        }];
    }
}
- (void)shareFile:(BLNMsgBase *)shareObject callBack:(void (^)(BLNRespObject *respObject))block {
    if (shareObject.content.length == 0 || shareObject.content == nil || [shareObject.content isKindOfClass:[NSNull class]]) {
        [self alertForNullContent];
        return;
    }
    BLNHelper *helper = [[BLNHelper alloc] initWithAppId:_appId];
    if (![helper isNeedUpload:shareObject.content]) {
        NSDictionary *shareDic = @{@"type":@"File",@"info":@{@"File":shareObject.content}};
        NSString *shareString = [NSString stringWithFormat:@"boliniu://%@/%@", _appId,[shareDic blnJsonString]];
        NSString *urlString = [shareString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *shareUrl = [NSURL URLWithString:urlString];
        self.resultBlock = block;
        [self actionShareWithUrl:shareUrl];
    }else if (shareObject.content.length > 0) {
        __block NSString *wAppId = _appId;
        __weak typeof(self) weakSelf = self;
        
        NSData *shareData = [NSData dataWithContentsOfFile:shareObject.content];
        [helper uploadDataFile:shareData filePath:shareObject.content Success:^(NSString * _Nonnull uploadUrl) {
            NSLog(@"File uploadUrl === %@", uploadUrl);
            NSDictionary *shareDic = @{@"type":@"File",@"info":@{@"File":uploadUrl}};
            NSString *shareString = [NSString stringWithFormat:@"boliniu://%@/%@", wAppId,[shareDic blnJsonString]];
            NSString *urlString = [shareString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *shareUrl = [NSURL URLWithString:urlString];
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.resultBlock = block;
            [strongSelf actionShareWithUrl:shareUrl];
        } failed:^(NSString * _Nonnull errReason) {
            NSLog(@"error == %@", errReason);
        }];
    }
}

#pragma mark --- Handle Image
- (void)handleImageWithPath:(NSString *)imagePath type:(NSString *)typeString {
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    NSData *ddd = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:imagePath], 1);
    [pasteboard setData:ddd forPasteboardType:typeString];
}
- (void)handleImageWithImage:(UIImage *)image type:(NSString *)typeString {
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    NSData *ddd = UIImageJPEGRepresentation(image, 1);
    [pasteboard setData:ddd forPasteboardType:typeString];
}

#pragma mark ---- 内容为空时的提示
- (void)alertForNullContent {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请检查分享内容是否为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:alertAction];
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertVC animated:YES completion:NULL];
    });
}

- (NSError *)getErrorCode:(NSInteger)errorCode description:(NSString *)description {
     return [[NSError alloc] initWithDomain:ServerDomian code:errorCode userInfo:@{NSLocalizedDescriptionKey:description}];
}
@end
