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
    _all = [NSMutableArray new];
    _low = [NSMutableArray new];
    _medium = [NSMutableArray new];
    _high = [NSMutableArray new];
    return self;
}

@end
