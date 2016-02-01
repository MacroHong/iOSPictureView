//
//  ViewController.m
//  MHPicturePicker
//
//  Created by Macro on 10/28/15.
//  Copyright © 2015 Macro. All rights reserved.
//

#import "ViewController.h"
#import "DEFINE.h"

#import "MHPictureView.h"


#import "KPictureView.h"


@interface ViewController ()
{
    NSMutableArray <NSData *> *_imageDataArr;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    _imageDataArr = [[NSMutableArray alloc] init];
//
//    [self addPictureViewWithIndex:_imageDataArr.count  hasData:NO];
    
    CGFloat w = (kWidth - 60) / 3;
    CGFloat h = w * 2 / 3 ;

    
    KPictureView *picView = [[KPictureView alloc] initWithFrame:CGRectMake(0, 50, kWidth, h + 40)];
    picView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:picView];
    
    
    
    NSArray *arr = @[@"http://cdn.duitang.com/uploads/item/201409/13/20140913141520_Ydidj.jpeg", @"http://img5.duitang.com/uploads/item/201206/06/20120606175201_WZ2F3.thumb.700_0.jpeg"];
    KPictureView *picView2 = [[KPictureView alloc] initWithFrame:CGRectMake(0, 250, kWidth, h + 40) contentArray:arr];
    picView2.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:picView2];

    
}


- (CGRect)rectWithIndex:(NSInteger)index {
    CGFloat gap = (kWidth - 90 * 4) / 5;
    return CGRectMake(gap + (90 + gap) * (index % 4), 50 + (60 + gap) * (index / 4), 90, 60);
}

- (void)addImageData:(NSData *)imageData {
    [_imageDataArr addObject:imageData];
    [self addPictureViewWithIndex:_imageDataArr.count  hasData:NO];
}

- (void)deleteImageData:(NSData *)imageData {
    [self removeAllSubViews];
    [_imageDataArr removeObject:imageData];
    for (int i = 0; i <= _imageDataArr.count; i++) {
        [self addPictureViewWithIndex:i hasData:i<_imageDataArr.count];
    }
}

- (void)addPictureViewWithIndex:(NSInteger)index hasData:(BOOL)has{
    MHPictureView *pv = [[MHPictureView alloc] init];
    pv.frame = [self rectWithIndex:index];
    if (has) {
        [pv setImageWithData:_imageDataArr[index]];
    }
    pv.takeSuccessBlock = ^(NSData *imageData) {
        [self addImageData:imageData];
    };
    pv.deletePictureBlock = ^(NSData *imageData) {
        [self deleteImageData:imageData];
    };
    [self.view addSubview:pv];
}


- (void)removeAllSubViews {
    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
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
