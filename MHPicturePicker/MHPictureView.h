//
//  MHPictureView.h
//  MHPicturePicker
//
//  Created by Macro on 11/20/15.
//  Copyright © 2015 Macro. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void (^deletePictureBlock)(void);


@interface MHPictureView : UIImageView

@property (nonatomic, assign) void (^deletePictureBlock)(void);

@end
