//
//  TaskManager.m
//  Todo
//
//  Created by Khater on 8/30/23.
//

#import "TaskManager.h"

@implementation TaskManager


-(id) init {
    self = [super init];
    userDefaults = [NSUserDefaults standardUserDefaults];
    tasks = [NSMutableArray new];
    _todo = [Priority new];
    _inProgress = [Priority new];
    _done = [Priority new];
    return self;
}



// MARK: - Private
- (void) save {
    NSData *tasksData = [NSKeyedArchiver archivedDataWithRootObject: tasks requiringSecureCoding: NO error: nil];
    [userDefaults setObject: tasksData forKey: @"tasks"];
}

- (void) retrieve {
    [tasks removeAllObjects];
    NSData *tasksData = [userDefaults objectForKey: @"tasks"];
    tasks = [NSKeyedUnarchiver unarchiveObjectWithData: tasksData];
    if(tasks == nil) {
        tasks = [NSMutableArray new];
    }
}

- (void) setPrioritiesToTodos {
    // NSArray have Copy Constructor | But NSMuttable doesn't have one
    NSPredicate *allPriorityPredicate = [NSPredicate predicateWithFormat: @"status == 0"];
    _todo.allPriorities = [tasks filteredArrayUsingPredicate: allPriorityPredicate];
    
    NSPredicate *lowPriorityPredicate = [NSPredicate predicateWithFormat: @"status == 0 && priority == 0"];
    _todo.lowPriority = [tasks filteredArrayUsingPredicate: lowPriorityPredicate];
    
    NSPredicate *mediumPriorityPredicate = [NSPredicate predicateWithFormat: @"status == 0 && priority == 1"];
    _todo.mediumPriority = [tasks filteredArrayUsingPredicate: mediumPriorityPredicate];
    
    NSPredicate *highPriorityPredicate = [NSPredicate predicateWithFormat: @"status == 0 && priority == 2"];
    _todo.highPriority = [tasks filteredArrayUsingPredicate: highPriorityPredicate];
}

- (void) setPrioritiesToInProgress {
    // NSArray have Copy Constructor | But NSMuttable doesn't have one
    NSPredicate *allPriorityPredicate = [NSPredicate predicateWithFormat: @"status == 1"];
    _inProgress.allPriorities = [tasks filteredArrayUsingPredicate: allPriorityPredicate];
    
    NSPredicate *lowPriorityPredicate = [NSPredicate predicateWithFormat: @"status == 1 && priority == 0"];
    _inProgress.lowPriority = [tasks filteredArrayUsingPredicate: lowPriorityPredicate];
    
    NSPredicate *mediumPriorityPredicate = [NSPredicate predicateWithFormat: @"status == 1 && priority == 1"];
    _inProgress.mediumPriority = [tasks filteredArrayUsingPredicate: mediumPriorityPredicate];
    
    NSPredicate *highPriorityPredicate = [NSPredicate predicateWithFormat: @"status == 1 && priority == 2"];
    _inProgress.highPriority = [tasks filteredArrayUsingPredicate: highPriorityPredicate];
}

- (void) setPrioritiesToDone {
    // NSArray have Copy Constructor | But NSMuttable doesn't have one
    NSPredicate *allPriorityPredicate = [NSPredicate predicateWithFormat: @"status == 2"];
    _done.allPriorities = [tasks filteredArrayUsingPredicate: allPriorityPredicate];
    
    NSPredicate *lowPriorityPredicate = [NSPredicate predicateWithFormat: @"status == 2 && priority == 0"];
    _done.lowPriority = [tasks filteredArrayUsingPredicate: lowPriorityPredicate];
    
    NSPredicate *mediumPriorityPredicate = [NSPredicate predicateWithFormat: @"status == 2 && priority == 1"];
    _done.mediumPriority = [tasks filteredArrayUsingPredicate: mediumPriorityPredicate];
    
    NSPredicate *highPriorityPredicate = [NSPredicate predicateWithFormat: @"status == 2 && priority == 2"];
    _done.highPriority = [tasks filteredArrayUsingPredicate: highPriorityPredicate];
}


// MARK: - Public
- (void) fetchTasksByStatus: (int) status {
    [self retrieve];
    
    switch(status) {
        case 0:
            [self setPrioritiesToTodos];
            break;
        case 1:
            [self setPrioritiesToInProgress];
            break;
        case 2:
            [self setPrioritiesToDone];
            break;
    }
}

- (void) insertTask: (Task*) task {
    [self retrieve];
    [tasks addObject: task];
    [self save];
}

- (void) updateTask: (Task*) task {
    [self retrieve];
    
    // Find index of Object
    NSUInteger index = [tasks indexOfObjectPassingTest:^BOOL(Task * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.uuid isEqual: task.uuid];
    }];
    
    if(index == NSNotFound){
        return;
    }
    
    // Replace old task with updated task in tasks Array
    [tasks replaceObjectAtIndex: index withObject: task];
    
    [self save];
}

- (void) deleteTaskWithUUID: (NSString*) uuid {
    [self retrieve];
    
    // Find index of Object
    NSUInteger index = [tasks indexOfObjectPassingTest:^BOOL(Task * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.uuid isEqual: uuid];
    }];
    
    if(index == NSNotFound){
        return;
    }
    
    [tasks removeObjectAtIndex: index];
    [self save];
}

@end
