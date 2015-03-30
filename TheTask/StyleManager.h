//
//  StyleManager.h
//  TheTask
//
//  Created by Bartek Kozłowski on 28/03/15.
//  Copyright (c) 2015 Bartosz Kozlowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StyleManager : NSObject

+ (instancetype) sharedInstance;

+ (NSArray*) getStylesArray;
+ (void) updateStyles:(void(^)())stylesUpdated;

@end

