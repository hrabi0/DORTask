//
//  StyleEntity.h
//  TheTask
//
//  Created by Bartek Kozłowski on 29/03/15.
//  Copyright (c) 2015 Bartosz Kozlowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StyleEntity : NSManagedObject

@property (nonatomic, retain) NSString * buttonColor;
@property (nonatomic, retain) NSNumber * buttonCornerRadius;
@property (nonatomic, retain) NSString * buttonTitle;
@property (nonatomic, retain) NSNumber * buttonWidth;
@property (nonatomic, retain) NSNumber * buttonHeight;
@property (nonatomic, retain) NSNumber * imageWidth;
@property (nonatomic, retain) NSNumber * imageHeight;
@property (nonatomic, retain) NSNumber * imageCornerRadius;
@property (nonatomic, retain) NSNumber * imageBorderWidth;
@property (nonatomic, retain) NSString * imageBorderColor;
@property (nonatomic, retain) NSNumber * imageRotation;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSNumber * styleIndex;

@end
