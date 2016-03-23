
//
//  BookViewController.m
//  EffortListen
//
//  Created by Tamqn on 3/23/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "BookViewController.h"
#import "FolderTableViewCell.h"
#import "BookService.h"
#import "PlaySoundViewController.h"

@interface BookViewController ()
@property (nonatomic, strong) NSArray *bookList;
@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bookList = [NSArray new];
    [SVProgressHUD showWithStatus:@"Loading"];
    BookService *service = [BookService instance];
    service.didCompleteFetchBlob = ^(NSArray *blobs){
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        self.bookList = blobs;
        [self.tbView reloadData];
    };
    [service getListBlobWithID:self.customObject.fields[@"contentID"]];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bookList.count;
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
    QBCBlob *blob = [self.bookList objectAtIndex:indexPath.row];
    cell.name.text = blob.name;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QBCBlob *blob = [self.bookList objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"playSound" sender:blob.privateUrl];
}

- (CGFloat)heightForBasicCellAtIndexPaths:(NSIndexPath *)indexPath tableView:(UITableView*)tableView{
    static FolderTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [tableView dequeueReusableCellWithIdentifier:@"FolderTableViewCell"];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"playSound"]) {
        // Get reference to the destination view controller
        UINavigationController *nv = [segue destinationViewController];
        PlaySoundViewController *bookVC = [nv.viewControllers objectAtIndex:0];
        NSString *url = (NSString*)sender;
        bookVC.currentIndexURL = 0;
        bookVC.arrayURL = @[url, url];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
