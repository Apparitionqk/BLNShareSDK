//
//  NSString+BLNMD5.m
//  BLNSDK
//
//  Created by 齐科 on 2019/8/27.
//  Copyright © 2019 齐科. All rights reserved.
//

#import "NSString+BLNMD5.h"

@implementation NSString (BLNMD5)
- (NSString *)MD5 {
    if (self == nil || [self length] == 0)
        return nil;
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    return [ms copy];
}
- (NSString*)getFileName {
    NSRange range = [self rangeOfString:@"/"options:NSBackwardsSearch];
    return [self substringFromIndex:range.location + 1];
}
@end
