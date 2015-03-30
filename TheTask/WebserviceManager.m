//
//  WebserviceManager.m
//  TheTask
//
//  Created by Bartek Kozłowski on 29/03/15.
//  Copyright (c) 2015 Bartosz Kozlowski. All rights reserved.
//

#import "WebserviceManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "ResponseParser.h"
#import "Utils.h"

#define GET_STYLES_URL @"http://ioks.ovh/api/test.txt"

@interface WebserviceManager ()

@property (strong) NSOperationQueue *requestQueue;
@property (strong) NSMutableDictionary *imageRequestDictionary;

@end

@implementation WebserviceManager

#pragma mark - singleton -

+ (instancetype) sharedInstance
{
    static dispatch_once_t pred;
    static id shared = nil;
    dispatch_once(&pred,
                  ^{
                      shared = [[super alloc] initUniqueInstance];
                      [shared initManager];
                  });
    return shared;
}

- (instancetype) initUniqueInstance
{
    return [super init];
}


#pragma mark - construction / deconstruction -

- (void) initManager {
    self.requestQueue = [NSOperationQueue new];
    self.imageRequestDictionary = [NSMutableDictionary new];
}


#pragma mark - public static methods -

+ (void) getStylesFromWebservice:(void(^)(NSDictionary*))webserviceResponse {
    [[WebserviceManager sharedInstance] getStylesFromWebservice:webserviceResponse];
}

+ (void) downloadImageFromUrl:(NSString*)imageUrl andCallback:(void(^)())imageDownloaded {
    [[WebserviceManager sharedInstance] downloadImageFromUrl:imageUrl andCallback:imageDownloaded];
}

#pragma mark - get styles webservice call -

- (void) getStylesFromWebservice:(void(^)(NSDictionary*))webserviceResponse {
    NSURLRequest *getStylesRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:GET_STYLES_URL]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:getStylesRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDictionary = [ResponseParser parserResponseFromObject:responseObject];
        webserviceResponse(responseDictionary);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        webserviceResponse(nil);
    }];
    
    [self.requestQueue addOperation:operation];
}

- (void) downloadImageFromUrl:(NSString*)imageUrl andCallback:(void(^)())imageDownloaded {
    
    NSString *imagePath = [Utils imagePathForUrlSting:imageUrl];
    NSString  *imageName = [Utils md5fromString:imageUrl];
    if ([self.imageRequestDictionary objectForKey:imageName] == nil) {
        [self.imageRequestDictionary setObject:@"1" forKey:imageName];
        
        NSURLRequest *getStylesRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageUrl]];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:getStylesRequest];

        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response: %@", responseObject);
            NSError *error;
            [(NSData*)responseObject writeToFile:imagePath options:NSDataWritingAtomic error:&error];
            [self.imageRequestDictionary removeObjectForKey:imageName];
            imageDownloaded();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
            [self.imageRequestDictionary removeObjectForKey:imageName];
            imageDownloaded();
        }];
        [requestOperation start];
    }
    

}


@end
