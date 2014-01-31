//
//  CTCArticleFetchStrategy.h
//  iOS7BackgroundingTutorial
//
//  Created by Brian H Mayo on 10/10/13.
//  Copyright (c) 2013 CapTech Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNewArticlesURL @"http://ios7background-captech.rhcloud.com/articles"

typedef void (^FetchCompletionBlock)(BOOL success, NSArray* fetchArticles);

@interface CTCArticleFetchStrategy : NSObject <NSURLConnectionDelegate>

- (void)fetchNewArticlesWithCompletionBlock:(FetchCompletionBlock)completionBlock;

@end
