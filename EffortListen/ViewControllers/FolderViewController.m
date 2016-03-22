//
//  FolderViewController.m
//  EffortListen
//
//  Created by Tamqn on 3/22/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "FolderViewController.h"
#import "FolderTableViewCell.h"
#import "ObjectsPaginator.h"
#import "Storage.h"
#import "FolderTableViewCell.h"

@interface FolderViewController ()<NMPaginatorDelegate>
@property (nonatomic, strong) ObjectsPaginator *paginator;
@end

@implementation FolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view.
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeClear];
    self.paginator = [[ObjectsPaginator alloc] initWithPageSize:10 delegate:self];
    [self.paginator fetchFirstPage];
}

- (void)paginator:(id)paginator didReceiveResults:(NSArray *)results {
    [SVProgressHUD dismiss];
    [[Storage instance].folderList addObjectsFromArray:results];
    [self.tbView reloadData];
}

#pragma mark
#pragma mark Paginator

- (void)fetchNextPage {
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeClear];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.paginator fetchNextPage];
    });
}

#pragma mark
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // when reaching bottom, load a new page
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height) {
        // ask next page only if we haven't reached last page
        if (![self.paginator reachedLastPage]) {
            // fetch next page of results
            [self fetchNextPage];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[Storage instance].folderList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPaths:indexPath tableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FolderTableViewCell *cell = (FolderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"FolderTableViewCell"];
    [self configureformTableViewCell:cell atIndexPath:indexPath tableView:tableView];
    return cell;
}

- (void)configureformTableViewCell:(FolderTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView*)tableView{
    // some code for initializing cell content
    QBCOCustomObject *object_custom = [Storage instance].folderList[indexPath.row];
    cell.name.text = object_custom.fields[@"name"];
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QBCOCustomObject *object_custom = [Storage instance].folderList[indexPath.row];
    
}

- (CGFloat)heightForBasicCellAtIndexPaths:(NSIndexPath *)indexPath tableView:(UITableView*)tableView{
    static FolderTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    });
    
    [self configureformTableViewCell:sizingCell atIndexPath:indexPath tableView:tableView];
    return [self calculateHeightForConfiguredSizingCells:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCells:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    if (size.height<44) {
        size.height = 44;
    }
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
