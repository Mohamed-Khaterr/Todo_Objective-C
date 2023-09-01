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
@property NSArray<Task*> *allPriorities;
@property NSArray<Task*> *lowPriority;
@property NSArray<Task*> *mediumPriority;
@property NSArray<Task*> *highPriority;


@end

NS_ASSUME_NONNULL_END
