//
//  YLSocialManager.h
//  test
//
//  Created by Apple on 2019/8/16.
//  Copyright © 2019 shandianyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YLUserInfo.h"
#import "YLRespObject.h"
#import "YLMsgBase.h"

NS_ASSUME_NONNULL_BEGIN
@interface YLSocialManager : NSObject
/**
 *  玻璃牛SDK单例
 *
 */
+(YLSocialManager *)sharedInstance;

/**
 *  处理app授权校验
 *
 *  @param appId        appId
 *  @param secret       appSecret
 *  @param complete      回调
 */
- (void)verifyAppId:(NSString *)appId secret:(NSString *)secret complete:(void (^)(YLRespObject *object))complete;

/**
 *  登录授权
 *

 *  @param block        结果回调
 */
- (void)loginAuthCallBack:(void (^)(YLRespObject *object))block;


- (void)shareText:(YLMsgBase *)shareObject callBack:(void (^)(YLRespObject *respObject))block;
- (void)shareLink:(YLLinkMsg *)shareObject callBack:(void (^)(YLRespObject *respObject))block;
- (void)shareImage:(YLMsgBase *)shareObject callBack:(void (^)(YLRespObject *respObject))block;
- (void)shareVideo:(YLMsgBase *)shareObject callBack:(void (^)(YLRespObject *respObject))block;
- (void)shareFile:(YLMsgBase  *)shareObject callBack:(void (^)(YLRespObject *respObject))block;

/**
 * 处理应用拉起协议
 * \param url 处理被其他应用呼起时的逻辑
 * \return 处理结果，YES表示成功，NO表示失败
 */
- (BOOL)handleOpenURL:(NSURL *)url callBack:(void (^)(YLRespObject *respObject))block;

@end

NS_ASSUME_NONNULL_END
