//
//  NSString+blnJsonToDic.h
//  BLNSDK
//
//  Created by 齐科 on 2019/8/28.
//  Copyright © 2019 齐科. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (blnJsonToDic)
- (NSDictionary *)jsonStringToDictionary;
- (NSString *)getSDKIdentifierStringWithType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
