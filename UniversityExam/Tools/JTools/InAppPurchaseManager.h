//
//  InAppPurchaseManager.h
//  UniversityExam
//
//  Created by Jimmy Chang on 12/10/18.
//  Copyright (c) 2012年 Jimmy Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef void (^IAPBlock)(NSArray *myProducts);

@class InAppPurchaseManager;
@protocol InAppPurchaseManagerDelegate <NSObject>
@optional
- (void)IAP_Succeed:(SKPaymentTransaction *)transaction;
- (void)IAP_RestoreSucceed;
- (void)IAP_Failed;
@end

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> 

@property (strong, nonatomic) SKProduct *myProduct;
@property (nonatomic, assign) id<InAppPurchaseManagerDelegate> delegate;

// public methods
- (void)loadStore:(NSSet *)productIdentifiers block:(IAPBlock)IAPBlock;
- (BOOL)canMakePurchases;
- (void)purchase:(SKProduct *)myProduct;

@end
