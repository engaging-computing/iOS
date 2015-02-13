//
// ISMAppDelegate.h
// Motion
//
// Created by Mike Stowell on 9/9/14.
//
// (c) 2015
// University of Massachusetts
// All Rights Reserved
//

#import <UIKit/UIKit.h>
#import "QueueUploaderView.h"

@interface ISMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// DataSaver
@property (nonatomic, strong) IBOutlet DataSaver *dataSaver;

// Core Data
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
