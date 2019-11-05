//
//  BLNUserInfo.h
//  test
//
//  Created by Apple on 2019/8/17.
//  Copyright © 2019 shandianyun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLNUserInfo : NSObject
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *openId;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *provinceId;

- (instancetype)initWith:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

