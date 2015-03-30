//
//  Utils.m
//  TheTask
//
//  Created by Bartek Kozłowski on 29/03/15.
//  Copyright (c) 2015 Bartosz Kozlowski. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>

#define UIColorFromRGBA(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF000000) >> 24))/255.0 \
green:((float)((rgbValue & 0x00FF0000) >>  16))/255.0 \
blue:((float)((rgbValue & 0x0000FF00) >>  8))/255.0 \
alpha:((float)((rgbValue & 0x000000FF) >>  0))/255.0]

@implementation Utils

+ (NSString*)colorStringFromRGBDictionary:(NSDictionary*)dictionary {
    NSMutableString *colorString = [NSMutableString new];
    
    id red = [dictionary objectForKey:@"red"];
    if (red && [red isKindOfClass:[NSNumber class]]) {
        [colorString appendFormat:@"%02x",(int)([(NSNumber*)red floatValue]*255.0)];
    } else {
        [colorString appendFormat:@"00"];
    }
    
    id green = [dictionary objectForKey:@"green"];
    if (green && [green isKindOfClass:[NSNumber class]]) {
        [colorString appendFormat:@"%02x",(int)([(NSNumber*)green floatValue]*255.0)];
    } else {
        [colorString appendFormat:@"00"];
    }
    
    id blue = [dictionary objectForKey:@"blue"];
    if (blue && [blue isKindOfClass:[NSNumber class]]) {
        [colorString appendFormat:@"%02x",(int)([(NSNumber*)blue floatValue]*255.0)];
    } else {
        [colorString appendFormat:@"00"];
    }
    
    id alpha = [dictionary objectForKey:@"alpha"];
    if (alpha && [alpha isKindOfClass:[NSNumber class]]) {
        [colorString appendFormat:@"%02x",(int)([(NSNumber*)alpha floatValue]*255.0)];
    } else {
        [colorString appendFormat:@"ff"];
    }
    return colorString;
}



+ (UIColor*) colorFromHexString:(NSString*)colorString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:colorString];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (NSString*) imagePathForUrlSting:(NSString*)url {
    NSURL *cachesDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSMutableString *cachesPath = [NSMutableString stringWithString:[cachesDirectory path]];
    [cachesPath appendFormat:@"/%@",[Utils md5fromString:url]];
    return cachesPath;
}


+ (NSString*)md5fromString:(NSString*)baseString
{
    const char *ptr = [baseString UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}



+ (UIColor*) transColorFrom:(UIColor*)startColor to:(UIColor*)targetColor progress:(CGFloat)percent {
    CGColorRef startColorRef = [startColor CGColor];
    CGColorRef targetColorRef = [targetColor CGColor];
    
    unsigned long _startCountComponents = CGColorGetNumberOfComponents(startColorRef);
    unsigned long _targetCountComponents = CGColorGetNumberOfComponents(targetColorRef);
    
    if (_startCountComponents == 4 && _targetCountComponents == 4) {
        const CGFloat *_startComponents = CGColorGetComponents(startColorRef);
        CGFloat sred     = _startComponents[0];
        CGFloat sgreen = _startComponents[1];
        CGFloat sblue   = _startComponents[2];
        CGFloat salpha = _startComponents[3];
        
        const CGFloat *_targetComponents = CGColorGetComponents(targetColorRef);
        CGFloat tred     = _targetComponents[0];
        CGFloat tgreen = _targetComponents[1];
        CGFloat tblue   = _targetComponents[2];
        CGFloat talpha = _targetComponents[3];
        
        return [UIColor colorWithRed:[Utils valueBetween:sred and:tred percent:percent]
                               green:[Utils valueBetween:sgreen and:tgreen percent:percent]
                                blue:[Utils valueBetween:sblue and:tblue percent:percent]
                               alpha:[Utils valueBetween:salpha and:talpha percent:percent]];
    }
    return targetColor;
}

+ (CGFloat) valueBetween:(CGFloat)start and:(CGFloat)end percent:(CGFloat)percent {
    CGFloat value = end - start;
    value *= percent;
    value += start;
    return value;
}
@end
