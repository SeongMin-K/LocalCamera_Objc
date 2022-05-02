//
//  AppDelegate.h
//  LocalCamera_Objc
//
//  Created by SeongMinK on 2022/05/02.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

