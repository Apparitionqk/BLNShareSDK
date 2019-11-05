//
//  BLNMacro.h
//  BLNSDK
//
//  Created by 齐科 on 2019/9/12.
//  Copyright © 2019 齐科. All rights reserved.
//

#ifndef BLNMacro_h
#define BLNMacro_h


#define SDKIdentifier @"BLN"

typedef NS_ENUM(NSUInteger, BLNShareType) {
    BLNShareTypeVerify = 0,
    BLNShareTypeLogin,
    BLNShareTypeText,
    BLNShareTypeImage,
    BLNShareTypeLink,
    BLNShareTypeAudio,
    BLNShareTypeVideo,
    BLNShareTypeFile
};


#endif /* BLNMacro_h */
