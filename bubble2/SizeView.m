//
//  SizeView.m
//  bubble2
//
//  Created by Brian Clouser on 4/19/16.
//  Copyright © 2016 Clouser. All rights reserved.
//

#import "SizeView.h"

@interface SizeView ()


@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *bubbleView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bubbleWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bubbleHeightContstraint;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;
@property (weak, nonatomic) IBOutlet UILabel *redValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueValueLabel;

@property (nonatomic) CGFloat bubbleDiameter;

@property (nonatomic) CGFloat redValue;
@property (nonatomic) CGFloat greenValue;
@property (nonatomic) CGFloat blueValue;

@property (nonatomic) CGFloat alphaValue;


@end

@implementation SizeView

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
    
    [[NSBundle mainBundle] loadNibNamed:@"SizeAndColor" owner:self options:nil];
    
    [self addSubview:self.contentView];
    
    self.contentView.frame = self.bounds;
    
    NSUInteger truncatedValue =  roundf(self.slider.value);

    self.bubbleHeightContstraint.active = NO;
    self.bubbleWidthConstraint.active = NO;
    
    self.bubbleHeightContstraint = [self.bubbleView.heightAnchor constraintEqualToConstant:truncatedValue];
    self.bubbleWidthConstraint = [self.bubbleView.widthAnchor constraintEqualToConstant:truncatedValue];
    
    self.bubbleHeightContstraint.active = YES;
    self.bubbleWidthConstraint.active = YES;
    
    self.bubbleView.layer.cornerRadius = truncatedValue / 2;
    
    self.redValue = self.redSlider.value;
    self.greenValue = self.greenSlider.value;
    self.blueValue = self.blueSlider.value;
    
    self.alphaValue = self.alphaSlider.value;
    
    [self setColor];
    
    
}

- (IBAction)sliderMoved:(id)sender
{
    
    self.bubbleDiameter = self.slider.value;
    
    self.bubbleHeightContstraint.active = NO;
    self.bubbleWidthConstraint.active = NO;
    
    self.bubbleHeightContstraint = [self.bubbleView.heightAnchor constraintEqualToConstant:self.bubbleDiameter];
    self.bubbleWidthConstraint = [self.bubbleView.widthAnchor constraintEqualToConstant:self.bubbleDiameter];
    
    self.bubbleHeightContstraint.active = YES;
    self.bubbleWidthConstraint.active = YES;
    
    self.bubbleView.layer.cornerRadius = self.bubbleDiameter / 2;
    
    [self.delegate sizeChosen:self.bubbleDiameter];
    
    [self layoutIfNeeded];
    
}

- (IBAction)redSliderMoved:(id)sender
{
    self.redValue = self.redSlider.value;
   
    [self setColor];
    
}
- (IBAction)greenSliderMoved:(id)sender
{
    self.greenValue = self.greenSlider.value;
 
    [self setColor];
}

- (IBAction)blueSliderMoved:(id)sender
{
    self.blueValue = self.blueSlider.value;
    
    [self setColor];
}
- (IBAction)alphaSliderMoved:(id)sender
{
    self.alphaValue = self.alphaSlider.value;
    [self setColor];
}

-(void)setColor
{
    self.bubbleView.backgroundColor = [UIColor colorWithRed:self.redValue/255.0 green:self.greenValue/255.0 blue:self.blueValue/255.0 alpha:self.alphaValue];
    
    self.redValueLabel.text = [NSString stringWithFormat:@"%d",(int)roundf(self.redValue)];
    self.greenValueLabel.text = [NSString stringWithFormat:@"%d",(int)roundf(self.greenValue)];
    self.blueValueLabel.text = [NSString stringWithFormat:@"%d",(int)roundf(self.blueValue)];
    
    [self.delegate bubbleColorChosenWithRed:self.redValue green:self.greenValue blue:self.blueValue alpha:self.alphaValue];
}


@end
