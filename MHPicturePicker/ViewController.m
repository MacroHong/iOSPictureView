//
//  ViewController.m
//  MHPicturePicker
//
//  Created by Macro on 10/28/15.
//  Copyright © 2015 Macro. All rights reserved.
//

#import "ViewController.h"

#import "MHPictureView.h"


#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height


@interface ViewController ()
{

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat gap = (kWidth - 90 * 4) / 5;
    
    for (int i = 0; i < 36; i++) {
        MHPictureView *pv = [[MHPictureView alloc] init];
        pv.frame = CGRectMake(gap + (90 + gap) * (i % 4), 50 + (60 + gap) * ( i / 4), 90, 60);
        pv.deletePictureBlock = ^() {
            NSLog(@"删除图片了");
        };
        [self.view addSubview:pv];
    }
}




- (void)didReceiveMemoryWarning {
    
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"内存告警" message:nil delegate:nil cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
    [av show];
    
    
    NSLog(@"内存告警");
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
