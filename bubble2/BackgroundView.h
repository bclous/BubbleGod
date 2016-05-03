//
//  BackgroundView.h
//  bubble2
//
//  Created by Brian Clouser on 4/24/16.
//  Copyright © 2016 Clouser. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackgroundDelegate <NSObject>

-(void)imageBackgroundButtonTapped;
-(void)colorBackgroundButtonTapped;
-(void)colorChosenWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
-(void)addImageButtonTapped;

@end

@interface BackgroundView : UIView

@property (weak, nonatomic) id <BackgroundDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
