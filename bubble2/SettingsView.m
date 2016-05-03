//
//  SettingsView.m
//  bubble2
//
//  Created by Brian Clouser on 4/24/16.
//  Copyright © 2016 Clouser. All rights reserved.
//

#import "SettingsView.h"

@interface SettingsView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;



@end

@implementation SettingsView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}


-(void)commonInit
{
    
    [[NSBundle mainBundle] loadNibNamed:@"Settings" owner:self options:nil];
    
    [self addSubview:self.contentView];
    
    self.contentView.frame = self.bounds;
    
    
}

- (IBAction)undoButtonTapped:(id)sender
{
    
    [self.delegate undoLastBubbleTapped];
    
}
- (IBAction)clearAllButtonTapped:(id)sender
{
    [self.delegate clearAllBubblesTapped];
}


@end
