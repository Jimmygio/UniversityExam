//
//  AsyncPDF.m
//  UniversityExam
//
//  Created by Jimmy Chang on 12/10/12.
//  Copyright (c) 2012年 Jimmy Chang. All rights reserved.
//

#import "AsyncPDF.h"
#import "JConstants.h"

@implementation AsyncPDF

- (void)loadPDFFromURL:(NSURL*)url title:(NSString *)titleStr {
    NSString *urlStr = [NSString stringWithFormat:@"%@",url];
    NSString *nameStr = [urlStr stringByReplacingOccurrencesOfString:@".pdf" withString:@""];
    nameStr = [[nameStr componentsSeparatedByString:@"/"] lastObject]; //ex: 0CHI_106_E
    NSArray *array = [nameStr componentsSeparatedByString:@"_"];
    if ([[array lastObject] isEqualToString:@"E"]) {
        nameStr = [NSString stringWithFormat:@"%@考卷.pdf", titleStr];
    } else if ([[array lastObject] isEqualToString:@"A1"]) {
        nameStr = [NSString stringWithFormat:@"%@答案.pdf", titleStr];
    } else if ([[array lastObject] isEqualToString:@"A2"]) {
        nameStr = [NSString stringWithFormat:@"%@非選擇.pdf", titleStr];
    }
    
    NSLog(@"urlStr = %@", urlStr);
    NSLog(@"nameStr = %@", nameStr);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSData *PDFData = [NSData dataWithContentsOfFile:[JTools GetDocPath:nameStr]];
    if (PDFData) {
        _myData = [[NSData alloc] initWithData:PDFData];
        _dlStatus = 1;
        [[NSNotificationCenter defaultCenter] postNotificationName:kDatatReady object:nil];
    } else {
        _myData = [[NSData alloc] initWithData:PDFData];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if ([data length] > 0 && error == nil) {
                self->_myData = data;
                [data writeToFile:[JTools GetDocPath:nameStr] atomically:YES];
                NSMutableArray *listArray = [[JTools LoadObj:kSaveList D:nil Type:YES] mutableCopy];
                BOOL isExist = 0;
                for (int i=0; i<listArray.count; i++) {
                    if ([listArray[i] isEqualToString: [nameStr stringByReplacingOccurrencesOfString:@".pdf" withString:@""]]) {
                        isExist = 1;
                    }
                }
                if (isExist == 0) {
                    [listArray addObject:nameStr];
                }
                if (listArray.count > cachePDFCount) {
                    [[NSFileManager defaultManager] removeItemAtPath:[JTools GetDocPath:[NSString stringWithFormat:@"%@.pdf", [listArray firstObject]]] error:nil];
                    [listArray removeObjectAtIndex:0];
                }
                [JTools SaveObj:listArray Key:kSaveList Type:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_dlStatus = 1;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDatatReady object:nil];
                });
            } else if ([data length] == 0 && error == nil) {
                NSLog(@"Downloading...");
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_dlStatus = 2;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDatatReady object:nil];
                });
            } else if (error != nil) {
                NSLog(@"Error = %@", error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_dlStatus = 2;
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDatatReady object:nil];
                });
            }
        }];
        [dataTask resume];
        [session finishTasksAndInvalidate];
    }
}

@end
