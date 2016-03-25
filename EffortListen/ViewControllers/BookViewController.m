
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
#import "ReaderPDF.h"
#import "PlaySound.h"
#import "TQNDocument.h"

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
    self.title = @"Files";
}

- (void)backButton {
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, 25, 25)];
    [btnBack setImage:[UIImage imageNamed:@"brightLight"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton=[[UIBarButtonItem alloc]initWithCustomView:btnBack];
    [self.navigationItem setLeftBarButtonItem:backBarButton];
}

- (void)backView {
    
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
    cell.buttonRun.tag = indexPath.row;
    if ([blob.contentType isEqualToString:@"application/pdf"]) {
        [cell.buttonRun setImage:[UIImage imageNamed:@"bookShow"] forState:UIControlStateNormal];
        [cell.buttonRun addTarget:self action:@selector(showBook:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [cell.buttonRun setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [cell.buttonRun addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QBCBlob *blob = [self.bookList objectAtIndex:indexPath.row];
    if (![blob.contentType isEqualToString:@"application/pdf"]) {
        [self performSegueWithIdentifier:@"playSound" sender:indexPath];
    }
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
            
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        bookVC.currentIndexBook = indexPath.row;
        bookVC.bookList = self.bookList;
    }
}

- (void)showBook:(id)sender {
    TQNDocument *document = [TQNDocument instance];
    QBCBlob *blobCurrent = [self.bookList objectAtIndex:[sender tag]];
    if ([document checkFileExist:@"PDF_FILES" fileName:[NSString stringWithFormat:@"%ld.pdf", (long)blobCurrent.ID]]) {
        NSString *documentFile = [document getFileInDirectory:@"PDF_FILES" fileName:[NSString stringWithFormat:@"%ld.pdf", (long)blobCurrent.ID]];
        [SVProgressHUD dismiss];
        [self readerPDFWithDocumentFile:documentFile];
    }else{
        [SVProgressHUD showProgress:0.0 status:@"Downloading..."];
        BookService *serviceBook = [BookService instance];
        [serviceBook downloadFileWith:blobCurrent statusBlock:^(QBRequestStatus *status) {
            [SVProgressHUD showProgress:status.percentOfCompletion status:@"Downloading..."];
        } success:^(BOOL isSuccess) {
            [SVProgressHUD dismiss];
            if (isSuccess) {
                NSString *documentFile = [document getFileInDirectory:@"PDF_FILES" fileName:[NSString stringWithFormat:@"%ld.pdf", (long)blobCurrent.ID]];
                [self readerPDFWithDocumentFile:documentFile];
            }else{
                [CommonFeature showAlertTitle:@"Effort Listen" Message:@"Load file error" duration:2.0 showIn:self blockDismissView:nil];
            }
        }];
    }
}

- (void)readerPDFWithDocumentFile:(NSString *)documentFile {
    ReaderPDF *reader = [ReaderPDF instance];
    [reader ShowReaderDoccumentWithName:documentFile inVC:self];
}

- (void)playSound:(id)sender {
    QBCBlob *blobCurrent = [self.bookList objectAtIndex:[sender tag]];
    PlaySound *play = [PlaySound instance];
    [play showVideoWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
    [play playWithURLString:blobCurrent.privateUrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
