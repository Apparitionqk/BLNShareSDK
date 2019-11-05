//
//  YLRespObject.h
//  YLSDK
//
//  Created by 齐科 on 2019/8/29.
//  Copyright © 2019 齐科. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLUserInfo.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YLShareType) {
    YLShareTypeVerify = 0,
    YLShareTypeLogin,
    YLShareTypeText,
    YLShareTypeImage,
    YLShareTypeLink,
    YLShareTypeVideo,
    YLShareTypeFile
};

@interface YLRespObject : NSObject
@property (nonatomic, assign) BOOL result;
@property (nonatomic, assign) YLShareType shareType;
@property (nonatomic, strong) YLUserInfo *userInfo;
@property (nonatomic, strong) NSDictionary *infoDic; //!<返回信息
 /*
  * 分享成功
  * 分享失败，返回失败原因
  */
@property (nonatomic, strong) NSError *ylError;
@end

NS_ASSUME_NONNULL_END
