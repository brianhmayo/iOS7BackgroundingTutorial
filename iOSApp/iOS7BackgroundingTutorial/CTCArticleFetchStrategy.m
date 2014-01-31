//
//  CTCArticleFetchStrategy.m
//  iOS7BackgroundingTutorial
//
//  Created by Brian H Mayo on 10/10/13.
//  Copyright (c) 2013 CapTech Consulting. All rights reserved.
//

#import "CTCArticleFetchStrategy.h"

@implementation CTCArticleFetchStrategy

NSMutableData *_responseData;
FetchCompletionBlock _completionBlock;

- (void)fetchNewArticlesWithCompletionBlock:(FetchCompletionBlock)completionBlock {
    if (completionBlock) {
        _completionBlock = completionBlock;
    }
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kNewArticlesURL]];
    [request setTimeoutInterval:20.0];  // set the time out interval for the request to 20 seconds.
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
}

- (void)callCompletionBlockWithSuccessAs:(BOOL)success andArticles:(NSArray*)articles {
    
    if (_completionBlock) {
        _completionBlock(success, articles);
    }
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

    // a response has been received, this is where we initialize the instance var
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

    // append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    
    // return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    // the request is complete and data has been received
    NSError *error;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:_responseData
                                                             options:kNilOptions
                                                               error:&error];
    
    // check for an error, if found, simply return (non-production code)
    if (error) {
        return;
    }
    
    // check the response dictionary and the status key
    if ([response objectForKey:@"response"] &&
        [[response objectForKey:@"response"] isEqualToString:@"success"]) {
        NSArray *jsonArticles = [response objectForKey:@"articles"];
        
        if (jsonArticles) {
            [self callCompletionBlockWithSuccessAs:YES andArticles:jsonArticles];
        } else {
            [self callCompletionBlockWithSuccessAs:YES andArticles:[[NSArray alloc] init]];
        }
    } else {
        [self callCompletionBlockWithSuccessAs:NO andArticles:nil];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    // the request has failed for some reason
    [self callCompletionBlockWithSuccessAs:NO andArticles:nil];
}

@end
