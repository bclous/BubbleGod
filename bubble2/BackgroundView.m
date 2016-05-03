//
//  BackgroundView.m
//  bubble2
//
//  Created by Brian Clouser on 4/24/16.
//  Copyright © 2016 Clouser. All rights reserved.
//

#import "BackgroundView.h"

@interface BackgroundView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UILabel *redSliderValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenSliderValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueSliderValueLabel;
@property (weak, nonatomic) IBOutlet UIView *colorButtonView;
@property (weak, nonatomic) IBOutlet UIView *imageButtonView;

@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UILabel *rLabel;
@property (weak, nonatomic) IBOutlet UIView *imageBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *gLabel;
@property (weak, nonatomic) IBOutlet UILabel *bLabel;

@property (nonatomic) CGFloat redValue;
@property (nonatomic) CGFloat greenValue;
@property (nonatomic) CGFloat blueValue;


@property (nonatomic) BOOL colorViewChosen;


@end

@implementation BackgroundView

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
    
    [[NSBundle mainBundle] loadNibNamed:@"Background" owner:self options:nil];
    
    [self addSubview:self.contentView];
    
    self.contentView.frame = self.bounds;
    
    self.colorButtonView.layer.cornerRadius = 15;
    self.imageButtonView.layer.cornerRadius = 15;
    
    [self resetButtons];
    
    [self viewChosen:self.colorButtonView];
    
    self.colorViewChosen = YES;
    
    self.addImageView.userInteractionEnabled = NO;
    self.imageView.userInteractionEnabled = NO;
    
    self.redSlider.userInteractionEnabled = YES;
    self.greenSlider.userInteractionEnabled = YES;
    self.blueSlider.userInteractionEnabled = YES;
    
}
- (IBAction)colorButtonTapped:(id)sender
{
    [self resetButtons];
    
    [self viewChosen:self.colorButtonView];
    
    if (!self.colorViewChosen)
    {
        self.colorViewChosen = YES;
    }
    
    [self.delegate colorBackgroundButtonTapped];
    
    self.addImageView.userInteractionEnabled = NO;
    self.imageView.userInteractionEnabled = NO;
    
    self.redSlider.userInteractionEnabled = YES;
    self.greenSlider.userInteractionEnabled = YES;
    self.blueSlider.userInteractionEnabled = YES;
    
    
}
- (IBAction)imageButtonTapped:(id)sender
{
    [self resetButtons];
    
    [self viewChosen:self.imageButtonView];
    
    if (self.colorViewChosen)
    {
        self.colorViewChosen = NO;
    }
    
    self.addImageView.userInteractionEnabled = YES;
    self.imageView.userInteractionEnabled = YES;
    
    self.redSlider.userInteractionEnabled = NO;
    self.greenSlider.userInteractionEnabled = NO;
    self.blueSlider.userInteractionEnabled = NO;
    
    
    [self.delegate imageBackgroundButtonTapped];
    
    
    
}

-(void)resetButtons
{
    
    self.colorButtonView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
    self.imageButtonView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
    
    self.colorButtonView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.colorButtonView.layer.borderWidth = 2;
    
    self.imageButtonView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageButtonView.layer.borderWidth = 2;
    
}

-(void)viewChosen:(UIView *)chosenView
{
    
    chosenView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    
    chosenView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    
    if ([chosenView isEqual:self.imageButtonView])
    {
        self.redSlider.alpha = .1;
        self.greenSlider.alpha = .1;
        self.blueSlider.alpha = .1;
        
        self.redSliderValueLabel.alpha = .1;
        self.greenSliderValueLabel.alpha = .1;
        self.blueSliderValueLabel.alpha = .1;
        
        self.rLabel.alpha = .1;
        self.gLabel.alpha = .1;
        self.bLabel.alpha = .1;
        
        self.imageView.alpha = 1;
        self.addImageView.alpha = .2;
        self.imageBackgroundView.alpha = 1;
        
    }
    
    else
    {
        
        self.imageView.alpha = .1;
        self.addImageView.alpha = .1;
        self.imageBackgroundView.alpha = .1;
        
        self.redSlider.alpha = 1;
        self.greenSlider.alpha = 1;
        self.blueSlider.alpha = 1;
        
        self.redSliderValueLabel.alpha = 1;
        self.greenSliderValueLabel.alpha = 1;
        self.blueSliderValueLabel.alpha = 1;
        
        self.rLabel.alpha = 1;
        self.gLabel.alpha = 1;
        self.bLabel.alpha = 1;
    }
    
  
}
- (IBAction)redSliderMoved:(id)sender
{
    
    [self colorChanged];
    
}
- (IBAction)greenSliderMoved:(id)sender
{
    
    [self colorChanged];
    
}
- (IBAction)blueSliderMoved:(id)sender
{
    
    [self colorChanged];
    
}

-(void)colorChanged
{
    self.redValue = self.redSlider.value;
    self.greenValue = self.greenSlider.value;
    self.blueValue = self.blueSlider.value;
    
    self.redSliderValueLabel.text = [NSString stringWithFormat:@"%d",(int)roundf(self.redValue)];
    self.greenSliderValueLabel.text = [NSString stringWithFormat:@"%d",(int)roundf(self.greenValue)];
    self.blueSliderValueLabel.text = [NSString stringWithFormat:@"%d",(int)roundf(self.blueValue)];
    
    [self.delegate colorChosenWithRed:self.redValue green:self.greenValue blue:self.blueValue];
}
- (IBAction)addImageTapped:(id)sender
{
    
    [self.delegate addImageButtonTapped];
    
}
- (IBAction)otherAddImageTaped:(id)sender
{
    
    [self.delegate addImageButtonTapped];
    
}

@end
