//
//  KPictureView.h
//  MHPicturePicker
//
//  Created by Macro on 11/27/15.
//  Copyright © 2015 Macro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KPictureView : UIView

@property (nonatomic, strong)  NSMutableArray < NSData *> *imageDataArray;


- (instancetype)initWithFrame:(CGRect)frame
                 contentArray:(NSArray <NSString *> *)arr;

@end
