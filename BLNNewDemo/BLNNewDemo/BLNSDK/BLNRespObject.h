//
//  BLNRespObject.h
//  BLNSDK
//
//  Created by 齐科 on 2019/8/29.
//  Copyright © 2019 齐科. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLNUserInfo.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BLNShareType) {
    BLNShareTypeVerify = 0,
    BLNShareTypeLogin,
    BLNShareTypeText,
    BLNShareTypeImage,
    BLNShareTypeLink,
    BLNShareTypeVideo,
    BLNShareTypeFile
};

@interface BLNRespObject : NSObject
@property (nonatomic, assign) BOOL result;
@property (nonatomic, assign) BLNShareType shareType;
@property (nonatomic, strong) BLNUserInfo *userInfo;
@property (nonatomic, strong) NSDictionary *infoDic; //!<返回信息
 /*
  * 分享成功
  * 分享失败，返回失败原因
  */
@property (nonatomic, strong) NSError *blnError;
@end

NS_ASSUME_NONNULL_END
