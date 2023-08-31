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
@property NSMutableArray<Task*> *all;
@property NSMutableArray<Task*> *low;
@property NSMutableArray<Task*> *medium;
@property NSMutableArray<Task*> *high;


@end

NS_ASSUME_NONNULL_END
