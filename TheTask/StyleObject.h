//
//  StyleObject.h
//  TheTask
//
//  Created by Bartek Kozłowski on 28/03/15.
//  Copyright (c) 2015 Bartosz Kozlowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class StyleEntity;
@class StyleObject;

@protocol StyleObjectDelegate <NSObject>
- (void) imageDidLoadForStyleObjectIndex:(int)styleIndex;
@end

@interface StyleObject : NSObject

@property (retain) StyleEntity *styleEntity;
@property id delegate;

- (UIImage*) getImageAndDownloadIfNotPresent;

@end
