
#import <UIKit/UIKit.h>

@class PictureRequester;
@interface CollectionViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) NSString* category;
@property (nonatomic, strong) PictureRequester* pictureRequester;

@end
