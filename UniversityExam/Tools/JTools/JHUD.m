//
//  JHUD.m
//  XONE
//
//  Created by Chang Chin-Ming on 02/06/2017.
//  Copyright © 2017 Chang Chin-Ming. All rights reserved.
//

#import "JHUD.h"
#import "MBProgressHUD.h"
#import "JTools.h"

#import "UniversityExam-Swift.h"

@interface JHUD () {
    MBProgressHUD *HUD;
}

@end

@implementation JHUD

+ (instancetype)shared {
    static JHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHUD alloc] init];
    });
    return instance;
}

#pragma mark - HUD
-(void)updateHUDProgress:(float)progress {
    HUD.progress = progress/100;
}

-(void)LoadHUD:(NSString*)str Progress:(float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self->HUD) self->HUD = [MBProgressHUD new];
        self->HUD.mode = MBProgressHUDModeAnnularDeterminate;
        self->HUD.customView = [[UIImageView alloc] initWithImage:nil];
        self->HUD.progress = progress;
        self->HUD.labelText = str;
        self->HUD.detailsLabelText = nil;
        [self->HUD show:YES];
        [[JTools AppDelegate].window addSubview:self->HUD];
        [[JTools AppDelegate].window bringSubviewToFront:self->HUD];
    });
}

-(void)LoadHUD:(NSString*)str DetailsLabel:(NSString *)detailStr Delay:(float)time {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self->HUD) self->HUD = [MBProgressHUD new];
        self->HUD.customView = [[UIImageView alloc] initWithImage:nil];
        self->HUD.color = JColor(0, 0, 0, 0.7);
        self->HUD.labelText = str;
        self->HUD.labelColor = [UIColor whiteColor];
        self->HUD.detailsLabelText = detailStr;
        self->HUD.detailsLabelColor = [UIColor whiteColor];
        self->HUD.mode = MBProgressHUDModeCustomView;
        [self->HUD show:YES];
        if (time > 0) {
            [self->HUD hide:YES afterDelay:time];
        } else {
            [self->HUD hide:YES afterDelay:1];
        }
        [[JTools AppDelegate].window addSubview:self->HUD];
        [[JTools AppDelegate].window bringSubviewToFront:self->HUD];
    });
}

-(void)LoadHUD:(NSString*)AlertStr Delay:(float)time {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self->HUD) self->HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake((JTools.winSize.width-200)/2, (JTools.winSize.height-200-[UIApplication sharedApplication].statusBarFrame.size.height)/2, 200, 200)];
        
        self->HUD.customView = [[UIImageView alloc] initWithImage:nil];
        if (AlertStr) {
            self->HUD.labelText = AlertStr;
        } else {
            self->HUD.labelText = NSLocalizedString(@"Loading", nil);
        }
        self->HUD.detailsLabelText = nil;
        [self->HUD setCenter:CGPointMake(JTools.winSize.width/2, (JTools.winSize.height-[UIApplication sharedApplication].statusBarFrame.size.height)/2)];
        self->HUD.layer.anchorPoint = CGPointMake(0.5,0.5); //Need #import <QuartzCore/QuartzCore.h>
        if (time > 0) {
            self->HUD.mode = MBProgressHUDModeText;
            [self->HUD hide:YES afterDelay:time];
        } else {
            self->HUD.mode = MBProgressHUDModeIndeterminate;
        }
        self->HUD.transform = CGAffineTransformIdentity;
        [self->HUD show:YES];
        
        [[JTools AppDelegate].window addSubview:self->HUD];
        [[JTools AppDelegate].window bringSubviewToFront:self->HUD];
    });
}

-(void)LoadHUD:(NSString*)AlertStr Delay:(float)time inView:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self->HUD) self->HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake((view.bounds.size.width-200)/2, (view.bounds.size.height-200-[UIApplication sharedApplication].statusBarFrame.size.height)/2, 200, 200)];
        
        self->HUD.customView = [[UIImageView alloc] initWithImage:nil];
        if (AlertStr) {
            self->HUD.labelText = AlertStr;
        } else {
            self->HUD.labelText = NSLocalizedString(@"Loading", nil);
        }
        self->HUD.detailsLabelText = nil;
        [self->HUD setCenter:CGPointMake(JTools.winSize.width/2, (view.bounds.size.height-[UIApplication sharedApplication].statusBarFrame.size.height)/2)];
        self->HUD.layer.anchorPoint = CGPointMake(0.5,0.5); //Need #import <QuartzCore/QuartzCore.h>
        if (time > 0) {
            self->HUD.mode = MBProgressHUDModeText;
            [self->HUD hide:YES afterDelay:time];
        } else {
            self->HUD.mode = MBProgressHUDModeIndeterminate;
        }
        self->HUD.transform = CGAffineTransformIdentity;
        [self->HUD show:YES];
        
        [view addSubview:self->HUD];
        [view bringSubviewToFront:self->HUD];
    });
}

-(void)LoadHUD:(NSString*)AlertStr Delay:(float)time inVC:(UIViewController *)VC {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self->HUD) self->HUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake((JTools.winSize.width-200)/2, (JTools.winSize.height-200-[UIApplication sharedApplication].statusBarFrame.size.height)/2, 200, 200)];
        
        self->HUD.customView = [[UIImageView alloc] initWithImage:nil];
        if (AlertStr) {
            self->HUD.labelText = AlertStr;
        } else {
            self->HUD.labelText = NSLocalizedString(@"Loading", nil);
        }
        self->HUD.detailsLabelText = nil;
        [self->HUD setCenter:CGPointMake(JTools.winSize.width/2, (JTools.winSize.height-[UIApplication sharedApplication].statusBarFrame.size.height)/2)];
        self->HUD.layer.anchorPoint = CGPointMake(0.5,0.5); //Need #import <QuartzCore/QuartzCore.h>
        self->HUD.transform = CGAffineTransformIdentity;
        [self->HUD show:YES];
        if (time > 0) {
            self->HUD.mode = MBProgressHUDModeText;
            [self->HUD hide:YES afterDelay:time]; //需放在show:之後
        } else {
            self->HUD.mode = MBProgressHUDModeIndeterminate;
        }
        
        [VC.view addSubview:self->HUD];
        [VC.view bringSubviewToFront:self->HUD];
    });
}

-(void)StopHUD {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->HUD hide:YES];
        [self->HUD removeFromSuperview];
    });
}

@end
