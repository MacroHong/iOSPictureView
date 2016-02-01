//
//  MHPictureView.m
//  MHPicturePicker
//
//  Created by Macro on 11/20/15.
//  Copyright © 2015 Macro. All rights reserved.
//

#import "MHPictureView.h"
#import "DEFINE.h"

#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureDevice.h>


@interface MHPictureView ()<UIActionSheetDelegate,
                            UINavigationControllerDelegate,
                            UIImagePickerControllerDelegate,
                            UIAlertViewDelegate>
{
    UIImagePickerController *_imagePickerController;
}
@end

@implementation MHPictureView

#pragma mark - overwrite

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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

- (instancetype)init {
    self = [super init];
    if (self) {
        [self config];
    }
    return self;
}

#pragma mark - api

//- (void)setImage:(UIImage *)image {
//    [super setImage:image];
//    _imgData = UIImageJPEGRepresentation(image, 1.0);
//}

- (void)setImageWithData:(NSData *)imageData {
    UIImage *image = [UIImage imageWithData:imageData];
    self.image = image;
    _imgData = imageData;

}


#pragma mark - local method

/*!
 *  @author Macro QQ:778165728, 15-11-26
 *
 *  @brief  初始化全局变量
 */
- (void)config {
    _canDelete = YES;
    self.userInteractionEnabled = YES;
    [self setDefaultBackGround];
    // 添加点击手势 用于查看或者拍照
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    // 添加长按手势弹框提示删除
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
    
}


- (void)setDefaultBackGround {
    UIImage *image = [UIImage imageNamed:@"image_bg"];
    self.layer.contents = (id)image.CGImage;

}

- (BOOL)imageIsEmpty {
    return ([self.image isEqual:[UIImage imageNamed:@"lucency_bg_for_picture_view"]]
            || self.image == nil);
}

- (UIViewController *)viewController {
    for (UIView *view = [self superview]; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - PressGestureRecognizer

- (void)tapAction {
    NSLog(@"tap");
    if ([self imageIsEmpty]) {
        UIActionSheet *sheet;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                delegate:self
                                       cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:@"拍照",@"从相册中选取", nil];
        } else { // 模拟器无相机
            sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                delegate:self
                                       cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                       otherButtonTitles:@"从相册中选取", nil];
        }
        [sheet showInView:[self viewController].view];
    } else {
        UIImageView *detailImage = [[UIImageView alloc]
                                    initWithFrame:[UIScreen mainScreen].bounds];
        detailImage.image = self.image;
        detailImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *detailTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(detailTap:)];
        [detailImage addGestureRecognizer:detailTap];
        [[self viewController].view addSubview:detailImage];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    NSLog(@"long press delete image");
    if (![self imageIsEmpty] && _canDelete) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"是否确认删除图片?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [self removeGestureRecognizer:longPress];
        [av show];
    }
}

- (void)detailTap:(UITapGestureRecognizer *)tap {
    NSLog(@"detail tap remove detail");
    [tap.view removeFromSuperview];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        self.image = [UIImage imageNamed:@"lucency_bg_for_picture_view"];
        [self setDefaultBackGround];
        if (self.deletePictureBlock) {
            self.deletePictureBlock(self.imgData);
        }
    }
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0: {
                // 相机  用户选择了相机
                NSString *mediaType = AVMediaTypeVideo;
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) { // 没有访问权限
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"访问相机受限!"
                                                                 message:@""
                                                                delegate:nil
                                                       cancelButtonTitle:@"确认"
                                                       otherButtonTitles:nil, nil];
                    [av show];
                    return;
                }
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            }
            case 1: {
                // 相册  用户选择了相册
                NSString *mediaType = AVMediaTypeVideo;
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) { // 没有访问权限
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"访问相册受限!"
                                                                 message:@""
                                                                delegate:nil
                                                       cancelButtonTitle:@"确认"
                                                       otherButtonTitles:nil, nil];
                    [av show];
                    return;
                }
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            }
            case 2: {
                // 取消
                return;
            }
        }
    } else {
        if (buttonIndex == 0) {
            // 相册  用户选择了相册
            NSString *mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) { // 没有访问权限
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"访问相册受限!"
                                                             message:@""
                                                            delegate:nil
                                                   cancelButtonTitle:@"确认"
                                                   otherButtonTitles:nil, nil];
                [av show];
                return;
            }
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else {
            return;
        }
    }
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.sourceType = sourceType;
    _imagePickerController.allowsEditing = YES;
    _imagePickerController.delegate = self;
    [[self viewController] presentViewController:_imagePickerController
                                        animated:YES completion:^{}];
}

#pragma mark - UIImagePickerControllerDelegate UINavigationControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES
                               completion:^{}];
    // 获取到的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    CGSize newSize = CGSizeMake(kWidth, kHeight);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // 压缩图片 减少程序crash几率
    NSData *imgData = UIImageJPEGRepresentation(newImage, 0.0);
    _imgData = imgData;
    UIImage *pressImage = [UIImage imageWithData:imgData];
    self.image = pressImage;
    if (self.takeSuccessBlock) {
        self.takeSuccessBlock(self.imgData);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[self viewController] dismissViewControllerAnimated:YES
                                              completion:^{}];
}


@end
