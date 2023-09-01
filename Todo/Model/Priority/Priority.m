//
//  Priority.m
//  Todo
//
//  Created by Khater on 8/30/23.
//

#import "Priority.h"

@implementation Priority

- (id) init {
    self = [super init];
    _allPriorities = [NSMutableArray new];
    _lowPriority = [NSMutableArray new];
    _mediumPriority = [NSMutableArray new];
    _highPriority = [NSMutableArray new];
    return self;
}

@end
