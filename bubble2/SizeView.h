//
//  SizeView.h
//  bubble2
//
//  Created by Brian Clouser on 4/19/16.
//  Copyright © 2016 Clouser. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SizeViewDelegate <NSObject>

-(void)sizeChosen:(CGFloat)diameter;
-(void)bubbleColorChosenWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

@end

@interface SizeView : UIView

@property (weak, nonatomic) id <SizeViewDelegate> delegate; 


@end
