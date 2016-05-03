//
//  Bubble.h
//  bubble2
//
//  Created by Brian Clouser on 4/23/16.
//  Copyright © 2016 Clouser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Bubble : UIView

@property (strong, nonatomic) UIColor *color;
@property (nonatomic) CGFloat diameter;
@property (nonatomic) NSInteger behaviorIndex;
@property (nonatomic) CGFloat speed;
@property (nonatomic) CGFloat startingX;
@property (nonatomic) CGFloat startingY;
@property (nonatomic) CGFloat currentX;
@property (nonatomic) CGFloat currentY;
@property (nonatomic) BOOL movingUpOrRight;
@property (nonatomic) BOOL savedMovingUpOrRight;

@end
