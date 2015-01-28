//
//  TodoThing.h
//  MyClear
//
//  Created by boli on 1/22/15.
//  Copyright (c) 2015 boli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TodoThing : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * thing;
@property (nonatomic, retain) NSDate * deadline;

@end
