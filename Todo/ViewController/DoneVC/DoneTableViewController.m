//
//  DoneTableViewController.m
//  Todo
//
//  Created by Khater on 8/30/23.
//

#import "DoneTableViewController.h"
#import "DetailsViewController.h"
#import "TaskManager.h"

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
    [_taskManager fetchTasksByStatus: 2];
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
    if(_isSorted) {
        switch(section) {
            case 0:
                return _taskManager.done.low.count;
            case 1:
                return _taskManager.done.medium.count;
            case 2:
                return _taskManager.done.high.count;
            default:
                return 0;
        }
    } else {
        return _taskManager.done.all.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"myCell"];
    
    if(_isSorted){
        Task *task;
        switch(indexPath.section) {
            case 0:
                task = _taskManager.done.low[indexPath.row];
                break;
            case 1:
                task = _taskManager.done.medium[indexPath.row];
                break;
            case 2:
                task = _taskManager.done.high[indexPath.row];
                break;
        }
        
        cell.textLabel.text = task.name;
        cell.detailTextLabel.text = task.desc;
        cell.imageView.image = [UIImage systemImageNamed: task.imageName];
    } else {
        Task *task = _taskManager.done.all[indexPath.row];
        cell.textLabel.text = task.name;
        cell.detailTextLabel.text = task.desc;
        cell.imageView.image = [UIImage systemImageNamed: task.imageName];
    }
    
    return cell;
}



// MARK: - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier: @"DetailsViewController"];
    detailsVC.perform = DetailsVCShowOnly;
    detailsVC.taskDetails = _taskManager.done.all[indexPath.row];
    [self.navigationController pushViewController: detailsVC animated: YES];
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Delete" message: @"Are you sure to delete!" preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle: @"Cancel" style: UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteButton = [UIAlertAction actionWithTitle: @"Delete" style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if(self.isSorted){
            switch(indexPath.section){
                case 0:
                    [self.taskManager deletaTaskWithUUID: self.taskManager.done.low[indexPath.row].uuid];
                    break;
                case 1:
                    [self.taskManager deletaTaskWithUUID: self.taskManager.done.medium[indexPath.row].uuid];
                    break;
                case 2:
                    [self.taskManager deletaTaskWithUUID: self.taskManager.done.high[indexPath.row].uuid];
                    break;
            }
        } else {
            [self.taskManager deletaTaskWithUUID: self.taskManager.done.all[indexPath.row].uuid];
        }
        
        [self.taskManager fetchTasksByStatus: 2];
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
