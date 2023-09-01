//
//  DetailsViewController.h
//  Todo
//
//  Created by Khater on 8/30/23.
//

#import <UIKit/UIKit.h>
#import "TaskManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    DetailsVCAdd=0,
    DetailsVCEdit=1,
    DetailsVCShowOnly=2
} DETAILS;

@interface DetailsViewController : UIViewController

@property DETAILS presentAs;
@property Task *taskDetails;
@property bool disappleTodo;

@end

NS_ASSUME_NONNULL_END
