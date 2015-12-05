//
//  ViewController.m
//  TwitterApi
//
//  Created by Sergii Sinkevych on 27.11.15.
//  Copyright © 2015 Sergii Sinkevych. All rights reserved.
//

#import "ViewController.h"
#import "TweetsController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TweetsController *vc = segue.destinationViewController;
    vc.login = self.textField.text;
}

@end
