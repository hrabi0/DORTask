//
//  StyleObject.m
//  TheTask
//
//  Created by Bartek Kozłowski on 28/03/15.
//  Copyright (c) 2015 Bartosz Kozlowski. All rights reserved.
//

#import "StyleObject.h"
#import "StyleEntity.h"
#import "WebserviceManager.h"

@interface StyleObject ()

@end

@implementation StyleObject

- (UIImage*) getImageAndDownloadIfNotPresent{
    UIImage *image = [UIImage imageWithContentsOfFile:self.styleEntity.imagePath];
    if (image != nil) {
        return image;
    }
    [WebserviceManager downloadImageFromUrl:self.styleEntity.imageUrl
                                andCallback:(^(){
        if ([self.delegate respondsToSelector:@selector(imageDidLoadForStyleObjectIndex:)]) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:self.styleEntity.imagePath isDirectory:nil]) {
                [self.delegate imageDidLoadForStyleObjectIndex:[self.styleEntity.styleIndex intValue]];
            }
        }
    })];
    return nil;
}

@end
