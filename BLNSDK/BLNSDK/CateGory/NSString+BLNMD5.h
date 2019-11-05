//
//  NSString+BLNMD5.h
//  BLNSDK
//
//  Created by 齐科 on 2019/8/27.
//  Copyright © 2019 齐科. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (BLNMD5)
/**
 *  Create a MD5 string from self
 *
 *  @return Return the MD5 NSString from self
 */
- (NSString *)MD5;


/**
 从文件路径中获取文件名

 @return 文件名
 */
-(NSString*)getFileName;
@end

NS_ASSUME_NONNULL_END
