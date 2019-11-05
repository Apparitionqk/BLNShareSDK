//
//  BLNAlertView.m
//  BLNSDK
//
//  Created by 齐科 on 2019/9/11.
//  Copyright © 2019 齐科. All rights reserved.
//

#import "BLNAlertView.h"
@interface BLNAlertView()
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation BLNAlertView
- (instancetype)initAlert {
    self = [self initWithFrame:[UIScreen mainScreen].bounds];
//    BLNAlertView *alertView = [[BLNAlertView alloc] initWithFrame:;
    if (self) {
        self.backgroundColor = UIColor.blackColor;
        self.alpha = 0.1;
        [self addSubview:self.activityView];
    }
    return self;
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.center = self.center;
    }
    return _activityView;
}

- (void)showAlert {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [self.activityView startAnimating];
}
- (void)dismissAlert {
    [self.activityView stopAnimating];
    [self removeFromSuperview];
}
@end
