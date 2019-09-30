
#import "DetailViewController.h"

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _imageView.image = _receivedImage;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
