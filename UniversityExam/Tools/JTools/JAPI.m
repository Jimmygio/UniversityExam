//
//  JAPI.m
//  EyeHouse
//
//  Created by Jimmy Chang on 3/24/16.
//  Copyright © 2016 Jimmy Chang. All rights reserved.
//

#import "JAPI.h"
#import "JConstants.h"
#import "API_Connect.h"

@interface JAPI ()

@end

@implementation JAPI

#pragma mark - 抓取學測指考歷年資料
+ (void)API_exam:(Callback_Block)block {
    NSString *urlStr = [NSString stringWithFormat: kAPILink, @"CllExamApi/sql/exam.php"];
    API_Connect *MyAPI_Connect = [API_Connect new];
    NSLog(@"API 抓取學測指考歷年資料 urlStr = %@", urlStr);
    [MyAPI_Connect API_StartPath:urlStr Data:nil Type:@"GET" Header:nil Success:^(BlockMode APIResultFlag, id Data, float progress, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (APIResultFlag) {
                case API_success:{
                    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:Data options:NSJSONReadingAllowFragments error:nil];
                    NSLog(@"抓取學測指考歷年資料 dataDic = %@", dataDic);
                    if (block) {
                        block(1, dataDic, nil);
                    }
                    break;}
                case API_transform:{
                    break;}
                case API_fail:{
                    if (block) {
                        block(0, nil, error.localizedDescription);
                    }
                    break;}
                    
                default:
                    break;
            }
        });
    }];
}

#pragma mark - 抓取日期跟url
+ (void)API_date:(Callback_Block)block {
    NSString *urlStr = [NSString stringWithFormat: kAPILink, @"CllExamApi/sql/date.php"];
    API_Connect *MyAPI_Connect = [API_Connect new];
    NSLog(@"API 抓取日期跟url urlStr = %@", urlStr);
    [MyAPI_Connect API_StartPath:urlStr Data:nil Type:@"GET" Header:nil Success:^(BlockMode APIResultFlag, id Data, float progress, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (APIResultFlag) {
                case API_success:{
                    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:Data options:NSJSONReadingAllowFragments error:nil];
                    NSLog(@"抓取日期跟url dataDic = %@", dataDic);
                    if (block) {
                        block(1, dataDic, nil);
                    }
                    break;}
                case API_transform:{
                    break;}
                case API_fail:{
                    if (block) {
                        block(0, nil, error.localizedDescription);
                    }
                    break;}
                    
                default:
                    break;
            }
        });
    }];
}

#pragma mark - 抓取AppList
+ (void)API_appList:(Callback_Block2)block {
    NSString *urlStr = kAppListLink;
    API_Connect *MyAPI_Connect = [API_Connect new];
    NSLog(@"API 抓取AppList urlStr = %@", urlStr);
    [MyAPI_Connect API_StartPath:urlStr Data:nil Type:@"GET" Header:nil Success:^(BlockMode APIResultFlag, id Data, float progress, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (APIResultFlag) {
                case API_success:{
                    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:Data options:NSJSONReadingAllowFragments error:nil];
                    NSLog(@"抓取AppList dataArray = %@", dataArray);
                    if (block) {
                        block(1, dataArray, nil);
                    }
                    break;}
                case API_transform:{
                    break;}
                case API_fail:{
                    if (block) {
                        block(0, nil, error.localizedDescription);
                    }
                    break;}
                    
                default:
                    break;
            }
        });
    }];
}

@end
