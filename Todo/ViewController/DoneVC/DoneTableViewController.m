//
//  DoneTableViewController.m
//  Todo
//
//  Created by Khater on 8/30/23.
//

#import "DoneTableViewController.h"
#import "DetailsViewController.h"
#import "TaskManager.h"
#import "NSArray+EmptyArray.h"

@interface DoneTableViewController ()

//@property TaskManager *taskManager;
@property TaskManager *taskManager;
@property bool isSorted;

@end

@implementation DoneTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Done";
    
    _taskManager = [TaskManager new];
    
    UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithTitle: @"Sort" style: UIBarButtonItemStyleDone target: self action: @selector(sortButtonPressed)];
    self.navigationItem.rightBarButtonItem = sortButton;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [_taskManager fetchTasksWithStatusEqualTo: 2];
    [self.tableView reloadData];
}


// MARK: - Sort Button Action
- (void) sortButtonPressed {
    _isSorted = !_isSorted;
    [self.tableView reloadData];
}



// MARK: - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _isSorted ? 3 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_taskManager.done.allPriorities.isEmpty){
        return 1;
    }
    
    
    if(_isSorted) {
        switch(section) {
            case 0:
                return _taskManager.done.lowPriority.count;
            case 1:
                return _taskManager.done.mediumPriority.count;
            case 2:
                return _taskManager.done.highPriority.count;
            default:
                return 0;
        }
    } else {
        return _taskManager.done.allPriorities.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"myCell"];
    
    if(_taskManager.done.allPriorities.isEmpty){
        cell.textLabel.text = @"No Tasks finished!";
        return cell;
    }
    
    Task *task;
    
    if(_isSorted){
        switch(indexPath.section) {
            case 0:
                task = _taskManager.done.lowPriority[indexPath.row];
                break;
            case 1:
                task = _taskManager.done.mediumPriority[indexPath.row];
                break;
            case 2:
                task = _taskManager.done.highPriority[indexPath.row];
                break;
        }
    } else {
        task = _taskManager.done.allPriorities[indexPath.row];
    }
    
    cell.textLabel.text = task.name;
    cell.detailTextLabel.text = task.desc;
    cell.imageView.image = [UIImage systemImageNamed: task.imageName];
    
    switch(task.priority) {
        case 0:
            cell.imageView.tintColor = [UIColor systemGreenColor];
            break;
        case 1:
            cell.imageView.tintColor = [UIColor blueColor];
            break;
            
        case 2:
            cell.imageView.tintColor = [UIColor redColor];
    }
    
    return cell;
}



// MARK: - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_taskManager.done.allPriorities.isEmpty){
        [tableView deselectRowAtIndexPath: indexPath animated:YES];
        return;
    }
    
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier: @"DetailsViewController"];
    detailsVC.presentAs = DetailsVCShowOnly;
    if(_isSorted){
        switch(indexPath.section) {
            case 0:
                detailsVC.taskDetails = _taskManager.done.lowPriority[indexPath.row];
                break;
            case 1:
                detailsVC.taskDetails = _taskManager.done.mediumPriority[indexPath.row];
                break;
            case 2:
                detailsVC.taskDetails = _taskManager.done.highPriority[indexPath.row];
                break;
        }
        detailsVC.disappleTodo = YES;
    } else {
        detailsVC.taskDetails = _taskManager.done.allPriorities[indexPath.row];
        detailsVC.disappleTodo = YES;
    }
    
    [self.navigationController pushViewController: detailsVC animated: YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_taskManager.done.allPriorities.isEmpty && editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Delete" message: @"Are you sure to delete!" preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle: @"Cancel" style: UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteButton = [UIAlertAction actionWithTitle: @"Delete" style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if(self.isSorted){
            switch(indexPath.section){
                case 0:
                    [self.taskManager deleteTaskWithUUID: self.taskManager.done.lowPriority[indexPath.row].uuid];
                    break;
                case 1:
                    [self.taskManager deleteTaskWithUUID: self.taskManager.done.mediumPriority[indexPath.row].uuid];
                    break;
                case 2:
                    [self.taskManager deleteTaskWithUUID: self.taskManager.done.highPriority[indexPath.row].uuid];
                    break;
            }
        } else {
            [self.taskManager deleteTaskWithUUID: self.taskManager.done.allPriorities[indexPath.row].uuid];
        }
        
        [self.taskManager fetchTasksWithStatusEqualTo: 2];
        [self.tableView reloadData];
    }];
    
    [alert addAction: cancelButton];
    [alert addAction: deleteButton];
    [self presentViewController: alert animated: YES completion:nil];
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(_isSorted) {
        switch (section) {
            case 0:
                return @"Low";
                break;
                
            case 1:
                return @"Medium";
                break;
                
            case 2:
                return @"High";
                break;
                
            default:
                return @"";
        }
    } else {
        return @"";
    }
}

@end
