//
//  NumberDownloader.h
//  OpenBlock
//
//  Created by Simon Maddox on 23/09/2016.
//  Copyright © 2016 Maddox Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CallKit/CallKit.h>

@interface NumberDownloader : NSObject

@property (nonatomic, copy) void (^numbersChanged)(NSArray *numbers);

- (instancetype)initWithChangedBlock:(void (^)(NSArray *numbers))changedBlock;
- (void)downloadNumbers;
- (NSArray *)blockNumbersInContext:(CXCallDirectoryExtensionContext *)context;

@end
