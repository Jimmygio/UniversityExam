//
//  JHUD.h
//  XONE
//
//  Created by Chang Chin-Ming on 02/06/2017.
//  Copyright © 2017 Chang Chin-Ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHUD : NSObject

+ (instancetype)shared;

-(void)updateHUDProgress:(float)progress;
-(void)LoadHUD:(NSString*)str Progress:(float)progress;
-(void)LoadHUD:(NSString*)str DetailsLabel:(NSString *)detailStr Delay:(float)time;
-(void)LoadHUD:(NSString*)AlertStr Delay:(float)time;
-(void)LoadHUD:(NSString*)AlertStr Delay:(float)time inVC:(id)VC;
-(void)LoadHUD:(NSString*)AlertStr Delay:(float)time inView:(id)view;
-(void)StopHUD;

@end
