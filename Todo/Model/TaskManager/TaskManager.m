//
//  TaskManager.m
//  Todo
//
//  Created by Khater on 8/30/23.
//

#import "TaskManager.h"

@implementation TaskManager


// MARK: - Private
- (void) save {
    NSData *tasksData = [NSKeyedArchiver archivedDataWithRootObject: tasks];
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

- (void) addPriorityToStatus: (Priority*) priority status: (int) status {
    [priority.allPriorities removeAllObjects];
    [priority.lowPriority removeAllObjects];
    [priority.mediumPriority removeAllObjects];
    [priority.highPriority removeAllObjects];
    
    for(Task* task in tasks) {
        if(status != task.status){
            continue;
        }
        [priority.allPriorities addObject: task];
        switch(task.priority) {
            case 0:
                [priority.lowPriority addObject: task];
                continue;
                
            case 1:
                [priority.mediumPriority addObject: task];
                continue;
            case 2:
                [priority.highPriority addObject: task];
                continue;
        }
    }
}


// MARK: - Public
-(id) init {
    self = [super init];
    userDefaults = [NSUserDefaults standardUserDefaults];
    tasks = [NSMutableArray new];
    _todo = [Priority new];
    _inProgress = [Priority new];
    _done = [Priority new];
    return self;
}



- (void) fetchTasksByStatus: (int) status {
    [self retrieve];
    
    switch(status) {
        case 0:
            [self addPriorityToStatus: _todo status: status];
            break;
        case 1:
            [self addPriorityToStatus: _inProgress status: status];
            break;
        case 2:
            [self addPriorityToStatus: _done status: status];
            break;
    }
}

- (void) insertTask: (Task*) task {
    [self retrieve];
//    NSLog(@"insertTask: %@", task);
    [tasks addObject: task];
    [self save];
}

- (void) updateTask: (Task*) task {
    [self retrieve];
    int i = 0;
    
    for(Task* temp in tasks) {
        if([temp.uuid isEqual: task.uuid]){
            break;
        }
        i++;
    }
    
    if(i < tasks.count){
    }
    
    [tasks replaceObjectAtIndex: i withObject: task];
    [self save];
}

- (void) deletaTaskWithUUID: (NSString*) uuid {
    [self retrieve];
    int i = 0;
    for(Task* task in tasks) {
        if([task.uuid isEqual: uuid]){
            break;
        }
        i++;
    }
    
    [tasks removeObjectAtIndex: i];
    [self save];
}

@end
