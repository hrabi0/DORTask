//
//  ResponseParser.m
//  TheTask
//
//  Created by Bartek Kozłowski on 29/03/15.
//  Copyright (c) 2015 Bartosz Kozlowski. All rights reserved.
//

#import "ResponseParser.h"
#import <Foundation/Foundation.h>

@implementation ResponseParser

+ (NSDictionary*) parserResponseFromObject:(id)responseObject {
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
    if (error) {
        return nil;
    }
    if (![jsonObject isKindOfClass:[NSDictionary class]]) {
        return [NSDictionary dictionaryWithObject:jsonObject forKey:@"objects"];
    }
    return jsonObject;
}

@end
