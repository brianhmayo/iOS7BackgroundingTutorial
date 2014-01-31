//
//  CTCArticlesModel.m
//  iOS7BackgroundingTutorial
//
//  Created by Brian H Mayo on 10/7/13.
//  Copyright (c) 2013 CapTech Consulting. All rights reserved.
//

#import "CTCArticleFetchStrategy.h"
#import "CTCArticlesModel.h"
#import "CTCArticleModel.h"

@implementation CTCArticlesModel

- (NSArray*)articles {
    NSSortDescriptor* dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray* sortDescriptors = [NSArray arrayWithObject:dateSortDescriptor];
    
    return [_articles sortedArrayUsingDescriptors:sortDescriptors];
}

- (void)fetchNewArticlesWithCompletionBlock:(RefreshCompletionHandler)completionBlock {

    CTCArticleFetchStrategy *fetchStrategy = [[CTCArticleFetchStrategy alloc] init];
    [fetchStrategy fetchNewArticlesWithCompletionBlock:^(BOOL success, NSArray* fetchedNewArticles) {
        if (success) {
            [self processData:fetchedNewArticles withCompletionBlock:completionBlock];
        } else {
            // if the fetch was not successful and we have a completion block, return
            //  no for success and no for didReceiveArticles
            if (completionBlock) {
                completionBlock(NO, 0);
            }
        }
    }];
}

- (void)processData:(NSArray*)fetchedNewArticles withCompletionBlock:(RefreshCompletionHandler)completionBlock {
    // if data is nil, simply return
    if (!fetchedNewArticles) {
        // if we have a completion block and the data is empty, no new articles is assumed
        if (completionBlock) {
            completionBlock(YES, 0);
        }
        return;
    } else {
        NSError *error;

        if (error) {
            if (completionBlock) {
                completionBlock(NO, 0);
            }
            return;
        } else {
            if (completionBlock) {
                completionBlock(YES, [fetchedNewArticles count]);
            }
            [self createOrAddToArticlesArray:fetchedNewArticles];
        }
    }
}

- (void)createOrAddToArticlesArray:(NSArray*)articlesArrayFromJSON {
    NSMutableArray *mutableArticlesArray;
    
    if (_articles) {
        mutableArticlesArray = [NSMutableArray arrayWithArray:_articles];
    } else {
        mutableArticlesArray = [[NSMutableArray alloc] init];
    }
    
    for (NSDictionary* article in articlesArrayFromJSON) {
        if ([article objectForKey:@"title"] &&
            [article objectForKey:@"description"] &&
            [article objectForKey:@"date"]) {
            
            NSString *title = [article objectForKey:@"title"];
            
            NSString *description = [article objectForKey:@"description"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [dateFormat dateFromString:[article objectForKey:@"date"]];


            CTCArticleModel* article = [[CTCArticleModel alloc] initWithTitle:title
                                                               andDescription:description
                                                                      andDate:date];
            if (article) {
                [mutableArticlesArray addObject:article];
            }
        }
    }
    
    if (mutableArticlesArray) {
        self.articles = mutableArticlesArray;
    }
}

@end
