//
//  SettingsView.h
//  bubble2
//
//  Created by Brian Clouser on 4/24/16.
//  Copyright © 2016 Clouser. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewDelegate <NSObject>

-(void)undoLastBubbleTapped;
-(void)clearAllBubblesTapped;

@end

@interface SettingsView : UIView

@property (weak, nonatomic) IBOutlet UILabel *totalBubblesLabel;
@property (weak, nonatomic) id <SettingsViewDelegate> delegate;

@end
