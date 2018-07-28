//
//  JTools.h
//  Pushme_Jimmy
//
//  Created by Jimmy Chang on 12/8/6.
//  Copyright (c) 2012年 牛奶股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "DataArchiver.h"
#import <iAd/iAd.h>

@class AppDelegate;

#define kDuration 0.3

#define JIntToString(i) [NSString stringWithFormat:@"%i", i]
CG_INLINE UIColor *JColor(float R, float G, float B, float Alpha) {
    return [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:Alpha];
}
CG_INLINE UIColor *JMainColor() {
    return JColor(75, 189, 200, 1);
}
CG_INLINE UIColor *JGrayColor() {
    return JColor(200, 200, 200, 1);
}
CG_INLINE UIColor *JRedColor() {
    return JColor(252, 0, 9, 1);
}
CG_INLINE UIColor *JOrangeColor() {
    return JColor(247, 156, 86, 1);
}
CG_INLINE UIColor *JYellowColor() {
//    return JColor(253, 225, 12, 1);
    return JColor(240, 213, 0, 1);
}
CG_INLINE UIColor *JGreenColor() {
    return JColor(64, 163, 42, 1);
}
CG_INLINE UIColor *JIndigoColor() {
    return JColor(58, 150, 249, 1);
}
CG_INLINE UIColor *JBlueColor() {
    return JColor(4, 54, 250, 1);
}
CG_INLINE UIColor *JVioletColor() {
    return JColor(109, 0, 254, 1);
}
CG_INLINE UIColor *JPinkColor() {
    return JColor(245, 0, 251, 1);
}
CG_INLINE UIColor *JLightBlueColor() {
    return JColor(56, 213, 211, 1);
}
CG_INLINE UIColor *JBrownColor() {
    return JColor(62, 52, 31, 1);
}

typedef enum : int {
    isVideoChat = 1,
    isVideoChat2 = 2,
} VideoChatAppType;

enum {
    isPending = 1,
    isDelivered = 2,
    isCancel = 3,
};

enum {
    isNotLogin,
    isLoginOk,
};

enum {
    noCall,
    isFreeCall,
    isPaiedCall,
};

enum {
    isNoCall,
    isOutgoing,
    isIncoming,
};

enum {
    isXONEAD,
    isFBAD,
    isFlurryAD,
};

CG_INLINE float JFrameX(UIView *MyView) {return MyView.frame.origin.x;}
CG_INLINE float JFrameY(UIView *MyView) {return MyView.frame.origin.y;}
CG_INLINE float JFrameW(UIView *MyView) {return MyView.frame.size.width;}
CG_INLINE float JFrameH(UIView *MyView) {return MyView.frame.size.height;}
CG_INLINE float JFrameYH(UIView *MyView) {return (MyView.frame.origin.y+MyView.frame.size.height);}
CG_INLINE BOOL JFrameSetX(UIView *MyView, float NewValue) {
    [MyView setFrame:CGRectMake(NewValue,
                                MyView.frame.origin.y,
                                MyView.frame.size.width,
                                MyView.frame.size.height)];
    return 0;
}
CG_INLINE BOOL JFrameSetY(UIView *MyView, float NewValue) {
    [MyView setFrame:CGRectMake(MyView.frame.origin.x,
                                NewValue,
                                MyView.frame.size.width,
                                MyView.frame.size.height)];
    return 0;
}
CG_INLINE BOOL JFrameSetW(UIView *MyView, float NewValue) {
    [MyView setFrame:CGRectMake(MyView.frame.origin.x,
                                MyView.frame.origin.y,
                                NewValue,
                                MyView.frame.size.height)];
    return 0;
}
CG_INLINE BOOL JFrameSetH(UIView *MyView, float NewValue) {
    [MyView setFrame:CGRectMake(MyView.frame.origin.x,
                                MyView.frame.origin.y,
                                MyView.frame.size.width,
                                NewValue)];
    return 0;
}
CG_INLINE BOOL JFrameChange(UIView *MyView, float X_Off, float Y_Off, float W_Off, float H_Off) {
    [MyView setFrame:CGRectMake(MyView.frame.origin.x + X_Off,
                                MyView.frame.origin.y + Y_Off,
                                MyView.frame.size.width + W_Off,
                                MyView.frame.size.height + H_Off)];
    return 0;
}
CG_INLINE NSString *JStrCombo(NSString *Str1, NSString *Str2, NSString *Str3) {
    return [NSString stringWithFormat:@"%@%@%@",Str1,Str2,Str3];
}
CG_INLINE BOOL JLogInt(int Obj1, NSString *Desc) {
    if (!Desc) Desc = @"";
    NSLog(@"%@ = %i", Desc, Obj1);
    return 0;
}
CG_INLINE BOOL JLogFloat(float Obj1, NSString *Desc) {
    if (!Desc) Desc = @"";
    NSLog(@"%@ = %f", Desc, Obj1);
    return 0;
}
CG_INLINE BOOL JLogStr(id Obj1, NSString *Desc) {
    if (!Desc) Desc = @"";
    NSLog(@"%@ = %@", Desc, Obj1);
    return 0;
}
CG_INLINE BOOL JLogStr2(id Obj1, id Obj2, NSString *Desc) {
    if (!Desc) Desc = @"";
    NSLog(@"%@ = %@, %@", Desc, Obj1, Obj2);
    return 0;
}

CG_INLINE UIImage *JImage(NSString *Name) {
    UIImage *Img = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/%@", Name]]];
    if (!Img) { //For non-retina use
        Img = [UIImage imageNamed:Name];
    }
    return Img;
}

typedef void (^imgBlock)(long ObjIndex, UIImage *img);
//typedef void (^thetaImgInfoBlock)(long value, long totalValue);

typedef void (^delayBlock)(void);
CG_INLINE void JDelay(float time, delayBlock myBlock) {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, time*NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (myBlock) {
            myBlock();
        }
    });
}

typedef void (^JToolsBlock)(NSMutableArray *array, BOOL success);
typedef void (^NormalBlock)(void);

#define CacheAppIconCount         500

@interface UIImageView (NameTag)
@property (nonatomic, strong) NSString *NameTag;
@end

@interface UIButton (NameTag)
@property (nonatomic, strong) NSString *NameTag;
@end

@interface UITextView (NameTag)
@property (nonatomic, strong) NSString *NameTag;
@end

@interface UITextView (SectionTag)
@property (nonatomic, strong) NSString *SectionTag;
@end

@interface UITextView (RowTag)
@property (nonatomic, strong) NSString *RowTag;
@end

@interface JTools : NSObject
+(NSMutableArray *)DicToArray:(NSDictionary *)nDic Key:(NSString *)Key;
+(NSString *)StrComboStr:(NSString *)Data Str:(NSString *)Data2 D:(NSString *)Debug;
+(NSString *)StrComboStr:(NSString *)Data int:(int)Data2 Str:(NSString *)Data3 D:(NSString *)Debug;
+(void)Layer:(id)View Bounds:(BOOL)B Radius:(float)R Width:(float)W Color:(UIColor *)C;
+(CGSize)winSize;
+(UIColor *)ColorR:(float)R G:(float)G B:(float)B Alpha:(float)Alpha;
+(float)RandomValueBetween:(float)low AndValue:(float)high;
+(UIImage *)ColorToImage:(UIColor *)color;
+(UIColor *)ImageToColor:(NSString *)ImageNmae;
+(void)SaveObj:(id)Obj Key:(NSString *)Key;
+(void)SaveObj:(id)Obj Key:(NSString *)Key Type:(BOOL)Type;
+(id)LoadObj:(NSString *)Key D:(NSString *)Debug;
+(id)LoadObj:(NSString *)Key D:(NSString *)Debug Type:(BOOL)Type;
+(void)SaveStrDefault:(id)Data Key:(NSString *)Key;
+(void)SaveIntDefault:(int)Data Key:(NSString *)Key;
+(void)SaveObjToWidget:(NSMutableArray *)array Key:(NSString *)Key;
+(NSString *)LoadStrDefault:(NSString *)Key D:(NSString *)Debug;
+(int)LoadIntDefault:(NSString *)Key D:(NSString *)Debug;
+(UIButton *)Button:(UIButton*)Btn Type:(UIButtonType)Type x:(float)x y:(float)y w:(float)w h:(float)h Title:(NSString*)Title TitleColor:(UIColor*)TitleColor Font:(UIFont*)Font BGImageName:(NSString *)Image BGImageTouch:(NSString *)ImageTouch BGColor:(UIColor*)BGColor BGColorTouch:(UIColor*)BGTouchColor;
+(UIButton *)Button:(UIButton*)Btn Type:(UIButtonType)Type x:(float)x y:(float)y w:(float)w h:(float)h Title:(NSString*)Title TitleColor:(UIColor*)TitleColor Font:(UIFont*)Font BGImageName:(NSString *)Image BGImageTouch:(NSString *)ImageTouch BGColor:(UIColor*)BGColor BGColorTouch:(UIColor*)BGTouchColor Layer:(BOOL)Layer Bounds:(BOOL)B Radius:(float)R Width:(float)W Color:(UIColor *)C;
+(void)Notification:(NSString *)Key;
+ (NSString *)ReplaceUnicode:(NSString *)unicodeStr;

+ (NSDictionary *)JSON_StrToDic:(NSString *)jsonstring;
+ (NSString *)JSON_DicToStr:(NSDictionary *)json;

+(UIImage*)ScaleImage:(UIImage*)image Scale:(float)scale;
+(UIImage*)ResizeImage:(UIImage*)image Size:(CGSize)size;
+(UIImage*)FitImage:(UIImage*)image Box:(CGSize)size Color:(UIColor*) color;
+(NSString *)IntToNSString:(int)i;
+(AppDelegate *)AppDelegate;
+(NSString *)GetCachePath:(NSString*)filename;
+(NSString *)GetDocPath:(NSString*)filename;
+(BOOL)AddSkipBackupAttributeToItemAtPath:(NSString *)filePathString;
+(void)ImgURL:(NSString*)URLStr Target:(UIView*)TargetView FromWeb:(BOOL)FromWeb Block:(imgBlock)Block;
+(void)ImgURL:(NSString*)URLStr Target:(UIView*)TargetView FromWeb:(BOOL)FromWeb BGColor:(UIColor *)BGColor LoadingView:(UIImageView *)LoadingView Block:(imgBlock)Block;
+(void)ImgURL:(NSString*)URLStr KeyURL:(NSString*)KeyURLStr Target:(UIView*)TargetView FromWeb:(BOOL)FromWeb BGColor:(UIColor *)BGColor LoadingView:(UIImageView *)LoadingView Block:(imgBlock)Block;
+(void)ImgURL_InfoWindow:(NSString*)URLStr Target:(UIView*)TargetView FromWeb:(BOOL)FromWeb Block:(imgBlock)Block;
+(void)ChangeNav:(UINavigationBar *)NavBar UINavColor:(UIColor *)NewColor NavImage:(UIImage *)NavImage BackBtnImage:(UIImage *)BackImage;
+(NSString *)AdjustURL:(NSString *)Str;
+(NSString *)AdjustStr:(NSString *)str;
+(CABasicAnimation *)AnimateKeyPath:(NSString *)keyPath FromValue:(id)from ToValue:(id)to Timing:(NSString *)timing;
+(void)Alert:(NSString *)str Message:(NSString *)subStr VC:(UIViewController *)vc;
+(void)Alert:(NSString *)str Message:(NSString *)subStr VC:(UIViewController *)vc Block:(JToolsBlock)block;
+(void)LabelShadow:(UILabel *)label;
+(void)UpdateStatusBarHeight:(UITabBar *)tabBar;
+(void)UpdateStatusBarHeight;
+(void)ToPortrait;
+(void)ToLandscape;
+(void)ToPortrait_force:(UIViewController *)vc;
+(void)ToLandscape_force:(UIViewController *)vc;
+(NSString *)getIPAddress;
+(NSMutableArray *)HandleProfile:(NSDictionary *)userDic;
+(int)CheckPhotosNumber:(NSArray *)scenesArray;
+(CGSize)sizeOfMultiLineLabel:(UILabel *)label;
+(NSString *)timeFormatted:(int)totalSeconds;
+(BOOL)validateEmail:(NSString *)emailStr;
+(int)randomNumbers;
+(int)convertToInt:(NSString*)strtemp;
+(UIViewController*)topViewController;
+(UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;
+(NSString *)createName:(NSString *)subject year:(NSString *)year Type:(NSString *)type;
+(void)openURL:(NSURL *)URL vc:(UIViewController *)vc;

@end
