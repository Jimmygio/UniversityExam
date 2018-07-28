//
//  DataArchiver.h
//  Lotto
//
//  Created by Eternal on 2010/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SavingFilePath 1

@interface DataArchiver : NSObject {

}
+(BOOL)archivingDataWithObject:(id)Object forKey:(NSString *)key;
+(BOOL)archivingDataWithObject:(id)Object forKey:(NSString *)key Type:(BOOL)Type;
+(id)unarchiver:(NSString *)key;
+(id)unarchiver:(NSString *)key Type:(BOOL)Type;
+(id)unarchiverURL:(NSString *)key;
-(NSString *)dataFilePath:(NSString *)filename;
-(NSString *)dataFilePath:(NSString *)filename Type:(BOOL)Type;
@end
