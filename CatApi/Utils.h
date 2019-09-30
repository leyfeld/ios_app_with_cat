
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Utils : NSObject

+(UIImage*)waitSpinerGif;
+(UIImage*)downloadImage:(NSString*)stringWithUrl error:(NSError**)error;
+(UIAlertController*)alertWithErrorMessage:(NSString*)message;

@end

