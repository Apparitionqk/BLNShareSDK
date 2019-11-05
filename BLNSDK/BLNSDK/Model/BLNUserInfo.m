//
//  BLNUserInfo.m
//  test
//
//  Created by Apple on 2019/8/17.
//  Copyright © 2019 shandianyun. All rights reserved.
//

#import "BLNUserInfo.h"

@implementation BLNUserInfo

- (instancetype)initWith:(NSDictionary *)dict {
    self.openId = [NSString stringWithFormat:@"%@",dict[@"openId"]];
    self.nickName = [NSString stringWithFormat:@"%@",dict[@"nickName"]];
    self.image = [NSString stringWithFormat:@"%@",dict[@"image"]];
    self.birthday = [NSString stringWithFormat:@"%@",dict[@"birthday"]];
    self.sex = [NSString stringWithFormat:@"%@",dict[@"sex"]];
    self.cityId = [NSString stringWithFormat:@"%@",dict[@"cityId"]];
    self.provinceId = [NSString stringWithFormat:@"%@",dict[@"provinceId"]];

    return self;
}

@end
