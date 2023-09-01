//
//  Priority.h
//  Todo
//
//  Created by Khater on 8/30/23.
//

#import <Foundation/Foundation.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface Priority : NSObject

// Properties
@property NSMutableArray<Task*> *allPriorities;
@property NSMutableArray<Task*> *lowPriority;
@property NSMutableArray<Task*> *mediumPriority;
@property NSMutableArray<Task*> *highPriority;


@end

NS_ASSUME_NONNULL_END
