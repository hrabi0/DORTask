//
//  ResponseParser.h
//  TheTask
//
//  Created by Bartek Kozłowski on 29/03/15.
//  Copyright (c) 2015 Bartosz Kozlowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseParser : NSObject

+ (NSDictionary*) parserResponseFromObject:(id)responseObject;

@end
