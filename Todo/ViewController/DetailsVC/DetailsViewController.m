//
//  DetailsViewController.m
//  Todo
//
//  Created by Khater on 8/30/23.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSegment;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;


// My Properties
@property TaskManager* taskManagerUpdate;

@end

@implementation DetailsViewController


// MARK: - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _taskManagerUpdate = [TaskManager new];
    
    
    switch(_perform) {
        case DetailsVCAdd:
            self.title = @"Add";
            break;
        case DetailsVCEdit:
            [self setViewWithTaskData];
            self.title = @"Edit";
            break;
        case DetailsVCShowOnly:
            [self showDetailsOnly];
            self.title = @"Details";
            break;
    }
}


// MARK: - SaveButton
- (IBAction)saveButtonPressed:(id)sender {
    switch(_perform) {
        case DetailsVCAdd:
            [self addTask];
            break;
        case DetailsVCEdit:
            [self editTask];
            break;
        case DetailsVCShowOnly:
            break;
    }
}


- (void) addTask {
    if([_nameTextField.text isEqual: @""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Fail" message: @"Name shouldn't be empty" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleCancel handler: nil];
        [alert addAction: okButton];
        [self presentViewController: alert animated: YES completion:nil];
        return;
    }
    
    Task *task = [[Task alloc] initWithUUID:[[NSUUID UUID] UUIDString]
                                       name: _nameTextField.text
                                description: _descriptionTextField.text
                                  imageName: @"calendar"
                                       date: _datePicker.date
                                   priority: (int)_prioritySegment.selectedSegmentIndex
                                      state: 0];
    
    [_taskManagerUpdate insertTask: task];
    
    [self showAlertWithMassage: @"Task is added Successfully"];
}

- (void) editTask {
    if([_nameTextField.text isEqual: @""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Fail" message: @"Name shouldn't be empty" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleCancel handler: nil];
        [alert addAction: okButton];
        [self presentViewController: alert animated: YES completion:nil];
        _nameTextField.text = _taskDetails.name;
        return;
    }
    
    _taskDetails.name = _nameTextField.text;
    _taskDetails.desc = _descriptionTextField.text;
    _taskDetails.imageName = @"calendar";
    _taskDetails.date = _datePicker.date;
    _taskDetails.priority = (int)_prioritySegment.selectedSegmentIndex;
    _taskDetails.status = (int)_statusSegment.selectedSegmentIndex;
    
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    notification.fireDate = [_datePicker.date addTimeInterval: 5];
//    notification.alertBody = @"Go see your task now";
//    localNotification.alertAction = @"My test for Weekly alarm";
////    [localNotification request]
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    [_taskManagerUpdate updateTask: _taskDetails];
    
    [self showAlertWithMassage: @"Task is updated Successfully"];
}


- (void) showDetailsOnly {
    [self setViewWithTaskData];
    [_statusSegment setEnabled: NO];
    [_nameTextField setEnabled: NO];
    [_descriptionTextField setEnabled: NO];
    [_prioritySegment setEnabled: NO];
    [_statusSegment setEnabled: NO];
    [_datePicker setEnabled: NO];
    [_saveButton setHidden: YES];
}

- (void) setViewWithTaskData {
    [_statusSegment setEnabled: YES];
    _nameTextField.text = _taskDetails.name;
    _descriptionTextField.text = _taskDetails.desc;
    _prioritySegment.selectedSegmentIndex = _taskDetails.priority;
    _statusSegment.selectedSegmentIndex = _taskDetails.status;
    _datePicker.date = _taskDetails.date;
    
    if(_disappleTodo){
        [_statusSegment setEnabled: NO forSegmentAtIndex: 0];
    }
}

- (void) showAlertWithMassage: (NSString*) message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Success" message: message preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *backButton = [UIAlertAction actionWithTitle: @"Back" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated: YES];
    }];
    
    [alert addAction: backButton];
    [self presentViewController: alert animated: YES completion:nil];
}

@end
