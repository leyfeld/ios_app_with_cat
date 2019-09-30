

#import "Utils.h"
#import "UIImage+animatedGIF.h"

@implementation Utils

+(UIImage*)downloadImage:(NSString*)stringWithUrl error:(NSError**)error
{
    NSURL *url= [NSURL URLWithString:stringWithUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:error];
    if(*error)
    {
        NSLog(@"Error %@", *error);
        return nil;
    }
    return [UIImage imageWithData:imageData];
}


+(UIAlertController*)alertWithErrorMessage:(NSString*)message
{
    UIAlertController*alert = [UIAlertController alertControllerWithTitle:@"Sorry, something went wrong🥺"
                                                                  message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    return  alert;
}

+(UIImage*)waitSpinerGif
{
    NSString* gifPath = [[NSBundle mainBundle] pathForResource:@"spiner" ofType:@"gif"];
    NSData* gifData = [NSData dataWithContentsOfFile:gifPath];
    return [UIImage animatedImageWithAnimatedGIFData:gifData];
}

@end
