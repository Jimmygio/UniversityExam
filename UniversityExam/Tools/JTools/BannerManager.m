//
//  BannerManager.m
//  XONE
//
//  Created by Chang Chin-Ming on 08/06/2017.
//  Copyright © 2017 Chang Chin-Ming. All rights reserved.
//

#import "BannerManager.h"

#import "UniversityExam-Swift.h"

@interface BannerManager () {
    NSTimer *myTimer;
}

@end

@implementation BannerManager

+ (instancetype)shared {
    static BannerManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BannerManager alloc] init];
    });
    return instance;
}


- (void)loadBanner:(NSString *)str success:(BOOL)isSuccess  {
    if (isSuccess == 1) {
        [[BannerManager shared] loadBanner:str img:JImage(@"ic_msg_checkbox.png") bgColor:JMainColor()];
    } else {
        [[BannerManager shared] loadBanner:str img:JImage(@"ic_push_error.png") bgColor:UIColor.redColor];
    }
}

- (void)loadBanner:(NSString *)str img:(UIImage *)img bgColor:(UIColor *)color {
    UIControl *bannerC = [[[NSBundle mainBundle] loadNibNamed:@"BannerControl" owner:self options:nil] firstObject];
    //    NSLog(@"BannerC start = %@", BannerC);
    float banner_H;
    if (JTools.winSize.width == 812 || JTools.winSize.height == 812) {
        banner_H = 88;
    } else {
        banner_H = 64;
    }
    [bannerC setFrame:CGRectMake(0, -banner_H, JTools.winSize.width, banner_H)];
    [bannerC setBackgroundColor:color];
    [bannerC addTarget:self action:@selector(press_bannerC:) forControlEvents:UIControlEventTouchUpInside];
    bannerC.tag = 500;
    [[JTools AppDelegate].window addSubview:bannerC];;
    
    UIImageView *imgView = [bannerC viewWithTag:50];
    [imgView setImage:img];
    
    UILabel *descLable = [bannerC viewWithTag:51];
    descLable.text = str;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        [JTools SaveIntDefault:1 Key:kStatusBarHidden];
        [[JTools topViewController] setNeedsStatusBarAppearanceUpdate];
        self->myTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                         target:self
                                                       selector:@selector(press_bannerC:)
                                                       userInfo:bannerC
                                                        repeats:NO];
        [UIView animateWithDuration:0.3 animations:^{
            [bannerC setFrame:CGRectMake(0, 0, JTools.winSize.width, banner_H)];
        } completion:^(BOOL finished) {
        }];
    });
}

- (void)timerEnd:(NSTimer *)timer {
    dispatch_async(dispatch_get_main_queue(), ^{
        //        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [JTools SaveIntDefault:0 Key:kStatusBarHidden];
        [[JTools topViewController] setNeedsStatusBarAppearanceUpdate];
        UIControl *bannerC;
        for (UIControl *control in [JTools AppDelegate].window.subviews) {
            if ([control isKindOfClass:[UIControl class]] && control.tag == 500) {
                bannerC = control;
            }
        }
        //        NSLog(@"bannerC end = %@", bannerC);
        [self->myTimer invalidate];
        self->myTimer = nil;
        float banner_H;
        if (JTools.winSize.width == 812 || JTools.winSize.height == 812) {
            banner_H = 88;
        } else {
            banner_H = 64;
        }
        [UIView animateWithDuration:0.3 animations:^{
            [bannerC setFrame:CGRectMake(0, -banner_H, JTools.winSize.width, banner_H)];
        } completion:^(BOOL finished) {
            [bannerC removeFromSuperview];
        }];
    });
}

- (void)press_bannerC:(UIControl *)BannerC {
    [self timerEnd:myTimer];
}

@end
