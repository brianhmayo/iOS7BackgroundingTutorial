//
//  CTCArticleModel.h
//  iOS7BackgroundingTutorial
//
//  Created by Brian H Mayo on 10/7/13.
//  Copyright (c) 2013 CapTech Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTCArticleModel : NSObject

- (id)initWithTitle:(NSString*) title andDescription:(NSString*) description andDate:(NSDate*) date;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSDate   *date;

@end
