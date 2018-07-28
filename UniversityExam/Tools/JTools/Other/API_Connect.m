//
//  API_Connect.m
//  Pushme_Jimmy
//
//  Created by Jimmy Chang on 13/1/2.
//  Copyright (c) 2013年 牛奶股份有限公司. All rights reserved.
//

#import "API_Connect.h"

@interface API_Connect() <NSURLSessionDataDelegate> {
    NSMutableData *ResultData;
    NSData *bodyData;
    uint64_t receivedDataLength;
    uint64_t expectedDataLength;
    API_Block myBlock;
    
    NSURLSession *session;
}
@end

@implementation API_Connect

- (void)API_StartPath:(NSString *)Path Data:(NSString *)body Type:(NSString *)Type Header:(NSDictionary *)headerDic Success:(API_Block)Block {
    NSLog(@"=== API Start ===\n Path = %@,\n Body = %@", Path, body);
    
//    //%號的問題(只有+不會被變到)
//    body = [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //API_report會有問題
//    //+號的問題
//    body = [body stringByReplacingOccurrencesOfString:@"+" withString:@"%2b"];
    NSLog(@"Body = %@", body);
    if (body) {
        bodyData = [body dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    } else {
        bodyData = nil;
    }

    myBlock = Block;
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[bodyData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:Path]];
    [request setHTTPMethod:Type];
    [request setTimeoutInterval:15.0];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    for (NSString *key in headerDic.allKeys) {
        [request setValue:headerDic[key] forHTTPHeaderField:key];
    }
    NSLog(@"postLength = %@", postLength);
    if ([Type isEqualToString:@"POST"] || [Type isEqualToString:@"DELETE"] || [Type isEqualToString:@"PATCH"]) {
        [request setHTTPBody:bodyData];
    }
    ResultData = [[NSMutableData alloc] init];

    //NSURLSession
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:sessionConfig
                                            delegate:self
                                       delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
    [session finishTasksAndInvalidate];
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
//    NSLog(@"response = %@", response);
    expectedDataLength = [response expectedContentLength];
    [ResultData setLength:0];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [ResultData appendData:data];
    receivedDataLength = [ResultData length];
    //    NSLog(@"receivedDataLength = %lu", (unsigned long)[ResultData length]);
    //    NSLog(@"expectedDataLength = %llu", expectedDataLength);
    if (myBlock) {
        myBlock(API_transform, nil, (float) receivedDataLength / expectedDataLength * 100, nil);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if (myBlock) {
        if (!error) {
            if (myBlock) {
                myBlock(API_success, ResultData, 100, error);
            }
        } else {
            myBlock(API_fail, nil, 0, error);
        }
    }
}

-(void)Cancel_API {
    [session invalidateAndCancel];
    [session finishTasksAndInvalidate];
}

@end
