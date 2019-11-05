//
//  NSString+blnJsonToDic.m
//  BLNSDK
//
//  Created by 齐科 on 2019/8/28.
//  Copyright © 2019 齐科. All rights reserved.
//

#import "NSString+blnJsonToDic.h"

@implementation NSString (blnJsonToDic)
- (NSDictionary *)jsonStringToDictionary {
    if (self == nil) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
