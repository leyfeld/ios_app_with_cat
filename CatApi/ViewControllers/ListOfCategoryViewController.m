#import <Foundation/Foundation.h>
#import "ListOfCategoryViewController.h"
#import "DetailViewController.h"
#import "PictureRequester.h"
#import "CollectionViewController.h"
#import "Utils.h"


@implementation ListOfCategoryViewController
{
    NSArray* _categories;
    PictureRequester* _pictureRequester;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pictureRequester = [[PictureRequester alloc]init];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError* error = nil;
        _categories = [_pictureRequester getCategories:&error];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if(error)
            {
                [self presentViewController:[Utils alertWithErrorMessage:[error.userInfo valueForKey:NSLocalizedDescriptionKey]] animated:YES completion:nil];
                return;
            }
            
            [self.tableView reloadData];
        });
    });
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = _categories[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CollectionViewController* collectionView = [self.storyboard instantiateViewControllerWithIdentifier:@"collectionView"];
    collectionView.category = _categories[indexPath.row];
    collectionView.pictureRequester = _pictureRequester;
    [self.navigationController pushViewController:collectionView animated:YES];
}



@end
