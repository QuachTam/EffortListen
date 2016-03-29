//
//  LeftTableViewController.m
//  QuickBlox
//
//  Created by Tamqn on 1/22/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "LeftTableViewController.h"
#import "LeftCustomCell.h"

@interface LeftTableViewController ()
@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, strong) NSArray *iconItemsArray;
@end

@implementation LeftTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self headerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)itemsArray {
    if (!_itemsArray) {
        _itemsArray = @[@"Folders", @"About Us"];
        _iconItemsArray = @[@"profileIcon", @"home"];
    }
    return _itemsArray;
}

#pragma mark - Table view data source

- (void)headerView {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.tbView.tableHeaderView = header;
    
    //update the header's frame and set it again
    CGRect newFrame = self.tbView.tableHeaderView.frame;
    newFrame.size.height = newFrame.size.height;
    self.tbView.tableHeaderView.frame = newFrame;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftCustomCell *cell = (LeftCustomCell *)[tableView dequeueReusableCellWithIdentifier:@"LeftCustomCell" forIndexPath:indexPath];
    cell.iconImageView.image = [UIImage imageNamed:[self.iconItemsArray objectAtIndex:indexPath.row]];
    cell.name.text = [self.itemsArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *stringIdentifier = nil;
    switch (indexPath.row) {
        case 0:
            stringIdentifier = @"folders";
            break;
        case 1:
            stringIdentifier = @"about";
            break;
            
        default:
            break;
    }
    if (stringIdentifier) {
        [self performSegueWithIdentifier:stringIdentifier sender:self];
    }
}

@end
