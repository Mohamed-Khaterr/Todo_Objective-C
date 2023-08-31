//
//  Task.m
//  Todo
//
//  Created by Khater on 8/30/23.
//

#import "Task.h"

@implementation Task

- (id) initWithUUID: (NSString*) uuid name: (NSString*) name description: (NSString*) desc imageName: (NSString*) imageName date: (NSDate*) date priority: (int) priority state: (int) status {
    self = [super init];
    self.uuid = uuid;
    self.name = name;
    self.desc = desc;
    self.imageName = imageName;
    self.priority = priority;
    self.status = status;
    self.date = date;
    return self;
}

- (void)encodeWithCoder:(NSCoder *) encoder {
    [encoder encodeObject: _uuid forKey: @"uuid"];
    [encoder encodeObject: _name forKey: @"name"];
    [encoder encodeObject: _desc forKey: @"desc"];
    [encoder encodeObject: _imageName forKey: @"imageName"];
    [encoder encodeObject: _date forKey: @"date"];
    [encoder encodeInt: _priority forKey: @"priority"];
    [encoder encodeInt: _status forKey: @"state"];
}

- (id)initWithCoder:(NSCoder *) decoder {
    self = [super init];
    if (self != nil){
        _uuid = [decoder decodeObjectForKey: @"uuid"];
        _name = [decoder decodeObjectForKey: @"name"];
        _desc = [decoder decodeObjectForKey: @"desc"];
        _imageName = [decoder decodeObjectForKey: @"imageName"];
        _date = [decoder decodeObjectForKey: @"date"];
        _priority = [decoder decodeIntForKey:@"priority"];
        _status = [decoder decodeIntForKey: @"state"];
    }
    return self;
}


@end
