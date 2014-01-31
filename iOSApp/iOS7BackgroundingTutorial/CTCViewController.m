//
//  CTCFirstViewController.m
//  iOS7BackgroundingTutorial
//
//  Created by Brian H Mayo on 9/21/13.
//  Copyright (c) 2013 CapTech Consulting. All rights reserved.
//

#import "CTCViewController.h"
#import "CTCArticleModel.h"

@interface CTCViewController ()

@end

@implementation CTCViewController

CTCArticlesModel *_model;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set the content inset below the status bar.
    [self.tableView setContentInset:UIEdgeInsetsMake(20,
                                                     self.tableView.contentInset.left,
                                                     self.tableView.contentInset.bottom,
                                                     self.tableView.contentInset.right)];
    
    // setup the refresh control.
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refreshControl addTarget:self action:@selector(updateArticles) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    _model = [[CTCArticlesModel alloc] init];
}

- (void)updateArticles {
    CTCViewController *weakSelf = self;
    
    // first, clear out the highlighted cells due to the user refresh.
    [self clearHighlightingOnCells];
    
    RefreshCompletionHandler completionBlock = ^(BOOL success, NSInteger articlesCount) {
        if (success) {
            [weakSelf updateTableViewWithNewArticles:articlesCount];
        }
        
        [weakSelf.refreshControl endRefreshing];
    };
    
    [_model fetchNewArticlesWithCompletionBlock:completionBlock];
}

- (void)clearHighlightingOnCells {
    // first, clear out the highlighted cells due to the user refresh.
    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:0];
    for (int rows=0; rows < numberOfRows; rows++) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rows inSection:0]];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
}


- (void)updateArticlesWithCompletionHandler:(RefreshCompletionHandler)backgroundFetchCompletionHandler {
    CTCViewController *weakSelf = self;
    
    // first, clear out the highlighted cells due to the user refresh.
    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:0];
    for (int rows=0; rows < numberOfRows; rows++) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rows inSection:0]];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    RefreshCompletionHandler completionBlock = ^(BOOL success, NSInteger articlesCount) {
        if (success) {
            [weakSelf updateTableViewWithNewArticles:articlesCount];
        }
        
        if (backgroundFetchCompletionHandler) {
            backgroundFetchCompletionHandler(success, articlesCount);
        }
        
        [weakSelf.refreshControl endRefreshing];
    };
    
    [_model fetchNewArticlesWithCompletionBlock:completionBlock];
}

- (void)updateTableViewWithNewArticles:(NSInteger) newArticlesCount {
    NSMutableArray *indexPathsToInsertInto = [[NSMutableArray alloc] init];
    if (newArticlesCount > 0) {
        for (int row = 0; row < newArticlesCount; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [indexPathsToInsertInto addObject:indexPath];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPathsToInsertInto withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];

            for (NSIndexPath *indexPathOfNewlyInsertedCell in indexPathsToInsertInto) {
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathOfNewlyInsertedCell];
                cell.contentView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:204.0/255.0 alpha:.75];
            }
        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[_model articles] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    CTCArticleModel *articleModel = [_model.articles objectAtIndex:indexPath.row];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 15.0, 200.0, 20.0)];
    [dateLabel adjustsFontSizeToFitWidth];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
    
    dateLabel.text = [formatter stringFromDate:[articleModel date]];
    
    [cell addSubview:dateLabel];
    
    cell.textLabel.text = [articleModel title];
    cell.detailTextLabel.text = [articleModel description];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // selecting a cell will cause an immediate de-selection and clear of the highlight via a reload
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
