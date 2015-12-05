//
//  TweetsController.m
//  TwitterApi
//
//  Created by Sergii Sinkevych on 29.11.15.
//  Copyright © 2015 Sergii Sinkevych. All rights reserved.
//

#import "TweetsController.h"
#import "Tweet.h"
#import "ApiManager.h"

@interface TweetsController () <NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSArray *tweetsArray;
@property (nonatomic, strong) NSMutableData *mainData;

@end

@implementation TweetsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.login;
    
    //[self delegationMethod];
    [self blockMethod];
}

#pragma mark - Private methods

- (void)blockMethod {
    ApiManager *apiManager = [ApiManager sharedInstance];
    NSMutableURLRequest *bearerRequest = [apiManager createBearerRequestWithUsername:self.login];
    
    [apiManager getDataWithRequest:bearerRequest success:^(NSData *responceData) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [self serializeResponseWithData:responceData];
    } failure:^(NSError *error) {
        [self showError:error orReason:nil];
    }];
}

- (void) delegationMethod {
    ApiManager *apiManager = [[ApiManager alloc] init];
    NSMutableURLRequest *bearerRequest = [apiManager createBearerRequestWithUsername:self.login];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:queue];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:bearerRequest];
    [downloadTask resume];
}

- (void)serializeResponseWithData:(NSData *)data {
    NSError *jsonError;
    NSObject *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    if ([json isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)json;
        NSString *reason = [NSString stringWithFormat:@"%@",[dict[@"errors"] valueForKey:@"message"]];
        [self showError:nil orReason:reason];
    } else if([json isKindOfClass:[NSArray class]]) {
        if (!jsonError) {
            NSArray *array = (NSArray *)json;
            ApiManager *apiManager = [ApiManager sharedInstance];
            self.tweetsArray = [apiManager tweetsFromArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [self.tableView reloadData];
            });
        } else {
            [self showError:jsonError orReason:nil];
        }
    }
}

- (void)showError:(NSError *)error orReason:(NSString *)reason {
    NSString *message;
    if (error != nil) {
        message = [NSString stringWithFormat:@"%@", error.localizedDescription];
    }
    if (reason != nil) {
        message = reason;
    }
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Ups!"
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    [alertController addAction:action];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    if (!self.mainData) {
        self.mainData = [data mutableCopy];
    } else {
        [self.mainData appendData:data];
    }
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"Task completed with error - %@", error.localizedDescription);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    NSData *data = [NSData dataWithContentsOfURL:location];
    [self serializeResponseWithData:data];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"Recieved data - %lld", bytesWritten);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Tweet *tweet = self.tweetsArray[indexPath.row];
    cell.textLabel.text = tweet.text;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.numberOfLines = 4;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.text = [tweet createdAtStringValue];
    
    NSURL *imageURL = [NSURL URLWithString:tweet.imageURL];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    cell.imageView.image = [UIImage imageWithData:imageData];
    if (!imageData) {
        cell.imageView.image = [UIImage imageNamed:@"default.png"];
    }
    
    return cell;
}







/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
