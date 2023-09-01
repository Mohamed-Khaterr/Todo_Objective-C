//
//  NSArray+EmptyArray.m
//  Todo
//
//  Created by Khater on 9/2/23.
//

#import "NSArray+EmptyArray.h"

@implementation NSArray (EmptyArray)

- (bool) isEmpty {
    return self.count == 0;
}

@end
