//
//  TaskManager.m
//  Todo
//
//  Created by Khater on 8/30/23.
//

#import "TaskManager.h"

/*
    Problem To Fix:
    - Need to know when NSKeyedArchiver is Finished
    - Need to know when data is successfully saved
    
    Why:
    - if user is create a task then leave the screen before finishing Archive and saving data then it will be no data to show
 */

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
    NSError *error;
    NSData *tasksData = [NSKeyedArchiver archivedDataWithRootObject: tasks requiringSecureCoding: NO error: &error];
    [userDefaults setObject: tasksData forKey: @"tasks"];
    
    if(error != nil){
        NSLog(@"Error %@", error.localizedDescription);
    }
}

- (void) retrieve {
    [tasks removeAllObjects];
    NSData *tasksData = [userDefaults objectForKey: @"tasks"];
    tasks = [NSKeyedUnarchiver unarchiveObjectWithData: tasksData];
    if(tasks == nil) {
        tasks = [NSMutableArray new];
    }
}

- (void) setPrioritiesFor: (Priority*) priority withStatus: (int) status {
    // NSArray have Copy Constructor | But NSMuttable doesn't have one
    NSPredicate *allPriorityPredicate = [NSPredicate predicateWithFormat: @"status == %d", status];
    priority.allPriorities = [tasks filteredArrayUsingPredicate: allPriorityPredicate];
    
    NSPredicate *lowPriorityPredicate = [NSPredicate predicateWithFormat: @"status == %d && priority == 0", status];
    priority.lowPriority = [tasks filteredArrayUsingPredicate: lowPriorityPredicate];
    
    NSPredicate *mediumPriorityPredicate = [NSPredicate predicateWithFormat: @"status == %d && priority == 1", status];
    priority.mediumPriority = [tasks filteredArrayUsingPredicate: mediumPriorityPredicate];
    
    NSPredicate *highPriorityPredicate = [NSPredicate predicateWithFormat: @"status == %d && priority == 2", status];
    priority.highPriority = [tasks filteredArrayUsingPredicate: highPriorityPredicate];
}


// MARK: - Public
- (void) fetchTasksWithStatusEqualTo: (int) status {
    [self retrieve];
    
    switch(status) {
        case 0:
            [self setPrioritiesFor: _todo withStatus: 0];
            break;
        case 1:
            [self setPrioritiesFor: _inProgress withStatus: 1];
            break;
        case 2:
            [self setPrioritiesFor: _done withStatus: 2];
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
