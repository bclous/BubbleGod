//
//  SpeedAndBehavior.h
//  bubble2
//
//  Created by Brian Clouser on 4/23/16.
//  Copyright © 2016 Clouser. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SpeedAndBehaviorDelegate <NSObject>

-(void)behaviorChosen:(NSInteger)behaviorIndex;
-(void)speedChosen:(NSInteger)speed;

@end

@interface SpeedAndBehaviorView : UIView

@property (weak, nonatomic) id <SpeedAndBehaviorDelegate> delegate;

@end
