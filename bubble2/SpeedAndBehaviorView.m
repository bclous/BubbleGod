//
//  SpeedAndBehavior.m
//  bubble2
//
//  Created by Brian Clouser on 4/23/16.
//  Copyright © 2016 Clouser. All rights reserved.
//

#import "SpeedAndBehaviorView.h"

@interface SpeedAndBehaviorView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UISlider *speedSlider;
@property (weak, nonatomic) IBOutlet UILabel *speedValueLabel;
@property (weak, nonatomic) IBOutlet UIView *circle1;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIView *circle2;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIView *circle3;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIView *circle4;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIView *circle5;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UIView *circle6;
@property (weak, nonatomic) IBOutlet UIImageView *image6;

@end

@implementation SpeedAndBehaviorView

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
    
    [[NSBundle mainBundle] loadNibNamed:@"SpeedAndBehavior" owner:self options:nil];
    
    [self addSubview:self.contentView];
    
    self.contentView.frame = self.bounds;
    
    [self setCircles];
    
    self.speedValueLabel.text = [NSString stringWithFormat:@"%d",(int)roundf(self.speedSlider.value)];
    
}

-(void)setCircles
{
    self.circle1.layer.cornerRadius = 50;
    self.circle2.layer.cornerRadius = 50;
    self.circle3.layer.cornerRadius = 50;
    self.circle4.layer.cornerRadius = 50;
    self.circle5.layer.cornerRadius = 50;
    self.circle6.layer.cornerRadius = 50;
    
    self.circle1.layer.borderWidth = 3;
    self.circle2.layer.borderWidth = 3;
    self.circle3.layer.borderWidth = 3;
    self.circle4.layer.borderWidth = 3;
    self.circle5.layer.borderWidth = 3;
    self.circle6.layer.borderWidth = 3;
   
    self.circle1.layer.borderColor = [[UIColor grayColor] CGColor];
    self.circle2.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.circle3.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.circle4.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.circle5.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.circle6.layer.borderColor = [[UIColor whiteColor] CGColor];
    
}

-(void)resetCircles
{
    self.circle1.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.circle2.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.circle3.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.circle4.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.circle5.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.circle6.layer.borderColor = [[UIColor whiteColor] CGColor];
    
}

-(void)circleChosen:(UIView *)circleView
{
    
    circleView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    
}
- (IBAction)sliderMoved:(id)sender
{
    
    self.speedValueLabel.text = [NSString stringWithFormat:@"%d",(int)roundf(self.speedSlider.value)];
    
    [self.delegate speedChosen:(int)roundf(self.speedSlider.value)];
    
}

- (IBAction)circle1Tapped:(id)sender
{
    
    [self resetCircles];
    [self circleChosen:self.circle1];
    
    [self.delegate behaviorChosen:1];
    
    
}
- (IBAction)circle2Tapped:(id)sender
{
    [self resetCircles];
    [self circleChosen:self.circle2];
    
    [self.delegate behaviorChosen:2];
    
}
- (IBAction)circle3Tapped:(id)sender
{
    [self resetCircles];
    [self circleChosen:self.circle3];
    
    [self.delegate behaviorChosen:3];
    
}
- (IBAction)circle4Tapped:(id)sender
{
    [self resetCircles];
    [self circleChosen:self.circle4];
    
    [self.delegate behaviorChosen:4];
    
}
- (IBAction)circle5Tapped:(id)sender
{
    [self resetCircles];
    [self circleChosen:self.circle5];
    
    [self.delegate behaviorChosen:5];
    
}
- (IBAction)circle6Tapped:(id)sender
{
    [self resetCircles];
    [self circleChosen:self.circle6];
    
    [self.delegate behaviorChosen:6];
    
}


@end
