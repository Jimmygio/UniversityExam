//
//  JTools.m
//  Pushme_Jimmy
//
//  Created by Jimmy Chang on 12/8/6.
//  Copyright (c) 2012年 牛奶股份有限公司. All rights reserved.
//

#import "JTools.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+Block.h"

//Get ip
#include <ifaddrs.h>
#include <arpa/inet.h>

#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>

#import <SafariServices/SafariServices.h>

#import "UniversityExam-Swift.h"

#import <StoreKit/StoreKit.h>

@implementation UIImageView (NameTag)
@dynamic NameTag;
static char kNameTagKey;
- (void)setNameTag:(NSString *)NameTag
{
    objc_setAssociatedObject(self, &kNameTagKey, NameTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString*)NameTag
{
    return objc_getAssociatedObject(self, &kNameTagKey);
}
@end

@implementation UIButton (NameTag)
@dynamic NameTag;
static char kNameTagKey;
- (void)setNameTag:(NSString *)NameTag
{
    objc_setAssociatedObject(self, &kNameTagKey, NameTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString*)NameTag
{
    return objc_getAssociatedObject(self, &kNameTagKey);
}
@end

@implementation UITextView (NameTag)
@dynamic NameTag;
static char kNameTagKey;
- (void)setNameTag:(NSString *)NameTag
{
    objc_setAssociatedObject(self, &kNameTagKey, NameTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString*)NameTag
{
    return objc_getAssociatedObject(self, &kNameTagKey);
}
@end

@implementation UITextView (SectionTag)
@dynamic SectionTag;
static char kSectionTagKey;
- (void)setSectionTag:(NSString *)SectionTag
{
    objc_setAssociatedObject(self, &kSectionTagKey, SectionTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString*)SectionTag
{
    return objc_getAssociatedObject(self, &kSectionTagKey);
}
@end

@implementation UITextView (RowTag)
@dynamic RowTag;
static char kRowTagKey;
- (void)setRowTag:(NSString *)RowTag
{
    objc_setAssociatedObject(self, &kRowTagKey, RowTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString*)RowTag
{
    return objc_getAssociatedObject(self, &kRowTagKey);
}
@end

@implementation JTools

//Dictionary to Array
+(NSMutableArray *)DicToArray:(NSDictionary *)nDic Key:(NSString *)Key{
    if ([[nDic objectForKey:Key] isKindOfClass:[NSString class]]) { //不存在資料
        return nil;
    }
    if ([nDic objectForKey:Key] == nil) {
        return nil;
    }
    
    NSDictionary *nDic2 = [nDic objectForKey:Key];
    id DataCheck = nDic2;
    
    NSMutableArray *MyArray = [[NSMutableArray alloc] init];
    //不論如何都轉成Array
    if (![DataCheck isKindOfClass:[NSArray class]]) { //無法轉成NSARRAY表示只有一筆資料
        [MyArray addObject:DataCheck];
    } else {
        [MyArray addObjectsFromArray:DataCheck];
    }
    return MyArray;
}

//NSString Combo
+(NSString *)StrComboStr:(NSString *)Data Str:(NSString *)Data2 D:(NSString *)Debug {
    NSString *TempStr;
    if (Data) {
        if (Data2) {
            TempStr = [NSString stringWithFormat:@"%@%@", Data, Data2];
        } else {
            TempStr = Data;
        }
    } else {
        if (Data2) {
            TempStr = Data2;
        } else {
            TempStr = @"";
        }
    }
    if (Debug) {
        NSLog(@"%@ = %@", Debug, TempStr);
    }
    return TempStr;
}

+(NSString *)StrComboStr:(NSString *)Data int:(int)Data2 Str:(NSString *)Data3 D:(NSString *)Debug{
    NSString *TempStr;
    if (Data) {
        if (Data3) {
            TempStr = [NSString stringWithFormat:@"%@%i%@", Data, Data2, Data3];
        } else {
            TempStr = [NSString stringWithFormat:@"%@%i", Data, Data2];
        }
    } else {
        if (Data3) {
            TempStr = [NSString stringWithFormat:@"%i%@", Data2, Data3];
        } else {
            TempStr = [NSString stringWithFormat:@"%i", Data2];
        }
    }
    if (Debug) {
        NSLog(@"%@ = %@", Debug, TempStr);
    }
    return TempStr;
}

//Button Layer
+(void)Layer:(id)View Bounds:(BOOL)B Radius:(float)R Width:(float)W Color:(UIColor *)C {
    //设置layer
    CALayer *layerLogOutButton=[View layer];
    //是否设置边框以及是否可见
    [layerLogOutButton setMasksToBounds:B];
    //设置边框圆角的弧度
    [layerLogOutButton setCornerRadius:R];
    //设置边框线的宽
    [layerLogOutButton setBorderWidth:W];
    //设置边框线的颜色
    [layerLogOutButton setBorderColor:[C CGColor]];
    //當UIButton設為UIButtonTypeCustom時, 需設以下這行, 不然會有另一個Gray框
    //當UIButton設為UIButtonTypeCustom時, 才會有按下秀藍色的效果
    [layerLogOutButton setMasksToBounds:YES];
}

//winSize
+(CGSize)winSize {
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    return winSize;
}

//UIColor
+(UIColor *)ColorR:(float)R G:(float)G B:(float)B Alpha:(float)Alpha {
    return [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:Alpha];
}

//Random
+(float)RandomValueBetween:(float)low AndValue:(float)high {
    return (((float) arc4random() /0xFFFFFFFFu) * (high - low)) + low;
}

//UIColor to UIImage
+(UIImage *)ColorToImage:(UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    //    UIGraphicsBeginImageContext(rect.size);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//UIImage to UIColor
+(UIColor *)ImageToColor:(NSString *)ImageNmae {
    return [UIColor colorWithPatternImage:JImage(ImageNmae)];
}

//Save to Data(Caches)
+(void)SaveObj:(id)Obj Key:(NSString *)Key {
    [DataArchiver archivingDataWithObject:Obj forKey:Key];
}

//Save to Data(Document)
+(void)SaveObj:(id)Obj Key:(NSString *)Key Type:(BOOL)Type{
    [DataArchiver archivingDataWithObject:Obj forKey:Key Type:Type];
}

//Load from Data
+(id)LoadObj:(NSString *)Key D:(NSString *)Debug{
    if (Debug) {
        NSLog(@"%@ = %@", Debug , [DataArchiver unarchiver:Key]);
    }
    return [DataArchiver unarchiver:Key];
}

//Load from Data
+(id)LoadObj:(NSString *)Key D:(NSString *)Debug Type:(BOOL)Type{
    if (Debug) {
        NSLog(@"%@ = %@", Debug , [DataArchiver unarchiver:Key Type:Type]);
    }
    return [DataArchiver unarchiver:Key Type:Type];
}

//Save Str to NSUserDefault
+(void)SaveStrDefault:(id)Data Key:(NSString *)Key {
    [[NSUserDefaults standardUserDefaults] setObject:Data forKey:Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//Save int to NSUserDefault
+(void)SaveIntDefault:(int)Int Key:(NSString *)Key {
    [[NSUserDefaults standardUserDefaults] setInteger:Int forKey:Key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//Save Obj for Widget
+(void)SaveObjToWidget:(NSMutableArray *)array Key:(NSString *)Key {
    if (!array) return;
    array = [[[array reverseObjectEnumerator] allObjects] mutableCopy];
    NSMutableArray *tempArray = [NSMutableArray array];
    //    unsigned long totalnum;
    //    if ([array count] < 5) {
    //        totalnum = [array count];
    //    } else {
    //        totalnum = 5;
    //    }
    //    for (int i=0; i<totalnum; i++) {
    //        [tempArray addObject:array[i]];
    //    }
    for (int i=0; i<array.count; i++) {
        [tempArray addObject:array[i]];
    }
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.FirePtt"];
    [sharedDefaults setObject:tempArray forKey:Key];
    [sharedDefaults synchronize];
}

//Str Load from NSUserDefault
+(NSString *)LoadStrDefault:(NSString *)Key D:(NSString *)Debug{
    NSString *TempStr = [[NSUserDefaults standardUserDefaults] objectForKey:Key];
    if (Debug) {
        NSLog(@"%@ = %@", Debug , TempStr);
    }
    return TempStr;
}

//Int Load from NSUserDefault
+(int)LoadIntDefault:(NSString *)Key D:(NSString *)Debug {
    int i = (int)[[NSUserDefaults standardUserDefaults] integerForKey:Key];
    if (Debug) {
        NSLog(@"%@ = %i", Debug , i);
    }
    return i;
}

//Get AppDelegate
//+(AppDelegate *)AppDelegate {
//    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
//}

//UIButton
+(UIButton *)Button:(UIButton*)Btn Type:(UIButtonType)Type x:(float)x y:(float)y w:(float)w h:(float)h Title:(NSString*)Title TitleColor:(UIColor*)TitleColor Font:(UIFont*)Font BGImageName:(NSString *)Image BGImageTouch:(NSString *)ImageTouch BGColor:(UIColor*)BGColor BGColorTouch:(UIColor*)BGTouchColor
{
    return [JTools Button:Btn Type:Type x:x y:y w:w h:h Title:Title TitleColor:TitleColor Font:Font BGImageName:Image BGImageTouch:ImageTouch BGColor:BGColor BGColorTouch:BGTouchColor Layer:0 Bounds:0 Radius:0 Width:0 Color:nil];
}

+(UIButton *)Button:(UIButton*)Btn Type:(UIButtonType)Type x:(float)x y:(float)y w:(float)w h:(float)h Title:(NSString*)Title TitleColor:(UIColor*)TitleColor Font:(UIFont*)Font BGImageName:(NSString *)Image BGImageTouch:(NSString *)ImageTouch BGColor:(UIColor*)BGColor BGColorTouch:(UIColor*)BGTouchColor Layer:(BOOL)Layer Bounds:(BOOL)B Radius:(float)R Width:(float)W Color:(UIColor *)C
{
    //不存在就建立一個
    if (!Btn) {
        Btn = [UIButton buttonWithType:Type];
    }
    //寬高為0時不設
    if (w != 0 && h != 0) {
        [Btn setFrame:CGRectMake(x, y, w, h)];
    }
    //以下皆有指定才寫，無指定不寫
    if (Title) {
        [Btn setTitle:Title forState:UIControlStateNormal];
    }
    if (TitleColor) {
        [Btn setTitleColor:TitleColor forState:UIControlStateNormal];
    }
    if (Font) {
        [Btn.titleLabel setFont:Font];
    }
    if (Image) {
        [Btn setBackgroundImage:JImage(Image) forState:UIControlStateNormal];
    }
    if (ImageTouch) {
        [Btn setBackgroundImage:JImage(ImageTouch) forState:UIControlStateHighlighted];
    }
    if (BGColor) {
        [Btn setBackgroundColor:BGColor];
    }
    if (BGTouchColor) {
        [Btn setBackgroundImage:[JTools ColorToImage:BGTouchColor] forState:UIControlStateHighlighted];
    }
    if (Layer) {
        [JTools Layer:Btn Bounds:B Radius:R Width:W Color:C];
    }
    
    return Btn;
}

//NSNotification
+(void)Notification:(NSString *)Key
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Key object:self userInfo:nil];
}

//轉成用NSLog可以秀中文的字串
+ (NSString *)ReplaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData
                                                                    options:NSPropertyListImmutable
                                                                     format:NULL
                                                                      error:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

+ (NSDictionary *)JSON_StrToDic:(NSString *)jsonstring
{
    return  [NSJSONSerialization JSONObjectWithData:[jsonstring dataUsingEncoding:NSUTF8StringEncoding]  options: NSJSONReadingMutableContainers error:nil];
}

+ (NSString *)JSON_DicToStr:(NSDictionary *)json
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/* scale */
+(UIImage*)ScaleImage:(UIImage*)image Scale:(float)scale
{
    float new_width = image.size.width*scale;
    float new_height = image.size.height*scale;
    //    UIGraphicsBeginImageContext(CGSizeMake(new_width,new_height));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(new_width,new_height), NO, 0.0);
    
    [image drawInRect:CGRectMake(0,0,new_width, new_height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/* customized */
+(UIImage*)ResizeImage:(UIImage*)image Size:(CGSize)size
{
    //    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, 0.0);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
    
}

/* fill the background */
+(UIImage*)FitImage:(UIImage*)image Box:(CGSize)size Color:(UIColor*) color
{
    if ( image.size.width == size.width && image.size.height == size.height)
    {
        return image;
    }
    
    float margin_x = (size.width-image.size.width)/2;
    float margin_y = (size.height-image.size.height)/2;
    CGRect rect = CGRectMake(margin_x, margin_y, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContextWithOptions( size, NO, 0.0 );
    
    UIImage* temp = UIGraphicsGetImageFromCurrentImageContext();
    [color set];
    UIRectFill(CGRectMake(0.0, 0.0, temp.size.width, temp.size.height));
    [image drawInRect:rect];
    
    UIImage* fittedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return fittedImage;
}

//Int to NSString
+(NSString *)IntToNSString:(int)i {
    NSString *str = [NSString stringWithFormat:@"%i", i];
    return str;
}

//Get AppDelegate
+(AppDelegate *)AppDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

+(NSString *)GetCachePath:(NSString*)filename {
    NSArray *dirpathary = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *tempPath = [dirpathary firstObject];
    return [tempPath stringByAppendingPathComponent:filename];
}

+(NSString *)GetDocPath:(NSString*)filename {
    NSArray *dirpathary = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *tempPath = [dirpathary firstObject];
    if ([self AddSkipBackupAttributeToItemAtPath:tempPath]) {
        //        NSLog(@"預防物件Path被複製到iCloud上 = %@", tempPath);
    }
    return [tempPath stringByAppendingPathComponent:filename];
}

+(BOOL)AddSkipBackupAttributeToItemAtPath:(NSString *)filePathString {
    NSURL* URL= [NSURL fileURLWithPath:filePathString];
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

//Load Url Img
+(void)ImgURL:(NSString*)URLStr Target:(UIView*)TargetView FromWeb:(BOOL)FromWeb Block:(imgBlock)Block {
    [JTools ImgURL:URLStr Target:TargetView FromWeb:FromWeb BGColor:[UIColor clearColor] LoadingView:nil Block:Block];
}

//Load Url Img
+(void)ImgURL:(NSString*)URLStr Target:(UIView*)TargetView FromWeb:(BOOL)FromWeb BGColor:(UIColor *)BGColor LoadingView:(UIImageView *)LoadingView Block:(imgBlock)Block {
    [JTools ImgURL:URLStr KeyURL:URLStr Target:TargetView FromWeb:FromWeb BGColor:BGColor LoadingView:LoadingView Block:Block];
}

//Load Url Img
+(void)ImgURL:(NSString*)URLStr KeyURL:(NSString*)KeyURLStr Target:(UIView*)TargetView FromWeb:(BOOL)FromWeb BGColor:(UIColor *)BGColor LoadingView:(UIImageView *)LoadingView Block:(imgBlock)Block {
    if (!URLStr) {
        if ([TargetView isKindOfClass:[UIImageView class]]) {
            if (Block) {
                Block(0, ((UIImageView *)TargetView).image);
            }
        } else if ([TargetView isKindOfClass:[UIButton class]]) {
            if (Block) {
                Block(0, ((UIButton *)TargetView).imageView.image);
            }
        }
        return;
    }
    
//    URLStr = [URLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __block NSString *MyURLStr = URLStr;
    __block NSString *MyURLStrKey = [JTools AdjustURL:KeyURLStr];
    //Swift會把image清掉
    if ([TargetView isKindOfClass:[UIImageView class]]) {
        if ([((UIImageView *)TargetView).NameTag isEqualToString:MyURLStrKey] && ((UIImageView *)TargetView).image) {
            if (Block) {
                Block(1, ((UIImageView *)TargetView).image);
            }
            return;
        }
    } else if ([TargetView isKindOfClass:[UIButton class]] && ((UIButton *)TargetView).imageView.image) {
        if ([((UIButton *)TargetView).NameTag isEqualToString:MyURLStrKey]) {
            if (Block) {
                Block(1, ((UIButton *)TargetView).imageView.image);
            }
            return;
        }
    }
    dispatch_queue_t myImgQueue = dispatch_queue_create("IMG_QUEUE", NULL);
    dispatch_async(myImgQueue, ^{
        NSData *TempData;
        if (![[NSFileManager defaultManager] fileExistsAtPath:[JTools GetCachePath:MyURLStrKey]] || FromWeb == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (LoadingView) {
                    LoadingView.contentMode = UIViewContentModeScaleAspectFill;
                    [LoadingView setFrame:CGRectMake(0, 0, JFrameW(TargetView), JFrameH(TargetView))];
                    LoadingView.hidden = NO;
                    [TargetView addSubview:LoadingView];
                }
            });
            
            TempData = [NSData dataWithContentsOfURL:[NSURL URLWithString:MyURLStr]];
            [TempData writeToFile:[JTools GetCachePath:MyURLStrKey] atomically:YES];
            //Check Num
            NSMutableArray *TempArray = [JTools LoadObj:@"kImgs" D:nil];
            if (!TempArray) TempArray = [NSMutableArray array];
            [TempArray addObject:MyURLStrKey];
            if ([TempArray count] > CacheAppIconCount) {
                [[NSFileManager defaultManager] removeItemAtPath:[JTools GetCachePath:TempArray[0]] error:nil];
                [TempArray removeObjectAtIndex:0];
            }
            [JTools SaveObj:TempArray Key:@"kImgs"]; //存cache
        } else {
            TempData = [NSData dataWithContentsOfFile:[JTools GetCachePath:MyURLStrKey]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *img = [UIImage imageWithData:TempData];
            [LoadingView removeFromSuperview];
            if ([TargetView isKindOfClass:[UIImageView class]]) {
                [((UIImageView *)TargetView) setImage:img];
                [((UIImageView *)TargetView) setNameTag:MyURLStrKey];
                if (Block) {
                    Block(2, img);
                }
            } else if ([TargetView isKindOfClass:[UIButton class]]) {
                [((UIButton *)TargetView) setImage:img forState:UIControlStateNormal];
                [((UIButton *)TargetView) setNameTag:MyURLStrKey];
                if (Block) {
                    Block(2, img);
                }
            } else if (TargetView == nil) {
                if (Block) {
                    Block(2, img);
                }
           }
        });
    });
}

+(void)ImgURL_InfoWindow:(NSString*)URLStr Target:(UIView*)TargetView FromWeb:(BOOL)FromWeb Block:(imgBlock)Block {
//    URLStr = [URLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __block NSString *MyURLStr = URLStr;
    __block NSString *MyURLStrKey = [JTools AdjustURL:URLStr];
    NSData *TempData;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[JTools GetCachePath:MyURLStrKey]] || FromWeb == 1) {
        
        TempData = [NSData dataWithContentsOfURL:[NSURL URLWithString:MyURLStr]];
        [TempData writeToFile:[JTools GetCachePath:MyURLStrKey] atomically:YES];
        //Check Num
        NSMutableArray *TempArray = [JTools LoadObj:@"kImgs" D:nil];
        if (!TempArray) TempArray = [NSMutableArray array];
        [TempArray addObject:MyURLStrKey];
        if ([TempArray count] > CacheAppIconCount) {
            [[NSFileManager defaultManager] removeItemAtPath:[JTools GetCachePath:TempArray[0]] error:nil];
            [TempArray removeObjectAtIndex:0];
        }
        [JTools SaveObj:TempArray Key:@"kImgs"]; //存cache
    } else {
        TempData = [NSData dataWithContentsOfFile:[JTools GetCachePath:MyURLStrKey]];
    }
    
    UIImage *img = [UIImage imageWithData:TempData];
    if ([TargetView isKindOfClass:[UIImageView class]]) {
        [((UIImageView *)TargetView) setImage:img];
        [((UIImageView *)TargetView) setNameTag:MyURLStrKey];
        if (Block) {
            Block(2, img);
        }
    }
}

+(NSString *)AdjustURL:(NSString *)MyUrl {
    MyUrl = [MyUrl stringByReplacingOccurrencesOfString:@"/" withString:@""]; //有/的話當key會存不起來
    MyUrl = [MyUrl stringByReplacingOccurrencesOfString:@"." withString:@""];
    MyUrl = [MyUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
    MyUrl = [MyUrl stringByReplacingOccurrencesOfString:@"http" withString:@""];
    MyUrl = [MyUrl stringByReplacingOccurrencesOfString:@"Http" withString:@""];
    MyUrl = [MyUrl stringByReplacingOccurrencesOfString:@":" withString:@""];
    MyUrl = [MyUrl stringByReplacingOccurrencesOfString:@"?" withString:@""];
    MyUrl = [MyUrl stringByReplacingOccurrencesOfString:@"=" withString:@""];
    return MyUrl;
}

+(NSString *)AdjustStr:(NSString *)str {
    str = [str stringByReplacingOccurrencesOfString:@"/>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@">" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    //    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return str;
}

+(void)ChangeNav:(UINavigationBar *)NavBar UINavColor:(UIColor *)NewColor NavImage:(UIImage *)NavImage BackBtnImage:(UIImage *)BackImage {
    //NavBar
    [NavBar setBarStyle:UIBarStyleBlack];//StatusBar is black
    [NavBar setBackgroundImage:NavImage forBarMetrics:UIBarMetricsDefault];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          NewColor, NSForegroundColorAttributeName,
                          //                          [UIColor whiteColor], NSShadowAttributeName,
                          [UIFont systemFontOfSize:20.0], NSFontAttributeName,
                          nil];
    NavBar.titleTextAttributes = dict;
    
    //NavBackBtn
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            [UIColor whiteColor], NSForegroundColorAttributeName,
            //            [UIColor whiteColor], NSShadowAttributeName,
            [UIFont boldSystemFontOfSize:13.0], NSFontAttributeName,
            nil];
    [[UIBarButtonItem appearance] setTitleTextAttributes:dict forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:BackImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

+(CABasicAnimation *)AnimateKeyPath:(NSString *)keyPath FromValue:(id)from ToValue:(id)to Timing:(NSString *)timing {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = from;
    animation.toValue = to;
    animation.repeatCount = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timing];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = kDuration;
    return animation;
}

+ (void)Alert:(NSString *)str Message:(NSString *)subStr VC:(UIViewController *)vc {
    UIAlertController *AC = [UIAlertController alertControllerWithTitle:str
                                                                message:subStr
                                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                     }];
    [AC addAction:okAction];
    [vc presentViewController:AC animated:YES completion:nil];
}

+(void)Alert:(NSString *)str Message:(NSString *)subStr VC:(UIViewController *)vc Block:(JToolsBlock)block {
    UIAlertController *AC = [UIAlertController alertControllerWithTitle:str
                                                                message:subStr
                                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action){
                                                         if (block) {
                                                             block(nil, 1);
                                                         }
                                                     }];
    [AC addAction:okAction];
    [vc presentViewController:AC animated:YES completion:nil];
}

+ (void)LabelShadow:(UILabel *)label {
    label.layer.shadowOpacity = 1.0;
    label.layer.shadowRadius = 1;
    label.layer.shadowColor = [UIColor blackColor].CGColor;
    label.layer.shadowOffset = CGSizeMake(1, 1);
}

+ (void)UpdateStatusBarHeight:(UITabBar *)tabBar {
    float screen_H;
    if ([UIApplication sharedApplication].statusBarFrame.size.height == 40) {
        screen_H = [UIScreen mainScreen].bounds.size.height-20;
    } else {
        screen_H = [UIScreen mainScreen].bounds.size.height;
    }
    //    winSize.height = screen_H;
    JFrameSetY(tabBar, screen_H-JFrameH(tabBar));
}

+ (void)UpdateStatusBarHeight {
    UITabBar *tabBar = ((UITabBarController *)[JTools AppDelegate].window.rootViewController).tabBar;
    //    NSLog(@"[UIApplication sharedApplication].statusBarFrame.size.height = %f", [UIApplication sharedApplication].statusBarFrame.size.height);
    //調整開啟個人傳送點的位移
    [self UpdateStatusBarHeight:tabBar];
}

+ (void)ToPortrait {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    NSLog(@"Portrait %ld", (long)orientation);
    //若現在為橫向強制變直向
    if (orientation != UIDeviceOrientationPortrait) {
        NSNumber *value = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    } else if (orientation == UIDeviceOrientationPortrait ) { //避免有時判斷錯誤
        NSNumber *value = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
}

//UIDeviceOrientation
+ (void)ToLandscape {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    NSLog(@"Landscape %ld", (long)orientation);
    //若現在為直向強制變橫向
    if (orientation != UIDeviceOrientationLandscapeLeft && orientation != UIDeviceOrientationLandscapeRight) {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    } else if (orientation == UIDeviceOrientationLandscapeLeft ) { //避免有時判斷錯誤
        NSNumber *value = [NSNumber numberWithInt:UIDeviceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    } else if (orientation == UIDeviceOrientationLandscapeRight ) { //避免有時判斷錯誤
        NSNumber *value = [NSNumber numberWithInt:UIDeviceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
}

//http://stackoverflow.com/questions/23111407/can-i-manually-trigger-whatever-calls-supportedinterfaceorientations-on-my-viewc
//好狠的做法，這樣才會重跑shouldAutorotate跟supportedInterfaceOrientations
+ (void)ToPortrait_force:(UIViewController *)vc {
    BOOL force = YES;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationLandscapeLeft) {
        force = NO;
    }
    if (force) {
        __block UIViewController *newVC = [[UIViewController alloc] init];
        [vc presentViewController:newVC animated:NO completion:^(void){
            NSLog(@"forcing VC has been presented.");
            [newVC dismissViewControllerAnimated:NO completion:^(void){
                NSLog(@"forcing VC has been dismissed");
            }];
        }];
    }
}

+ (void)ToLandscape_force:(UIViewController *)vc {
    BOOL force = YES;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIDeviceOrientationLandscapeRight || orientation == UIDeviceOrientationLandscapeLeft) {
        force = NO;
    }
    if (force) {
        __block UIViewController *newVC = [[UIViewController alloc] init];
        [vc presentViewController:newVC animated:NO completion:^(void){
            NSLog(@"forcing VC has been presented.");
            [newVC dismissViewControllerAnimated:NO completion:^(void){
                NSLog(@"forcing VC has been dismissed");
            }];
        }];
    }
}

+ (NSString *)getIPAddress {
//    NSString *address = @"error";
//    struct ifaddrs *interfaces = NULL;
//    struct ifaddrs *temp_addr = NULL;
//    int success = 0;
//    // retrieve the current interfaces - returns 0 on success
//    success = getifaddrs(&interfaces);
//    if (success == 0) {
//        // Loop through linked list of interfaces
//        temp_addr = interfaces;
//        while(temp_addr != NULL) {
//            if(temp_addr->ifa_addr->sa_family == AF_INET) {
//                // Check if interface is en0 which is the wifi connection on the iPhone
//                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
//                    // Get NSString from C String
//                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
//                    
//                }
//                
//            }
//            
//            temp_addr = temp_addr->ifa_next;
//        }
//    }
//    // Free memory
//    freeifaddrs(interfaces);
    //https://stackoverflow.com/questions/33125710/how-to-get-ipv6-interface-address-using-getifaddr-function/33127330#33127330
    NSString *ipAddress = @"error";
    struct ifaddrs *ifa, *ifa_tmp;
    char addr[50];
    
    if (getifaddrs(&ifa) == -1) {
        perror("getifaddrs failed");
        exit(1);
    }
    
    ifa_tmp = ifa;
    while (ifa_tmp) {
        if ((ifa_tmp->ifa_addr) && ((ifa_tmp->ifa_addr->sa_family == AF_INET) ||
                                    (ifa_tmp->ifa_addr->sa_family == AF_INET6))) {
            if (ifa_tmp->ifa_addr->sa_family == AF_INET) {
                // create IPv4 string
                struct sockaddr_in *in = (struct sockaddr_in*) ifa_tmp->ifa_addr;
                inet_ntop(AF_INET, &in->sin_addr, addr, sizeof(addr));
            } else { // AF_INET6
                // create IPv6 string
                struct sockaddr_in6 *in6 = (struct sockaddr_in6*) ifa_tmp->ifa_addr;
                inet_ntop(AF_INET6, &in6->sin6_addr, addr, sizeof(addr));
            }
//            printf("name = %s\n", ifa_tmp->ifa_name);
//            printf("addr = %s\n", addr);
        }
        ifa_tmp = ifa_tmp->ifa_next;
    }
    ipAddress = [NSString stringWithUTF8String:addr];
//    NSLog(@"ipAddress = %@", ipAddress);
    
    return ipAddress;
}

+ (NSMutableArray *)HandleProfile:(NSDictionary *)userDic {
    NSMutableArray *profileTempArray = [NSMutableArray array];
    NSString *tempStr;
    
    if (userDic[@"display_name"] != [NSNull null]) {
        tempStr = userDic[@"display_name"];
        if (tempStr.length == 0) tempStr = @" ";
    } else {
        tempStr = @" ";
    }
    [profileTempArray addObject:@{NSLocalizedString(@"Contact", nil):tempStr}];
    
    //姓別
    if (userDic[@"gender"] != [NSNull null]) {
        if ([userDic[@"gender"] boolValue] == 0) {
            tempStr = NSLocalizedString(@"Mister", nil);
        } else {
            tempStr = NSLocalizedString(@"Miss", nil);
        }
    } else {
        tempStr = @" ";
    }
    [profileTempArray addObject:@{NSLocalizedString(@"Gender", nil):tempStr}];
    
    //自我介紹
    if (userDic[@"self_intro"] != [NSNull null]) {
        tempStr = userDic[@"self_intro"];
        if (tempStr.length == 0) tempStr = @" ";
    } else {
        tempStr = @" ";
    }
    [profileTempArray addObject:@{NSLocalizedString(@"Self Introduction", nil):tempStr}];
    
    
    if (userDic[@"profile"] != [NSNull null]) {
        //聯絡電話1
        if (userDic[@"profile"][@"phone_number1"] != [NSNull null]) {
            tempStr = userDic[@"profile"][@"phone_number1"];
            if (tempStr.length == 0) tempStr = @" ";
        } else {
            tempStr = @" ";
        }
        [profileTempArray addObject:@{NSLocalizedString(@"Phone Number 1", nil):tempStr}];
        
        //聯絡電話2
        if (userDic[@"profile"][@"phone_number2"] != [NSNull null]) {
            tempStr = userDic[@"profile"][@"phone_number2"];
            if (tempStr.length == 0) tempStr = @" ";
        } else {
            tempStr = @" ";
        }
        [profileTempArray addObject:@{NSLocalizedString(@"Phone Number 2", nil):tempStr}];
        
        //地址
        if (userDic[@"profile"][@"address"] != [NSNull null]) {
            tempStr = userDic[@"profile"][@"address"];
            if (tempStr.length == 0) tempStr = @" ";
        } else {
            tempStr = @" ";
        }
        [profileTempArray addObject:@{NSLocalizedString(@"Address", nil):tempStr}];
        
        //公司
        if (userDic[@"profile"][@"company_name"] != [NSNull null]) {
            tempStr = userDic[@"profile"][@"company_name"];
            if (tempStr.length == 0) tempStr = @" ";
        } else {
            tempStr = @" ";
        }
        [profileTempArray addObject:@{NSLocalizedString(@"Company", nil):tempStr}];
        
        //職業
        if (userDic[@"profile"][@"job"] != [NSNull null]) {
            tempStr = userDic[@"profile"][@"job"];
            if (tempStr.length == 0) tempStr = @" ";
        } else {
            tempStr = @" ";
        }
        [profileTempArray addObject:@{NSLocalizedString(@"Job", nil):tempStr}];
        
        //職稱
        if (userDic[@"profile"][@"job_title"] != [NSNull null]) {
            tempStr = userDic[@"profile"][@"job_title"];
            if (tempStr.length == 0) tempStr = @" ";
        } else {
            tempStr = @" ";
        }
        [profileTempArray addObject:@{NSLocalizedString(@"Job Title", nil):tempStr}];
    } else {
        //聯絡電話1
        tempStr = @" ";
        [profileTempArray addObject:@{NSLocalizedString(@"Phone Number 1", nil):tempStr}];
        
        //聯絡電話2
        [profileTempArray addObject:@{NSLocalizedString(@"Phone Number 2", nil):tempStr}];
        
        //地址
        [profileTempArray addObject:@{NSLocalizedString(@"Address", nil):tempStr}];
        
        //公司
        [profileTempArray addObject:@{NSLocalizedString(@"Company", nil):tempStr}];
        
        //職業
        [profileTempArray addObject:@{NSLocalizedString(@"Job", nil):tempStr}];
        
        //職稱
        [profileTempArray addObject:@{NSLocalizedString(@"Job Title", nil):tempStr}];
    }
    
    return profileTempArray;
}

+ (int)CheckPhotosNumber:(NSArray *)scenesArray {
    //判斷是1張圖還是6張圖
    int photosNumber = 6;
    for (int i=0; i<scenesArray.count; i++) {
        if (scenesArray[i][@"pano_images_zip_url"] == [NSNull null]) {
            photosNumber = 1;
            break;
        }
        if (scenesArray[i][@"pano_height"] != [NSNull null] && scenesArray[i][@"pano_width"] != [NSNull null]) {
            float height = [scenesArray[i][@"pano_height"] floatValue];
            float width = [scenesArray[i][@"pano_width"] floatValue];
            float ratio = width/height;
            if (ratio < 1.99 || ratio > 2.01) { //非全景(非2:1)
                photosNumber = 1;
                break;
            }
        }
    }
    return photosNumber;
}

+ (CGSize)sizeOfMultiLineLabel:(UILabel *)label {
    NSString *aLabelTextString = [label text];
    
    //Label font
    UIFont *aLabelFont = [label font];
    
    //Width of the Label
    CGFloat aLabelSizeWidth = label.frame.size.width;
    
    //Return the calculated size of the Label
    return [aLabelTextString boundingRectWithSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:aLabelFont}
                                          context:nil].size;
}

+ (NSString *)timeFormatted:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    NSString *time;
    if (hours == 0) {
        time = [NSString stringWithFormat:@"%02d:%02d", minutes ,seconds];
    } else {
        time = [NSString stringWithFormat:@"%02d:%02d:%02d", hours ,minutes ,seconds];
    }
    
    return time;
}

+(BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

+(NSString *)randomStringWithLength:(int)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((u_int32_t)[letters length])]];
    }
    
    return randomString;
}

// md5
+(NSString *)md5WithString:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSString *)hmacSha1_publickey:(NSString*)public_key privateKey:(NSString*)private_key{
    NSData* secretData = [private_key dataUsingEncoding:NSUTF8StringEncoding];
    NSData* stringData = [public_key dataUsingEncoding:NSUTF8StringEncoding];
    
    const void* keyBytes = [secretData bytes];
    const void* dataBytes = [stringData bytes];
    
    ///#define CC_SHA1_DIGEST_LENGTH   20          /* digest length in bytes */
    void* outs = malloc(CC_SHA1_DIGEST_LENGTH);
    
    CCHmac(kCCHmacAlgSHA1, keyBytes, [secretData length], dataBytes, [stringData length], outs);
    
    // Soluion 1
    NSData* signatureData = [NSData dataWithBytesNoCopy:outs length:CC_SHA1_DIGEST_LENGTH freeWhenDone:YES];
    //    return [signatureData base64EncodedString];
    
    NSString *str = [signatureData base64EncodedStringWithOptions:0];
    return str;
    //    NSString *key = [JTools stringByEncodingURLFormat:str];
    //    return key;
}

+ (int)randomNumbers {
    int i = arc4random() % 500 + 500;
//    NSLog(@"Random Number: %i", i);
    return i;
}

//漢字2個位元組，英文以及符號1個位元組
+ (int)convertToInt:(NSString*)strtemp {
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

+ (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

+ (NSString *)createName:(NSString *)subject year:(NSString *)year Type:(NSString *)type {
    NSString *URLStr;
    year = [year stringByReplacingOccurrencesOfString:@"學年" withString:@""];
    if ([year containsString:@"(補考)"]) { //屬於補考
        year = [year stringByReplacingOccurrencesOfString:@"(補考)" withString:@""];
        if ([year intValue] < 100) {
            year = [NSString stringWithFormat:@"0%@", year];
        }
        URLStr = [NSString stringWithFormat:@"%@%@_%@_2", type, subject, year];
    } else {
        if ([year intValue] < 100) {
            year = [NSString stringWithFormat:@"0%@", year];
        }
        URLStr = [NSString stringWithFormat:@"%@%@_%@", type, subject, year];
    }
    
    return URLStr;
}

+ (void)openURL:(NSURL *)URL vc:(UIViewController *)vc {
    if ([SFSafariViewController class] != nil) {
        SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:URL];
        [vc presentViewController:sfvc animated:YES completion:nil];
    } else {
        [[UIApplication sharedApplication] openURL:URL];
    }
}

@end
