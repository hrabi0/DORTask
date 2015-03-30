//
//  Utils.h
//  TheTask
//
//  Created by Bartek Kozłowski on 29/03/15.
//  Copyright (c) 2015 Bartosz Kozlowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

+ (NSString*)colorStringFromRGBDictionary:(NSDictionary*)dictionary;
+ (UIColor*) colorFromHexString:(NSString*)colorString;

+ (NSString*) imagePathForUrlSting:(NSString*)url;
+ (NSString*) md5fromString:(NSString*)baseString;

+ (UIColor*) transColorFrom:(UIColor*)startColor to:(UIColor*)targetColor progress:(CGFloat)percent;

@end
