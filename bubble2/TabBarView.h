//
//  tabBarView.h
//  bubble2
//
//  Created by Brian Clouser on 4/14/16.
//  Copyright © 2016 Clouser. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabBarDelegate <NSObject>

-(void)tabBarButtonTapped:(NSUInteger)index;

@end

@interface TabBarView : UIView

@property (weak, nonatomic) id <TabBarDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *viewMiddleRight;
@property (weak, nonatomic) IBOutlet UIView *viewRightRight;
@property (weak, nonatomic) IBOutlet UIView *viewMiddleLeft;
@property (weak, nonatomic) IBOutlet UIView *viewLeftLeft;

@end
