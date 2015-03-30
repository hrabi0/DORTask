//
//  WebserviceManager.h
//  TheTask
//
//  Created by Bartek Kozłowski on 29/03/15.
//  Copyright (c) 2015 Bartosz Kozlowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebserviceManager : NSObject

+ (instancetype) sharedInstance;

+ (void) getStylesFromWebservice:(void(^)(NSDictionary*))webserviceResponse;
+ (void) downloadImageFromUrl:(NSString*)imageUrl andCallback:(void(^)())imageDownloaded;

@end
