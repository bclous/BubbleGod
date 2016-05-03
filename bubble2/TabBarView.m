//
//  tabBarView.m
//  bubble2
//
//  Created by Brian Clouser on 4/14/16.
//  Copyright © 2016 Clouser. All rights reserved.
//

#import "TabBarView.h"

@interface TabBarView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;


@end

@implementation TabBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
        
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

-(void)commonInit
{
    
    [[NSBundle mainBundle] loadNibNamed:@"TabBar" owner:self options:nil];
    
    [self addSubview:self.contentView];
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.contentView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    
   
    
   
}

- (IBAction)leftLeftTapped:(id)sender
{
    
    [self.delegate tabBarButtonTapped:1];
    
}
- (IBAction)middleLeftTapped:(id)sender
{
    
    [self.delegate tabBarButtonTapped:2];

}
- (IBAction)middleRightTapped:(id)sender
{
    
    [self.delegate tabBarButtonTapped:3];
    
}
- (IBAction)rightRightTapped:(id)sender
{
    
    [self.delegate tabBarButtonTapped:4];
    
}



@end
