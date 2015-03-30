//
//  StyleManager.m
//  TheTask
//
//  Created by Bartek Kozłowski on 28/03/15.
//  Copyright (c) 2015 Bartosz Kozlowski. All rights reserved.
//

#import "StyleManager.h"
#import "WebserviceManager.h"
#import "DatabaseManager.h"
#import "StyleEntity.h"
#import "StyleObject.h"
#import "Utils.h"

@implementation StyleManager

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
    
}


#pragma mark - public static methods -

+ (NSArray*) getStylesArray {
    return [[StyleManager sharedInstance] getStylesArray];
}

+ (void) updateStyles:(void(^)())stylesUpdated {
    [[StyleManager sharedInstance] updateStyles:stylesUpdated];
}



#pragma mark - webservice access -

- (void) updateStyles:(void(^)())stylesUpdated {
    [WebserviceManager getStylesFromWebservice:(^(NSDictionary *responseDictionary){
        if (responseDictionary != nil) {
            id responseArray = [responseDictionary objectForKey:@"objects"];
            if (responseArray != nil && [responseArray isKindOfClass:[NSArray class]]) {
                [self updateDatabaseWithStyles:responseArray];
            }
        }
        stylesUpdated();
    })];
}


#pragma mark - data access -

- (NSArray*) getStylesArray {
    NSArray *styleEntitiesArray = [[DatabaseManager sharedInstance] getStyleEntities];
    return [self styleObjectsArrayFromStyleEntiesArray:styleEntitiesArray];
}

- (NSArray*) styleObjectsArrayFromStyleEntiesArray:(NSArray*)styleEntities {
    NSMutableArray *styleObjectsArray = [NSMutableArray new];
    for (int i = 0; i < styleEntities.count ; i++) {
        StyleObject *styleObject = [StyleObject new];
        styleObject.styleEntity = [styleEntities objectAtIndex:i];
        [styleObjectsArray addObject:styleObject];
    }
    return styleObjectsArray;
}


- (void) updateDatabaseWithStyles:(NSArray*)styles {
    NSMutableArray *currentEntities = [NSMutableArray arrayWithArray:[[DatabaseManager sharedInstance] getStyleEntities]];
    int currentEntityIndex = 0;
    for(int i = 0; i < styles.count; i++) {
        StyleEntity *existingEntity = [currentEntities firstObject];
        NSDictionary *styleData = [styles objectAtIndex:i];
        if (existingEntity == nil) {
            existingEntity = [self inserNewStyleEntityInContext:[[DatabaseManager sharedInstance] managedObjectContext]];
        } else {
            [currentEntities removeObjectAtIndex:0];
        }
        if ([self updateExistingStyle:existingEntity withData:styleData atIndex:currentEntityIndex]) {
            currentEntityIndex++;
        } else {
            [[[DatabaseManager sharedInstance] managedObjectContext] deleteObject:existingEntity];
        };
    }
    
    [self removeRemainingEntities:currentEntities];
    [[DatabaseManager sharedInstance] saveContext];
}

- (void)removeRemainingEntities:(NSMutableArray *)currentEntities {
    for(int i = 0; i < currentEntities.count; i++) {
        StyleEntity *entityToDelete = [currentEntities objectAtIndex:i];
        [[[DatabaseManager sharedInstance] managedObjectContext] deleteObject:entityToDelete];
    }
}

- (StyleEntity*) inserNewStyleEntityInContext:(NSManagedObjectContext*)context {
    StyleEntity *newStyleEntity = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"StyleEntity"
                                   inManagedObjectContext:context];
    return newStyleEntity;
}

- (BOOL) updateExistingStyle:(StyleEntity*)existingEntity withData:(NSDictionary*)data atIndex:(int)index {
    
    existingEntity.styleIndex = [NSNumber numberWithInt:index];
    
    id buttonStyle = [data objectForKey:@"buttonStyle"];
    if ([self checkValue:buttonStyle againstClass:[NSDictionary class]]) {
        existingEntity.buttonColor = [self validatedColourValue:[buttonStyle objectForKey:@"color"]];
        existingEntity.buttonCornerRadius = [self validatedNumberValue:[buttonStyle objectForKey:@"cornerRadius"]];
        existingEntity.buttonTitle = [self validatedStringValue:[buttonStyle objectForKey:@"title"]];
        existingEntity.buttonHeight = [self validatedNumberValue:[buttonStyle objectForKey:@"height"]];
        existingEntity.buttonWidth = [self validatedNumberValue:[buttonStyle objectForKey:@"width"]];
    }
    else return NO;
    
    id imageStyle = [data objectForKey:@"imageStyle"];
    if ([self checkValue:imageStyle againstClass:[NSDictionary class]]) {
        existingEntity.imageWidth = [self validatedNumberValue:[imageStyle objectForKey:@"width"]];
        existingEntity.imageHeight = [self validatedNumberValue:[imageStyle objectForKey:@"height"]];
        existingEntity.imageCornerRadius = [self validatedNumberValue:[imageStyle objectForKey:@"cornerRadius"]];
        existingEntity.imageBorderWidth = [self validatedNumberValue:[imageStyle objectForKey:@"borderWidth"]];
        existingEntity.imageBorderColor = [self validatedColourValue:[imageStyle objectForKey:@"borderColor"]];
        existingEntity.imageRotation = [self validatedNumberValue:[imageStyle objectForKey:@"rotation"]];
    }
    else return NO;
    
    id imageURL = [data objectForKey:@"imageURL"];
    if ([self checkValue:imageURL againstClass:[NSString class]]) {
        existingEntity.imageUrl = imageURL;
        existingEntity.imagePath = [Utils imagePathForUrlSting:imageURL];
    }
    else return NO;
    
    return YES;
}



- (NSString*) validatedColourValue:(id)value {
    if (value != nil && [value isKindOfClass:[NSDictionary class]]) {
        return [Utils colorStringFromRGBDictionary:value];
    } else {
        return @"000000ff";
    }
}

- (NSNumber*) validatedNumberValue:(id)value {
    if ([self checkValue:value againstClass:[NSNumber class]]) {
        return value;
    } else {
        return [NSNumber numberWithInt:0];
    }
}

- (NSString*) validatedStringValue:(id)value {
    if ([self checkValue:value againstClass:[NSString class]]) {
        return value;
    } else {
        return @"";
    }
}

- (BOOL) checkValue:(id)value againstClass:(Class)aClass {
    return value != nil && [value isKindOfClass:aClass];
}


@end
