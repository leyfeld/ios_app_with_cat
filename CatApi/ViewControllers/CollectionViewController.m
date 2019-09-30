
#import "CollectionViewController.h"
#import "DetailViewController.h"
#import "CollectionViewCell.h"
#import "PictureRequester.h"
#import "Utils.h"


@implementation CollectionViewController
{
    NSMutableArray* _images;
    NSUInteger _limitForImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _limitForImage = 20;
    _images = [[NSMutableArray alloc]init];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError* error = nil;
        NSArray* imagesUrls = [self.pictureRequester getURLsForCategory:self.category error:&error];
        if(error)
        {
            NSLog(@"%@", [error.userInfo valueForKey:NSLocalizedDescriptionKey]);
            [self showErrorMessageInMainQueue:[error.userInfo valueForKey:NSLocalizedDescriptionKey]];
            return;
        }
        
        [self downloadImages:imagesUrls];
    });
}

-(void)downloadImages:(NSArray*)imagesUrls
{
    if(imagesUrls.count == 0)
    {
        [self showErrorMessageInMainQueue:@"You didn't have images"];
        return;
    }
    for(NSString* urlImage in imagesUrls)
    {
        NSError* error = nil;
        UIImage* newImage = [Utils downloadImage:urlImage error:&error];
        if(error)
        {
            NSLog(@"%@", [error.userInfo valueForKey:NSLocalizedDescriptionKey]);
            [self showErrorMessageInMainQueue:[error.userInfo valueForKey:NSLocalizedDescriptionKey]];
            return;
        }
        if(newImage)
        {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                [self->_images addObject:newImage];
                [self.collectionView reloadData];
            });
        }
    }
}

-(void)showErrorMessageInMainQueue:(NSString*)message
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:[Utils alertWithErrorMessage:message] animated:YES completion:nil];
    });
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _limitForImage;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    BOOL shouldRedrawImageAtIndex = [_images count] > indexPath.row;
    cell.catImage.image = shouldRedrawImageAtIndex ? _images[indexPath.row] : [Utils waitSpinerGif];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(_images.count > indexPath.row)
    {
        UIImage *senderImg = [_images objectAtIndex:indexPath.item];
        DetailViewController* nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"showImage"];
        nextView.receivedImage = senderImg;
        [self.navigationController pushViewController:nextView animated:YES];
    }
}



@end
