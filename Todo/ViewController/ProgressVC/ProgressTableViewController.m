//
//  ProgressTableViewController.m
//  Todo
//
//  Created by Khater on 8/30/23.
//

#import "ProgressTableViewController.h"
#import "DetailsViewController.h"
#import "TaskManager.h"

@interface ProgressTableViewController ()

@property TaskManager *taskManager;
@property bool isSorted;

@end

@implementation ProgressTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _taskManager = [TaskManager new];
    
    self.title = @"In Progress";
    
    UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithTitle: @"Sort" style: UIBarButtonItemStyleDone target: self action: @selector(sortButtonPressed)];
    self.navigationItem.rightBarButtonItem = sortButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [_taskManager fetchTasksByStatus: 1];
    [self.tableView reloadData];
}

- (void) sortButtonPressed {
    _isSorted = !_isSorted;
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _isSorted ? 3 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if((int)_taskManager.inProgress.all.count == 0){
        return 1;
    }
    
    if(_isSorted) {
        switch(section) {
            case 0:
                return _taskManager.inProgress.low.count;
            case 1:
                return _taskManager.inProgress.medium.count;
            case 2:
                return _taskManager.inProgress.high.count;
            default:
                return 0;
        }
    } else {
        return _taskManager.inProgress.all.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"myCell"];
    
    if((int)_taskManager.inProgress.all.count == 0){
        cell.textLabel.text = @"No Tasks in progress!";
        return cell;
    }
    
    if(_isSorted){
        Task *task;
        switch(indexPath.section) {
            case 0:
                task = _taskManager.inProgress.low[indexPath.row];
                break;
            case 1:
                task = _taskManager.inProgress.medium[indexPath.row];
                break;
            case 2:
                task = _taskManager.inProgress.high[indexPath.row];
                break;
        }
        
        cell.textLabel.text = task.name;
        cell.detailTextLabel.text = task.desc;
        cell.imageView.image = [UIImage systemImageNamed: task.imageName];
    } else {
        Task *task = _taskManager.inProgress.all[indexPath.row];
        cell.textLabel.text = task.name;
        cell.detailTextLabel.text = task.desc;
        cell.imageView.image = [UIImage systemImageNamed: task.imageName];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if((int)_taskManager.inProgress.all.count == 0){
        [tableView deselectRowAtIndexPath: indexPath animated:YES];
        return;
    }
    
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier: @"DetailsViewController"];
    detailsVC.perform = DetailsVCEdit;
    if(_isSorted){
        switch(indexPath.section) {
            case 0:
                detailsVC.taskDetails = _taskManager.inProgress.low[indexPath.row];
                break;
            case 1:
                detailsVC.taskDetails = _taskManager.inProgress.medium[indexPath.row];
                break;
            case 2:
                detailsVC.taskDetails = _taskManager.inProgress.high[indexPath.row];
                break;
        }
        detailsVC.disappleTodo = YES;
    } else {
        detailsVC.taskDetails = _taskManager.inProgress.all[indexPath.row];
        detailsVC.disappleTodo = YES;
    }
    
    [self.navigationController pushViewController: detailsVC animated: YES];
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if((int)_taskManager.inProgress.all.count == 0){
        [tableView deselectRowAtIndexPath: indexPath animated:YES];
        return;
    }
    
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Delete" message: @"Are you sure to delete!" preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle: @"Cancel" style: UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteButton = [UIAlertAction actionWithTitle: @"Delete" style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if(self.isSorted){
            switch(indexPath.section){
                case 0:
                    [self.taskManager deletaTaskWithUUID: self.taskManager.inProgress.low[indexPath.row].uuid];
                    break;
                case 1:
                    [self.taskManager deletaTaskWithUUID: self.taskManager.inProgress.medium[indexPath.row].uuid];
                    break;
                case 2:
                    [self.taskManager deletaTaskWithUUID: self.taskManager.inProgress.high[indexPath.row].uuid];
                    break;
            }
        } else {
            [self.taskManager deletaTaskWithUUID: self.taskManager.inProgress.all[indexPath.row].uuid];
        }
        [self.taskManager fetchTasksByStatus: 1];
        [self.tableView reloadData];
    }];
    
    [alert addAction: cancelButton];
    [alert addAction: deleteButton];
    [self presentViewController: alert animated: YES completion:nil];
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(!_isSorted) {
        return @"";
    }
    
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
}

@end
