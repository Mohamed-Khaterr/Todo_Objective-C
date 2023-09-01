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
    _allPriorities = [NSArray new];
    _lowPriority = [NSArray new];
    _mediumPriority = [NSArray new];
    _highPriority = [NSArray new];
    return self;
}

@end
