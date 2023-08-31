//
//  TaskManagerUpdate.h
//  Todo
//
//  Created by Khater on 8/30/23.
//

#import <Foundation/Foundation.h>
#import "Priority.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskManager : NSObject {
    NSUserDefaults *userDefaults;
    NSMutableArray<Task*> *tasks;
}

@property Priority *todo;
@property Priority *inProgress;
@property Priority *done;


- (void) fetchTasksByStatus: (int) status;
- (void) insertTask: (Task*) task;
- (void) updateTask: (Task*) task;
- (void) deletaTaskWithUUID: (NSString*) uuid;

@end

NS_ASSUME_NONNULL_END
