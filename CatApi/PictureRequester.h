
#import <Foundation/Foundation.h>


@interface PictureRequester : NSObject

-(NSArray*)getCategories:(NSError**)error;
-(NSArray*)getURLsForCategory:(NSString*)category error:(NSError**)error;

@end

