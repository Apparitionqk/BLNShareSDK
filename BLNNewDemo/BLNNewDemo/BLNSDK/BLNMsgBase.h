//
//  BLNMsgBase.h
//  BLNSDK
//
//  Created by 齐科 on 2019/8/28.
//  Copyright © 2019 齐科. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
    玻璃牛分享消息类
 */
@interface BLNMsgBase : NSObject
@property (nonatomic, strong) NSString *content; // 分享文字时表示内容，图片、视频、文件等类型时表示链接，链接类型时表示链接URL
@end

@interface BLNLinkMsg : BLNMsgBase
@property (nonatomic, strong) NSString *title; //!< 标题
@property (nonatomic, strong) NSString *subTitle; //!< 副标题
@property (nonatomic, strong) NSString *img; //!< 图片链接
@end
NS_ASSUME_NONNULL_END
