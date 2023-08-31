//
//  TodoTableViewController.m
//  Todo
//
//  Created by Khater on 8/30/23.
//

#import "TodoTableViewController.h"
#import "DetailsViewController.h"
#import "TaskManager.h"

@interface TodoTableViewController () <UISearchBarDelegate>

@property UISearchBar *searchBar;

@property TaskManager *taskManagerUpdate;

@property bool isSearching;
@property NSArray<Task*> *searchResult;

@end

@implementation TodoTableViewController


// MARK: - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Todo";
    
    UIBarButtonItem *plusButton = [[UIBarButtonItem alloc] initWithImage: [UIImage systemImageNamed: @"plus"] style: UIBarButtonItemStyleDone target: self action: @selector(plusBarButtonPressed)];
    self.navigationItem.rightBarButtonItem = plusButton;
    
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"myCell"];
    
    [self setupSearchBar];
    
    _taskManagerUpdate = [TaskManager new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [_taskManagerUpdate fetchTasksByStatus: 0];
    [self.tableView reloadData];
}


// MARK: - SearchBar
- (void) setupSearchBar {
    _searchBar = [UISearchBar new];
    _searchBar.placeholder = @"Search...";
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    _isSearching = NO;
}




// MARK: - BarbuttonItem
- (void) plusBarButtonPressed {
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier: @"DetailsViewController"];
    detailsVC.perform = DetailsVCAdd;
    [self.navigationController pushViewController: detailsVC animated: YES];
}




// MARK: - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_isSearching){
        return _searchResult.count == 0 ? 1 : _searchResult.count;
    } else {
        return _taskManagerUpdate.todo.all.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"myCell"];
    
    if(_taskManagerUpdate.todo.all.count == 0){
        cell.textLabel.text = @"No Taskes in TODOS!";
        return cell;
    }
    
    if(_isSearching){
        if(_searchResult.count == 0){
            cell.textLabel.text = @"No Results!";
        } else {
            cell.textLabel.text = _searchResult[indexPath.row].name;
            cell.detailTextLabel.text = _searchResult[indexPath.row].desc;
            cell.imageView.image = [UIImage systemImageNamed: _searchResult[indexPath.row].imageName];
        }
        return cell;
    }
    
    Task *task = _taskManagerUpdate.todo.all[indexPath.row];
    cell.textLabel.text = task.name;
    
    switch(task.priority) {
        case 0:
            cell.textLabel.textColor = [UIColor systemGreenColor];
            break;
        case 1:
            cell.textLabel.textColor = [UIColor blueColor];
            break;
            
        case 2:
            cell.textLabel.textColor = [UIColor redColor];
    }
    
    cell.detailTextLabel.text = task.desc;
    cell.imageView.image = [UIImage systemImageNamed: task.imageName];
    
    return cell;
}



// MARK: - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier: @"DetailsViewController"];
    detailsVC.perform = DetailsVCEdit;
    detailsVC.taskDetails = _taskManagerUpdate.todo.all[indexPath.row];
    [self.navigationController pushViewController: detailsVC animated: YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    Task* task = _taskManagerUpdate.todo.all[indexPath.row];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Delete" message: @"Are you sure to delete!" preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle: @"Cancel" style: UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteButton = [UIAlertAction actionWithTitle: @"Delete" style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.taskManagerUpdate deletaTaskWithUUID: task.uuid];
        [self.taskManagerUpdate fetchTasksByStatus: 0];
        [self.tableView reloadData];
    }];
    
    [alert addAction: cancelButton];
    [alert addAction: deleteButton];
    [self presentViewController: alert animated: YES completion:nil];
}



// MARK: - SearchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText isEqual: @""]) {
        [_taskManagerUpdate fetchTasksByStatus: 0];
        _isSearching = NO;
    } else {
        _isSearching = YES;
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"name CONTAINS[c] %@", searchText];
        _searchResult = [_taskManagerUpdate.todo.all filteredArrayUsingPredicate: predicate];
    }
    [self.tableView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    _isSearching = YES;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    [searchBar.searchTextField endEditing: YES];
    _isSearching = NO;
    searchBar.searchTextField.text = @"";
    [_taskManagerUpdate fetchTasksByStatus: 0];
    [self.tableView reloadData];
}

@end
