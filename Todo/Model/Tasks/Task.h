//
//  Task.h
//  Todo
//
//  Created by Khater on 8/30/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject <NSCoding>

@property NSString *uuid;
@property int priority;
@property int status;
@property NSString *name;
@property NSString *desc;
@property NSString *imageName;
@property NSDate *date;

- (id) initWithUUID: (NSString*) uuid name: (NSString*) name description: (NSString*) desc imageName: (NSString*) imageName date: (NSDate*) date priority: (int) priority state: (int) status;

@end

NS_ASSUME_NONNULL_END
