//
//  MHPictureView.h
//  MHPicturePicker
//
//  Created by Macro on 11/20/15.
//  Copyright © 2015 Macro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PictureBlock)(NSData *);


@interface MHPictureView : UIImageView

@property (nonatomic, strong) PictureBlock takeSuccessBlock;
@property (nonatomic, strong) PictureBlock deletePictureBlock;


@property (nonatomic, strong, readonly) NSData *imgData;
@property (nonatomic, assign) BOOL canDelete;


- (void)setImageWithData:(NSData *)imageData;

@end
