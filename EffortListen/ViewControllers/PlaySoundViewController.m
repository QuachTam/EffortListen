//
//  PlaySoundViewController.m
//  EffortListen
//
//  Created by Tamqn on 3/23/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "PlaySoundViewController.h"
#import "FolderTableViewCell.h"
#import "ReaderViewController.h"
#import "PlaySound.h"
#import "ReaderPDF.h"

@interface PlaySoundViewController ()<ReaderViewControllerDelegate>
@property (nonatomic, readwrite) NSInteger selectedIndexPath;

@end

@implementation PlaySoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Read Book";
    
    self.selectedIndexPath = self.currentIndexBook;
    [self setUpselectedCellIndexPath];

    QBCBlob *blobCurrent = [self.bookList objectAtIndex:self.currentIndexBook];
    PlaySound *play = [PlaySound instance];
    [play showVideoWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 100)];
    [play playWithURLString:blobCurrent.privateUrl];
}

- (void)viewDidAppear:(BOOL)animated {
}

#pragma mark - Table view data source

- (void)setUpselectedCellIndexPath{
    if (self.selectedIndexPath>=0 && self.selectedIndexPath < self.bookList.count) {
        NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:self.selectedIndexPath inSection:0];
        [self tableView:self.tbView didSelectRowAtIndexPath:selectedCellIndexPath];
        [self.tbView selectRowAtIndexPath:selectedCellIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self.tbView cellForRowAtIndexPath:selectedCellIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

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
    if(indexPath.row == self.selectedIndexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath {
    QBCBlob *blob = [self.bookList objectAtIndex:indexPath.row];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    self.selectedIndexPath = indexPath.row;
    PlaySound *play = [PlaySound instance];
    [play playWithURLString:blob.privateUrl];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
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

- (IBAction)cancelAction:(id)sender {
    PlaySound *play = [PlaySound instance];
    [play stop];
    [play dismiss];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)readBookAction:(id)sender {
    ReaderPDF *reader = [ReaderPDF instance];
    [reader ShowReaderDoccumentWithName:nil inVC:self];
}

@end
