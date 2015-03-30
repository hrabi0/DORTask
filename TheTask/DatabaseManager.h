//
//  DatabaseManager.h
//  TheTask
//
//  Created by Bartek Kozłowski on 29/03/15.
//  Copyright (c) 2015 Bartosz Kozlowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DatabaseManager : NSObject

+ (instancetype) sharedInstance;

- (NSManagedObjectContext *)managedObjectContext;
- (void)saveContext;
- (NSArray*) getStyleEntities;

@end
