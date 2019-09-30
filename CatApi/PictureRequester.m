
#import "PictureRequester.h"

@implementation PictureRequester
{
    NSDictionary* _categoriesWithId;
}

-(NSDictionary*)urlRequest:(NSString*)urlString error:(NSError**)error
{
    NSDictionary* headers = @{ @"x-api-key": @"DEMO-API-KEY" };
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    dispatch_semaphore_t semaphore;
    semaphore = dispatch_semaphore_create(0);
    __block NSDictionary* result;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError* sessionError)
                                      {
                                          if (sessionError) {
                                              *error = sessionError;
                                              NSLog(@"Error %@", sessionError);
                                          } else {
                                              result = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
                                              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                              NSLog(@"%@", httpResponse);
                                          }
                                          dispatch_semaphore_signal(semaphore);
                                      }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return result;
}

-(NSArray*)getCategories:(NSError**)error
{
    NSDictionary* result = [self urlRequest:@"https://api.thecatapi.com/v1/categories" error:error];
    if(*error)
    {
        NSLog(@"Error %@", *error);
        return nil;
    }
    _categoriesWithId = [[NSDictionary alloc] initWithObjects:[result valueForKey:@"name"] forKeys:[result valueForKey:@"id"]];
    return [_categoriesWithId allValues];
}

-(NSArray*)getURLsForCategory:(NSString*)category error:(NSError**)error
{
    NSString* urlString = [NSString stringWithFormat:@"https://api.thecatapi.com/v1/images/search?limit=10&category_ids=%@",[_categoriesWithId allKeysForObject:category][0]];
    NSDictionary* result = [self urlRequest:urlString error:error];
    if(*error)
    {
        NSLog(@"Error %@", *error);
        return nil;
    }
    return [result valueForKey:@"url"];
}

@end
