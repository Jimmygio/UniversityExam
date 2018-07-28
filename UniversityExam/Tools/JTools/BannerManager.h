//
//  BannerManager.h
//  XONE
//
//  Created by Chang Chin-Ming on 08/06/2017.
//  Copyright © 2017 Chang Chin-Ming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTools.h"

@class BannerManager;
@protocol BannerManagerDelegate <NSObject>
@optional
- (void)bannerFin:(NSNotification *)notif;
@end

@interface BannerManager : NSObject

@property (nonatomic, assign) id<BannerManagerDelegate> delegate;

+ (instancetype)shared;
- (void)loadBanner:(NSString *)str success:(BOOL)isSuccess;
- (void)loadBanner:(NSString *)str img:(UIImage *)img bgColor:(UIColor *)color;

@end
