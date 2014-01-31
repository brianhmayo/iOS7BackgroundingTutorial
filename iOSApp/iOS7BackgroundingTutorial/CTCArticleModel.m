//
//  CTCArticleModel.m
//  iOS7BackgroundingTutorial
//
//  Created by Brian H Mayo on 10/7/13.
//  Copyright (c) 2013 CapTech Consulting. All rights reserved.
//

#import "CTCArticleModel.h"

@implementation CTCArticleModel

- (id)initWithTitle:(NSString*) title andDescription:(NSString*) description andDate:(NSDate*) date {
    if (self = [super init]) {
        self.title = title;
        self.description = description;
        self.date = date;
    }
    
    return self;
}

@end
