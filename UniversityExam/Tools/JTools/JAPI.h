//
//  JAPI.h
//  EyeHouse
//
//  Created by Jimmy Chang on 3/24/16.
//  Copyright © 2016 Jimmy Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Callback_Block)(BOOL success, NSDictionary *dataDic, NSString *errorStr);
typedef void (^Callback_Block2)(BOOL success, NSArray *dataArray, NSString *errorStr);

@interface JAPI : NSObject

//抓取學測指考歷年資料
+ (void)API_exam:(Callback_Block)block;

//抓取日期跟url
+ (void)API_date:(Callback_Block)block;

//抓取AppList
+ (void)API_appList:(Callback_Block2)block;

@end
