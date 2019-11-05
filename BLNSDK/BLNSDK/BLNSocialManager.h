//
//  BLNSocialManager.h
//  test
//
//  Created by Apple on 2019/8/16.
//  Copyright © 2019 shandianyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BLNUserInfo.h"
#import "BLNRespObject.h"
#import "BLNMsgBase.h"

NS_ASSUME_NONNULL_BEGIN
@interface BLNSocialManager : NSObject
/**
 *  玻璃牛SDK单例
 *
 */
+(BLNSocialManager *)sharedInstance;

/**
 *  处理app授权校验
 *
 *  @param appId        appId
 *  @param secret       appSecret
 *  @param complete      回调
 */
- (void)verifyAppId:(NSString *)appId secret:(NSString *)secret complete:(void (^)(BLNRespObject *object))complete;

/**
 *  登录授权
 *

 *  @param block        结果回调
 */
- (void)loginAuthCallBack:(void (^)(BLNRespObject *object))block;


- (void)shareMessage:(BLNMsgBase *)shareObject callBack:(void (^)(BLNRespObject *respObject))block;
- (void)shareLink:(BLNLinkMsg *)shareObject callBack:(void (^)(BLNRespObject *respObject))block;

/**
 * 处理应用拉起协议
 * \param url 处理被其他应用呼起时的逻辑
 * \return 处理结果，YES表示成功，NO表示失败
 */
- (BOOL)handleOpenURL:(NSURL *)url callBack:(void (^)(BLNRespObject *respObject))block;

@end

NS_ASSUME_NONNULL_END
