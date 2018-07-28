//
//  API_Connect.h
//  Pushme_Jimmy
//
//  Created by Jimmy Chang on 13/1/2.
//  Copyright (c) 2013年 牛奶股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {    
    API_getThemePacket
} API_TYPE;

typedef enum {
    API_success,
    API_transform,
    API_fail
} BlockMode;

typedef void (^API_Block)(BlockMode APIResultFlag, id Data, float progress, NSError *error);

@interface API_Connect : NSObject

@property (nonatomic, assign) BOOL cancelFlag;

- (void)API_StartPath:(NSString *)Path Data:(NSString *)body Type:(NSString *)Type Header:(NSDictionary *)headerDic Success:(API_Block)Block;
- (void)Cancel_API;

@end
