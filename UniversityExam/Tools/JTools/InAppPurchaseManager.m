//
//  InAppPurchaseManager.m
//  UniversityExam
//
//  Created by Jimmy Chang on 12/10/18.
//  Copyright (c) 2012年 Jimmy Chang. All rights reserved.
//

#import "InAppPurchaseManager.h"
#import "JTools.h"
#import "BannerManager.h"
#import "JConstants.h"

@interface InAppPurchaseManager()
{
    SKProductsRequest *productsRequest;
    IAPBlock myBlock;
}
@end

@implementation InAppPurchaseManager

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *myProducts = response.products;
    if (myBlock) {
        myBlock(myProducts);
    }
}

#pragma mark SKRequestDelegate //jimmy
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    if (myBlock) {
        myBlock(nil);
    }
}

#pragma -
#pragma Public methods

//
// call this method once on startup
//
- (void)loadStore:(NSSet *)productIdentifiers block:(IAPBlock)IAPBlock
{
    myBlock = IAPBlock;
    
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    productsRequest.delegate = nil;
    [productsRequest cancel];
    productsRequest = nil;

    JDelay(0.1, ^{
        // get the product description (defined in early sections)
//        NSSet *productIdentifiers = [NSSet setWithObject:IDStr];
        self->productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
        self->productsRequest.delegate = self;
        [self->productsRequest start];
    });
    // we will release the request object in the delegate callback
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchase:(SKProduct *)myProduct
{
//    [[JTools AppDelegate] LoadHUD:LDic[@"Loading"] Delay:0];
    NSLog(@"欲購買的項目：myProduct = %@", myProduct);
    NSLog(@"Product title: %@" , myProduct.localizedTitle);
    NSLog(@"Product description: %@" , myProduct.localizedDescription);
    NSLog(@"Product price: %@" , myProduct.price);
    NSLog(@"Product id: %@" , myProduct.productIdentifier);
    if (!myProduct) {
//        [JTools Alert:LDic[@"Purchase fail"] Message:nil VC:(UIViewController *)_delegate];
        [[BannerManager shared] loadBanner:@"購買失敗" success:NO];
        return;
    }

    SKPayment *payment = [SKPayment paymentWithProduct:myProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:kRemoveAdId])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] forKey:kRemoveAdId];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:kRemoveAdId])
    {
        // enable the pro features
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRemoveAdOK];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// removes the transaction from the queue and posts the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    if (wasSuccessful)
    {
        [_delegate IAP_Succeed:transaction];
    }
    else
    {
        [_delegate IAP_Failed];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
//    [JTools Alert:LDic[@"Purchase success"] message:nil VC:(UIViewController *)_delegate];  //已經有預設的success alert
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
//    [JTools Alert:LDic[@"Restore success"] Message:nil VC:(UIViewController *)_delegate];
    [_delegate IAP_RestoreSucceed];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"0 Purchasing");
                break;
            case SKPaymentTransactionStatePurchased:
                NSLog(@"1 Purchased");
//                [[JTools AppDelegate] StopHUD];
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"2 Failed");
//                [[JTools AppDelegate] StopHUD];
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"3 Restored");
//                [[JTools AppDelegate] StopHUD];
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred:
                NSLog(@"4 Deferred");
                break;
                
            default:
                break;
        }
    }
}

// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    //不管是purchase還是Restore，不管網路有沒有通，最後都是走這
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    //網路不通時Restore會走這
//    [[JTools AppDelegate] StopHUD];
//    [JTools Alert:LDic[@"Restore fail"] Message:nil VC:(UIViewController *)_delegate];
    [[BannerManager shared] loadBanner:@"回復購買失敗" success:NO];
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    //Restore成功時會走這，比上面的"3 Restored"還要更晚
}

// Sent when the download state has changed.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray<SKDownload *> *)downloads {
}

@end
