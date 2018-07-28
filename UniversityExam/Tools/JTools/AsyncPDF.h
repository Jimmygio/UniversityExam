//
//  AsyncPDF.h
//  UniversityExam
//
//  Created by Jimmy Chang on 12/10/12.
//  Copyright (c) 2012年 Jimmy Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataArchiver.h"
#import "JTools.h"

#define cachePDFCount 500

@interface AsyncPDF : NSObject

@property (assign, nonatomic) int dlStatus;
@property (strong, nonatomic) NSData* myData;

- (void)loadPDFFromURL:(NSURL*)url title:(NSString *)titleStr;

@end
