//
//  BLNAlertView.h
//  BLNSDK
//
//  Created by 齐科 on 2019/9/11.
//  Copyright © 2019 齐科. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLNAlertView : UIView
- (instancetype)initAlert;
- (void)showAlert;
- (void)dismissAlert;
@end

NS_ASSUME_NONNULL_END
