//
//  KPictureView.m
//  MHPicturePicker
//
//  Created by Macro on 11/27/15.
//  Copyright © 2015 Macro. All rights reserved.
//

#import "KPictureView.h"
#import "MHPictureView.h"
#import "DEFINE.h"
#import "UIImageView+MHImageWebCache.h"

@implementation KPictureView

#pragma mark - over write

- (instancetype)init {
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                 contentArray:(NSArray <NSString *> *)arr {
    self = [super initWithFrame:frame];
    if (self) {
        if (arr) {
            for (int i = 0; i < arr.count; i++) {
                MHPictureView *pv = [[MHPictureView alloc] init];
                pv.frame = [self rectWithIndex:i];
                [pv setWebImageWithUrlStr:arr[i] placeholderImageName:@"image_bg"];
                pv.canDelete = NO;
                [self addSubview:pv];
            }
        }
    }
    return self;
}

#pragma mark - local method

- (void)config {
    _imageDataArray = [[NSMutableArray alloc] init];
    [self addPictureViewWithIndex:_imageDataArray.count  hasData:NO];
}


- (void)addPictureViewWithIndex:(NSInteger)index hasData:(BOOL)has{
    MHPictureView *pv = [[MHPictureView alloc] init];
    pv.frame = [self rectWithIndex:index];
    if (has) {
        [pv setImageWithData:_imageDataArray[index]];
    }
    pv.takeSuccessBlock = ^(NSData *imageData) {
        [self addImageData:imageData];
    };
    pv.deletePictureBlock = ^(NSData *imageData) {
        [self deleteImageData:imageData];
    };
    [self addSubview:pv];
}


- (CGRect)rectWithIndex:(NSInteger)index {
    CGFloat w = (kWidth - 60) / 3;
    CGFloat h = w * 2 / 3 ;
    return CGRectMake(20 + (w + 10) * index, 20, w, h);
}

- (void)addImageData:(NSData *)imageData {
    [_imageDataArray addObject:imageData];
    [self addTakePictureView];
}

- (void)deleteImageData:(NSData *)imageData {
    [self removeAllSubViews];
    [_imageDataArray removeObject:imageData];
    for (int i = 0; i < _imageDataArray.count; i++) {
        [self addPictureViewWithIndex:i hasData:YES];
    }
    [self addTakePictureView];
}

- (void)addTakePictureView {
    if (_imageDataArray.count != 3) {
        [self addPictureViewWithIndex:_imageDataArray.count hasData:NO];
    }
}

- (void)removeAllSubViews {
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
}







@end
