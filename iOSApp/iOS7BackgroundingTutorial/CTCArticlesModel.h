//
//  CTCArticlesModel.h
//  iOS7BackgroundingTutorial
//
//  Created by Brian H Mayo on 10/7/13.
//  Copyright (c) 2013 CapTech Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RefreshCompletionHandler)(BOOL success, int newArticlesCount);

@interface CTCArticlesModel : NSObject

- (void)fetchNewArticlesWithCompletionBlock:(RefreshCompletionHandler)completionBlock;

@property (strong, nonatomic) NSArray *articles;

@end
