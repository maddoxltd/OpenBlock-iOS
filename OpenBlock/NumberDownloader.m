//
//  NumberDownloader.m
//  OpenBlock
//
//  Created by Simon Maddox on 23/09/2016.
//  Copyright © 2016 Maddox Ltd. All rights reserved.
//

#import "NumberDownloader.h"
#import "SSZipArchive.h"

@implementation NumberDownloader

- (void)downloadNumbers
{
	NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
	[[session downloadTaskWithURL:[NSURL URLWithString:@"https://github.com/maddoxltd/OpenBlockList/archive/master.zip"] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		[SSZipArchive unzipFileAtPath:[location path] toDestination:[self cachesDirectory]];
		[[NSFileManager defaultManager] removeItemAtURL:location error:nil];
		NSArray *numbers = [self blockNumbersInContext:nil];
		if (self.numbersChanged){
			self.numbersChanged(numbers);
		}
	}] resume];
}

- (NSString *)cachesDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)listDirectory
{
	return [[self cachesDirectory] stringByAppendingPathComponent:@"OpenBlockList-master"];
}

- (NSArray *)blockNumbersInContext:(CXCallDirectoryExtensionContext *)context
{
	NSMutableArray *numbers = [NSMutableArray array];
	NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:[self listDirectory]];
	for (NSString *file in enumerator){
		
		if ([[file pathExtension] length] == 0 && ![file isEqualToString:@".DS_Store"]){
			NSString *filePath = [[self listDirectory] stringByAppendingPathComponent:file];
			NSString *description = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
			
			CXCallDirectoryPhoneNumber phoneNumber = [file longLongValue];
			[context addBlockingEntryWithNextSequentialPhoneNumber:phoneNumber];
			[context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:description];
			
			[numbers addObject:@{@"number" : file, @"description" : description}];
		}
	}
	return [NSArray arrayWithArray:numbers];
}

@end
