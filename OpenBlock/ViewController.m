//
//  ViewController.m
//  OpenBlock
//
//  Created by Simon Maddox on 23/09/2016.
//  Copyright © 2016 Maddox Ltd. All rights reserved.
//

#import "ViewController.h"
#import "NumberDownloader.h"

@interface ViewController ()
@property (nonatomic, strong) NumberDownloader *numberDownloader;
@property (nonatomic, copy) NSArray *numbers;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	__weak typeof(self) weakSelf = self;
	
	self.numberDownloader = [[NumberDownloader alloc] init];
	self.numberDownloader.numbersChanged = ^(NSArray *numbers){
		dispatch_async(dispatch_get_main_queue(), ^{
			__strong typeof(weakSelf) strongSelf = weakSelf;
			
			strongSelf.numbers = numbers;
			[strongSelf.tableView reloadData];
		});
	};
	[self.numberDownloader downloadNumbers];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.numbers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	
	NSDictionary *number = self.numbers[indexPath.row];
	
	cell.textLabel.text = number[@"number"];
	cell.detailTextLabel.text = number[@"description"];
	
	return cell;
}

@end
