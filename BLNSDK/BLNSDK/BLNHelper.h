//
//  BLNHelper.h
//  BLNSDK
//
//  Created by 齐科 on 2019/8/28.
//  Copyright © 2019 齐科. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLNHelper : NSObject
- (instancetype)initWithAppId:(NSString *)appId;

- (void)uploadFile:(NSString *)filePath filePath:(NSString *)filePath Success:(void(^)(NSString *uploadUrl))success  failed:(void(^)(NSString *errReason))failed;

- (void)uploadImage:(NSData *)imageData filePath:(NSString *)filePath Success:(void(^)(NSString *uploadUrl))success  failed:(void(^)(NSString *errReason))failed;

- (void)uploadDataFile:(NSData *)fileData filePath:(NSString *)filePath Success:(void(^)(NSString *uploadUrl))success  failed:(void(^)(NSString *errReason))failed;

- (BOOL)isNeedUpload:(NSString *)filePath;
@end

NS_ASSUME_NONNULL_END
