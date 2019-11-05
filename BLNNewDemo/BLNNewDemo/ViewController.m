//
//  ViewController.m
//  BLNNewDemo
//
//  Created by 齐科 on 2019/8/28.
//  Copyright © 2019 齐科. All rights reserved.
//

#import "ViewController.h"
#import "HXPhotoPicker.h"

@interface ViewController ()
{
    UIImageView *imageView;
    UILabel *nameLabel;
    UIImage *albumImage;
    HXPhotoManager *manager;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-40, 100, 80, 80)];
    [self.view addSubview:imageView];
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+20, self.view.frame.size.width, 30)];
    nameLabel.textColor = UIColor.blackColor;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    
    manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
    manager.configuration.openCamera = YES;
    manager.configuration.lookLivePhoto = YES;
    manager.configuration.photoMaxNum = 9;
    manager.configuration.videoMaxNum = 9;
    manager.configuration.maxNum = 18;
    manager.configuration.videoMaximumSelectDuration = 500.f;
    manager.configuration.saveSystemAblum = YES;
    manager.configuration.showDateSectionHeader = NO;
    //        manager.configuration.requestImageAfterFinishingSelection = YES;
    // 设置保存的文件名称
    manager.configuration.localFileName = @"fenxiang";
    NSArray *array = @[@"登录授权", @"分享文字", @"分享链接", @"分享图片", @"分享视频", @"分享文件"];
    
    for (int i = 0; i<array.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(nameLabel.frame)+(50+20)*i, self.view.frame.size.width-60, 40)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [button setBackgroundColor:UIColor.lightGrayColor];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.view addSubview:button];
    }
}

- (void)buttonAction:(UIButton *)button {
    switch (button.tag) {
        case 0:
        {
            [self loginAuth];
        }
            break;
        case 1:
        {
            [self shareText];
        }
            break;
        case 2:
        {
            [self shareLink];
        }
            break;
        case 3:
        {
            [self shareImage];
        }
            break;
        case 4:
        {
            [self shareVideo];
        }
            break;
        case 5:
        {
            [self shareFile];
        }
            break;
            
        default:
            break;
    }
}
- (void)loginAuth {
    __block UIImageView *tempImage = imageView;
    __block UILabel *tempLabel = nameLabel;
    [[BLNSocialManager sharedInstance] loginAuthCallBack:^(BLNRespObject *object) {
        if (object.result) {
            tempImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:object.userInfo.image]]];
            tempLabel.text = object.userInfo.nickName;
        }else {
            NSLog(@"登录授权失败，%@", object.blnError.localizedDescription);
        }
    }];
}

- (void)shareText {
    BLNMsgBase *msg = [[BLNMsgBase alloc] init];
    msg.content = @"你好！！！！！";
    msg.shareType = BLNShareTypeText;
    [[BLNSocialManager sharedInstance] shareMessage:msg callBack:^(BLNRespObject *object) {
        if (object.result) {
            NSLog(@"分享文字成功");
        }else {
            NSLog(@"分享文字失败，%@", object.blnError.localizedDescription);
        }
    }];
}
- (void)shareLink {
    BLNLinkMsg *msg = [[BLNLinkMsg alloc] init];
    msg.content = @"https://blog.csdn.net/wujakf/article/details/64127655";
    msg.title = @"CSDN";
    msg.img = @"";
    msg.subTitle = @"tessssst";
    msg.shareType = BLNShareTypeLink;
    [[BLNSocialManager sharedInstance] shareLink:msg callBack:^(BLNRespObject *object) {
        if (object.result) {
            NSLog(@"分享链接成功");
        }else {
            NSLog(@"分享链接失败，%@", object.blnError.localizedDescription);
        }
    }];
}
- (void)shareImage {
    BLNMsgBase *msg = [[BLNMsgBase alloc] init];
//    msg.content = @"http://upload.ahqichu.com/group1/M00/00/05/wKgAj11mdpmAC1YQAAB1VMflMC8373.jpg";
    msg.content = [[NSBundle mainBundle] pathForResource:@"WebViewScreenShot" ofType:@"png"];
    msg.shareType = BLNShareTypeImage;
    [[BLNSocialManager sharedInstance] shareMessage:msg callBack:^(BLNRespObject *object) {
        if (object.result) {
            NSLog(@"分享图片成功");
        }else {
            NSLog(@"分享图片失败，%@", object.blnError.localizedDescription);
        }
    }];
}
- (void)shareVideo {
    BLNMsgBase *msg = [[BLNMsgBase alloc] init];
//        msg.content = @"http://10.10.10.241/group1/M00/00/00/CgoK8V1_YqyAEOnMACUiFjx1bqU678.mp4";
    NSString *videoPath = @"/Users/apparitionqk/Desktop/BLNNewDemo/BLNNewDemo/Resources/11.mp4";
    msg.content = videoPath;
    msg.shareType = BLNShareTypeVideo;
    [[BLNSocialManager sharedInstance] shareMessage:msg callBack:^(BLNRespObject *object) {
        if (object.result) {
            NSLog(@"分享视频成功");
        }else {
            NSLog(@"分享视频失败，%@", object.blnError.localizedDescription);
        }
    }];
}
- (void)shareFile {
    BLNMsgBase *msg = [[BLNMsgBase alloc] init];
    //    msg.content = @"http://upload.ahqichu.com/group1/M00/00/05/wKgAj11mdpmAC1YQAAB1VMflMC8373.jpg";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"dmsy" ofType:@"pdf"];
    msg.content = filePath;
    msg.shareType = BLNShareTypeFile;
    [[BLNSocialManager sharedInstance] shareMessage:msg callBack:^(BLNRespObject *object) {
        if (object.result) {
            NSLog(@"分享文件成功");
        }else {
            NSLog(@"分享文件失败，%@", object.blnError.localizedDescription);
        }
    }];
}
@end
