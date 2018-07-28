//
//  DataArchiver.m
//  Lotto
//
//  Created by Eternal on 2010/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataArchiver.h"
#import "JTools.h"

@implementation DataArchiver

//======================================================================================//
//									外部：將資料物件封存 									//
//======================================================================================//
+(BOOL)archivingDataWithObject:(id)Object forKey:(NSString *)key	//key也將是封存檔檔名
{
    return [self archivingDataWithObject:Object forKey:key Type:0]; //Caches
}

+(BOOL)archivingDataWithObject:(id)Object forKey:(NSString *)key Type:(BOOL)Type	//key也將是封存檔檔名
{
	NSMutableData *data = [[NSMutableData alloc]init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
	id callself = [self alloc];
	[archiver encodeObject:Object forKey:key];
	[archiver finishEncoding];
	[data writeToFile:[callself dataFilePath:key Type:Type] atomically:YES];
    
	if ([data writeToFile:[callself dataFilePath:key Type:Type] atomically:YES])
	{
//		[data		release];
//		[archiver	release];
//		[callself	release];
		return YES;
	}
	else 
	{
//		[data		release];
//		[archiver	release];
//		[callself	release];
		return NO;
	}
}

//======================================================================================//
//								外部：將封存檔案還原為資料物件                               //
//======================================================================================//
+(id)unarchiver:(NSString *)key
{
    return [self unarchiver:key Type:0];
}

+(id)unarchiver:(NSString *)key Type:(BOOL)Type
{
	////NSLog(@"Unarchiver key: %@", key);
    id callself = [self alloc];
	NSData *data = [[NSMutableData alloc]initWithContentsOfFile:[callself dataFilePath:key Type:Type]];
    
    if (data == nil)
    {
        //NSLog(@"HELP!");
//        [callself	release];
        return nil;
    }
    
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    ////NSLog(@"unarchiver retainCount: %i", [unarchiver retainCount]);
	id ArchiveData = [unarchiver decodeObjectForKey:key];
	[unarchiver finishDecoding];
//	[data		release];
    ////NSLog(@"before release, unarchiver retainCount: %i", [unarchiver retainCount]);
//	[unarchiver release];
//	[callself	release];
	return ArchiveData;
}

+(NSString *)unarchiverURL:(NSString *)key
{
    id callself = [self alloc];
	return [callself dataFilePath:key];
}

//======================================================================================//
//									內部：取得正確檔案路徑									//
//======================================================================================//
-(NSString *)dataFilePath:(NSString *)filename
{
    return [self dataFilePath:filename Type:0]; //Caches
}

-(NSString *)dataFilePath:(NSString *)filename Type:(BOOL)Type
{
    NSString *documentsDir;
    if (SavingFilePath == 1) 
    {
        NSArray *paths;
        if (Type == 0) { //Caches
            paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        } else if (Type == 1) { //Document
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            if ([JTools AddSkipBackupAttributeToItemAtPath:[paths firstObject]]) {
//                NSLog(@"預防物件Path被複製到iCloud上 = %@", [paths firstObject]);
            }
        }
        documentsDir = [paths firstObject];
    }
    else
        documentsDir = [[NSBundle mainBundle] resourcePath];
    //NSLog(@"documentsDir = %@",documentsDir);
    
	return [documentsDir stringByAppendingString:[NSString stringWithFormat:@"/%@",filename]];
}
@end
