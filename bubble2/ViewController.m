//
//  ViewController.m
//  bubble2
//
//  Created by Brian Clouser on 4/13/16.
//  Copyright © 2016 Clouser. All rights reserved.
//

#import "ViewController.h"
#import "TabBarView.h"
#import "SizeView.h"
#import "SpeedAndBehaviorView.h"
#import "BackgroundView.h"
#import "SettingsView.h"
#import "Bubble.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController () <TabBarDelegate, SizeViewDelegate, BackgroundDelegate, SpeedAndBehaviorDelegate, UIGestureRecognizerDelegate, SettingsViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tapScreenLabel;
@property (weak, nonatomic) IBOutlet UILabel *tapCircleLabel;

@property (strong, nonatomic) TabBarView *tabBar;

@property (strong, nonatomic) BackgroundView *backgroundView;
@property (strong, nonatomic) SizeView *sizeView;
@property (strong, nonatomic) SpeedAndBehaviorView *speedView;
@property (strong, nonatomic) SettingsView *settingsView;


@property (strong, nonatomic) UIView *mainCircleView;

@property (strong, nonatomic) UIButton *mainCircleButton;

@property (strong, nonatomic) NSLayoutConstraint *tabBarWidth;

@property (strong, nonatomic) NSLayoutConstraint *mainCircleHeight;
@property (strong, nonatomic) NSLayoutConstraint *mainCircleWidth;

@property (strong, nonatomic) NSLayoutConstraint *sizeBottomConstraint;
@property (strong, nonatomic) NSLayoutConstraint *speedBottomConstraint;
@property (strong, nonatomic) NSLayoutConstraint *backgroundBottomConstraint;
@property (strong, nonatomic) NSLayoutConstraint *settingsBottomConstraint;

@property (strong, nonatomic) UIImageView *backgroundImageView;

@property (nonatomic) BOOL circleSmall;

@property (nonatomic) BOOL tabBarDisplayed;
@property (nonatomic) BOOL backgroundViewDisplayed;
@property (nonatomic) BOOL sizeViewDisplayed;
@property (nonatomic) BOOL speedViewDisplayed;
@property (nonatomic) BOOL settingsViewDisplayed;

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic) BOOL imagePickerCalled;

@property (strong, nonatomic) UIColor *bubbleColor;
@property (nonatomic) CGFloat bubbleDiameter;
@property (nonatomic) NSInteger animationSpeed;
@property (nonatomic) NSInteger behaviorIndex;

@property (nonatomic) BOOL shouldAnimate;
@property (nonatomic) BOOL isPaused;
@property (nonatomic) BOOL isPausedFromResignActive;
@property (nonatomic) BOOL appWasDismissed;

@property (strong, nonatomic) NSMutableArray *allBubbles;
@property (strong, nonatomic) NSMutableArray *recreatedBubbles;
@property (strong, nonatomic) NSMutableArray *recreatedBubblesWhilePaused;

@property (strong, nonatomic) UITapGestureRecognizer *mainTap;

@property (nonatomic) CGFloat animationConstant;

@property (strong, nonatomic) NSMutableArray *bubblesMadeWhilePaused;




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setUpMainView];
    
    [self createMainCircleButton];
    
    [self createTabBar];
    
    [self setUpBackgroundView];
    
    [self setUpSizeView];
    
    [self setUpSpeedView];
    
    [self setUpSettingsView];
    
    [self setUpBackgroundImageView];
    
    [self resetView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignActive) name:@"resignActiveCalled" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground) name:@"didEnterBackgroundCalled" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:@"willEnterForegroundCalled" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:@"didBecomeActiveCalled" object:nil];


}



-(void)resignActive
{
    
    NSLog(@"In resign active the beginning: \n\nself.isPaused is %d\nself.isPausedFromResignActive is %d\nself.shouldAnimate is %d\n", self.isPaused, self.isPausedFromResignActive, self.shouldAnimate);
    
    
    self.isPausedFromResignActive = YES;
    
    if (!self.isPaused)
    {
        [self pauseBubbles];
        
        self.isPaused = NO;
    }
    
     NSLog(@"In resign active at the end: \n\nself.isPaused is %d\nself.isPausedFromResignActive is %d\nself.shouldAnimate is %d", self.isPaused, self.isPausedFromResignActive, self.shouldAnimate);
    
    
}

-(void)didBecomeActive
{

    
    
    if (self.isPausedFromResignActive && !self.isPaused && !self.appWasDismissed)
    {
        [self resumeBubbles];
        
    }
    
    self.isPausedFromResignActive = NO;
    self.appWasDismissed = NO;

}

-(void)willEnterForeground
{
    [self recreateBubbleView];
}

-(void)didEnterBackground
{
    
    [self leaveBubbleView];
    
    self.appWasDismissed = YES;
    
}


-(void)viewWillAppear:(BOOL)animated
{

    [self recreateBubbleView];
    
}

-(void)viewWillDisappear:(BOOL)animated
{

  
    [self leaveBubbleView];
    
    
    
}


-(void)leaveBubbleView
{
    
    self.shouldAnimate = NO;
    
    for (Bubble *bubble in self.allBubbles)
    {
        
        [bubble removeFromSuperview];
        
    }

}

-(void)recreateBubbleView
{
    
    self.shouldAnimate = YES;
    
    for (Bubble *bubble in self.allBubbles)
    {
        
        [self recreateBubbleAtOriginX:bubble.currentX originY:bubble.currentY behavior:bubble.behaviorIndex diamater:bubble.diameter color:bubble.color speed:bubble.speed upOrRight:bubble.savedMovingUpOrRight currentX:bubble.currentX currentY:bubble.currentY];
    
        
    }
    
    [self.allBubbles removeAllObjects];
    
    
    for (Bubble *bubble in self.recreatedBubbles)
    {
        [self.allBubbles addObject:bubble];
    }
    
    [self.recreatedBubbles removeAllObjects];
    
}

-(void)setUpMainView
{
    self.mainTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainViewTap)];
    
    [self.view addGestureRecognizer:self.mainTap];
    
    self.mainTap.delegate = self;
    
    self.animationConstant = 4.0;
    
    self.animationSpeed = 50;
    
    self.bubbleDiameter = 75;
    
    self.bubbleColor = [UIColor colorWithRed:63.0/255.0 green:121.0/255.0 blue:211.0/255.0 alpha:.5];
    
    self.behaviorIndex = 1;
    
    self.allBubbles = [[NSMutableArray alloc] init];
    self.recreatedBubbles = [[NSMutableArray alloc] init];
    self.bubblesMadeWhilePaused = [[NSMutableArray alloc] init];
    self.recreatedBubblesWhilePaused = [[NSMutableArray alloc] init];
    
    self.shouldAnimate = YES;
    self.isPaused = NO;
    self.isPausedFromResignActive = NO;
    
}



-(void)mainViewTap
{
    
    CGPoint locationOfTap = [self.mainTap locationInView:self.view];
    
    CGFloat x = locationOfTap.x;
    CGFloat y = locationOfTap.y;
    
    CGFloat yMax = self.view.frame.size.height - 295;
    
    BOOL isOutsideSubMenus = y < yMax;
    
    BOOL subViewDisplayed = (self.backgroundViewDisplayed || self.speedViewDisplayed || self.settingsViewDisplayed || self.sizeViewDisplayed);
    
    NSLog(@"main view tapped");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (subViewDisplayed && isOutsideSubMenus)
        {
            [self circleTapped];
        }
        
        else if (!self.circleSmall && !subViewDisplayed )
        {
            [self circleTapped];
        }
        
        else if (self.circleSmall)
        {
            
            [self createBubbleAtOriginX:x originY:y];
            self.tapScreenLabel.alpha = 0;
        }

        
    });
    
    
}

-(void)resetView
{
    self.tabBarDisplayed = NO;
    
    self.settingsViewDisplayed = NO;
    self.backgroundViewDisplayed = NO;
    self.speedViewDisplayed = NO;
    self.sizeViewDisplayed = NO;
    
    [self bringTabBarToFront];

}


-(void)bringTabBarToFront
{
    [self.view bringSubviewToFront:self.backgroundView];
    [self.view bringSubviewToFront:self.sizeView];
    [self.view bringSubviewToFront:self.speedView];
    [self.view bringSubviewToFront:self.settingsView];
    [self.view bringSubviewToFront:self.tabBar];
    [self.view bringSubviewToFront:self.mainCircleView];

}






// create bubble


-(void)createBubbleAtOriginX:(CGFloat)originX originY:(CGFloat)originY
{
    
    CGFloat newOriginX = originX - (self.bubbleDiameter / 2.0);
    CGFloat newOriginY = originY - (self.bubbleDiameter / 2.0);
    
    
    Bubble *newBubble = [[Bubble alloc] initWithFrame:CGRectMake(newOriginX, newOriginY, self.bubbleDiameter, self.bubbleDiameter)];
    
    newBubble.layer.cornerRadius = self.bubbleDiameter / 2.0;
    newBubble.layer.masksToBounds = YES;
    newBubble.backgroundColor = self.bubbleColor;
    
    newBubble.color = self.bubbleColor;
    newBubble.diameter = self.bubbleDiameter;
    newBubble.startingX = newOriginX;
    newBubble.startingY = newOriginY;
    newBubble.speed = self.animationSpeed;
    newBubble.behaviorIndex = self.behaviorIndex;
    newBubble.movingUpOrRight = YES;
    newBubble.savedMovingUpOrRight = YES;
    newBubble.currentX = newOriginX;
    newBubble.currentY = newOriginY;
    
    newBubble.userInteractionEnabled = NO;
    
    [self.view addSubview:newBubble];
    
    [self.allBubbles addObject:newBubble];
    
    [self bringTabBarToFront];
    
    if (self.isPaused)
    {
        [self.bubblesMadeWhilePaused addObject:newBubble];
    }
    
    else
    {
        [self animateBubble:newBubble];
        
        
        for (Bubble *bubble in self.allBubbles)
        {
            if (!([bubble isEqual:newBubble]))
            
            bubble.currentX = [[bubble.layer presentationLayer] frame].origin.x;
            bubble.currentY = [[bubble.layer presentationLayer] frame].origin.y;
            bubble.savedMovingUpOrRight = bubble.movingUpOrRight;
            
        }
        
        
        newBubble.currentX = newOriginX;
        newBubble.currentY = newOriginY;
    }
    
    self.settingsView.totalBubblesLabel.text = [NSString stringWithFormat:@"Total Bubbles: %lu",self.allBubbles.count];
    
    

    

   
    
}

-(void)recreateBubbleAtOriginX:(CGFloat)originX originY:(CGFloat)originY behavior:(NSInteger)behavior diamater:(CGFloat)diameter color:(UIColor *)color speed:(CGFloat)speed upOrRight:(BOOL)upOrRight currentX:(CGFloat)currentX currentY:(CGFloat)currentY;
{
    NSLog(@"recreate x is: %f y is: %f", originX, originY);
  
    Bubble *newBubble = [[Bubble alloc] initWithFrame:CGRectMake(originX, originY, diameter, diameter)];
    
    newBubble.layer.cornerRadius = diameter / 2.0;
    newBubble.layer.masksToBounds = YES;
    newBubble.backgroundColor = color;
    newBubble.movingUpOrRight = upOrRight;
    newBubble.savedMovingUpOrRight = upOrRight;
    newBubble.currentX = currentX;
    newBubble.currentY = currentY;
    
    newBubble.color = color;
    newBubble.diameter = diameter;
    newBubble.startingX = originX;
    newBubble.startingY = originY;
    newBubble.speed = speed;
    newBubble.behaviorIndex = behavior;
    
    [self.view addSubview:newBubble];
    
    [self.recreatedBubbles addObject:newBubble];
    
    [self bringTabBarToFront];
    
    if (!self.isPaused)
    {
         [self animateBubble:newBubble];
    }
    else
    {
        [self.recreatedBubblesWhilePaused addObject:newBubble];
    }
    
   
    
    self.settingsView.totalBubblesLabel.text = [NSString stringWithFormat:@"Total Bubbles: %lu",self.allBubbles.count];
    
    
    
}

-(void)animateBubble:(Bubble *)bubble
{
    
  
    
        if (bubble.behaviorIndex == 1)
        {
            [self animateBubbleFromTopToBottom:bubble originX:bubble.currentX originY:bubble.currentY];
        }
        
        else if (bubble.behaviorIndex == 2)
        {
            [self animateBubbleFromLeftToRight:bubble originX:bubble.currentX originY:bubble.currentY];
        }
        
        else if (bubble.behaviorIndex == 3)
        {
            
            [self animateBubbleToRandomSpot:bubble originX:bubble.currentX originY:bubble.currentY];
        }
        
        else if (bubble.behaviorIndex == 4)
        {
            [self animateBubbleFromBottomRightToTopLeft:bubble originX:bubble.currentX originY:bubble.currentY];
        }
        else
        {
            [self animateBubbleFromBottomLeftToTopRight:bubble originX:bubble.currentX originY:bubble.currentY];
        }
        

    
    
    
}


-(void)animateBubbleFromLeftToRight:(Bubble *)bubble originX:(CGFloat)originX originY:(CGFloat)originY
{
    
    if (self.shouldAnimate &&!bubble.speed == 0)
    {
    
    
    CGFloat maxX = self.view.frame.size.width - bubble.diameter;
    
    
    
    if (originX == maxX)
    {
        
        CGFloat time = maxX / self.animationConstant / bubble.speed;
        
        [UIView animateWithDuration:time
                         animations:^{
                             
                             bubble.frame = CGRectMake(0, originY, (bubble.diameter), (bubble.diameter));
                             
                            
                             
                         } completion:^(BOOL finished) {
                             
                             [self animateBubbleFromLeftToRight:bubble originX:0 originY:originY];
                             
                             bubble.movingUpOrRight = YES;
                         }];
        
        
        
        
    }
    
    else if (originX == 0)
    {
        
        CGFloat time = maxX / self.animationConstant / bubble.speed;
        
        [UIView animateWithDuration:time
                         animations:^{
                             
                             bubble.frame = CGRectMake(maxX, originY, (bubble.diameter), (bubble.diameter));
                             
                         } completion:^(BOOL finished) {
                             
                             [self animateBubbleFromLeftToRight:bubble originX:maxX originY:originY];
                             
                             bubble.movingUpOrRight = NO;
                         }];
        
        
        
        
    }
    
    else if(bubble.movingUpOrRight)
    {
        
        
        CGFloat distance = maxX - originX;
        
        CGFloat time = distance / self.animationConstant / bubble.speed;
        
        [UIView animateWithDuration:time
                         animations:^{
                             
                             bubble.frame = CGRectMake(maxX, originY, (bubble.diameter), (bubble.diameter));
                             
                         } completion:^(BOOL finished) {
                             
                             [self animateBubbleFromLeftToRight:bubble originX:maxX originY:originY];
                             
                             bubble.movingUpOrRight = NO;
                         }];
        
    }
    else
    {
        
        CGFloat distance = originX;
        
        CGFloat time = distance / self.animationConstant / bubble.speed;
        
        [UIView animateWithDuration:time
                         animations:^{
                             
                             bubble.frame = CGRectMake(0, originY, (bubble.diameter), (bubble.diameter));
                             
                         } completion:^(BOOL finished) {
                             
                             [self animateBubbleFromLeftToRight:bubble originX:0 originY:originY];
                             
                             bubble.movingUpOrRight = YES;
                         }];
        
        
        
    }
    
    }
    
    
}

-(void)animateBubbleFromTopToBottom:(Bubble *)bubble originX:(CGFloat)originX originY:(CGFloat)originY
{
    
    if (self.shouldAnimate && !bubble.speed == 0)
    {
    
    CGFloat maxY = self.view.frame.size.height - bubble.diameter;
    
    
    
    if (originY == maxY)
    {
        
        CGFloat time = maxY / self.animationConstant / bubble.speed;
        
        [UIView animateWithDuration:time
                         animations:^{
                             
                             bubble.frame = CGRectMake(originX, 0, (bubble.diameter), (bubble.diameter));
                             
                             
                             
                         } completion:^(BOOL finished) {
                             
                             [self animateBubbleFromTopToBottom:bubble originX:originX originY:0];
                             
                             bubble.movingUpOrRight = NO;
                         }];
        
        
    }
    
    else if (originY == 0)
    {
        
        CGFloat time = maxY / self.animationConstant / bubble.speed;
        
        [UIView animateWithDuration:time
                         animations:^{
                             
                             bubble.frame = CGRectMake(originX, maxY, (bubble.diameter), (bubble.diameter));
                             
                         } completion:^(BOOL finished) {
                             
                             [self animateBubbleFromTopToBottom:bubble originX:originX originY:maxY];
                             
                             bubble.movingUpOrRight = YES;
                         }];
        
        
    
        
    }
    
    else if (bubble.movingUpOrRight)
    {
        
        
        CGFloat distance = originY;
        
        CGFloat time = distance / self.animationConstant / bubble.speed;
        
        [UIView animateWithDuration:time
                         animations:^{
                             
                             bubble.frame = CGRectMake(originX, 0, (bubble.diameter), (bubble.diameter));
                             
                         } completion:^(BOOL finished) {
                             
                             [self animateBubbleFromTopToBottom:bubble originX:originX originY:0];
                             
                             bubble.movingUpOrRight = NO;
                             
                         }];
        
    }
    
    else
    {
        
        
        CGFloat distance = maxY - originY;
        
        CGFloat time = distance / self.animationConstant / bubble.speed;
        
        [UIView animateWithDuration:time
                         animations:^{
                             
                             bubble.frame = CGRectMake(originX, maxY, (bubble.diameter), (bubble.diameter));
                             
                         } completion:^(BOOL finished) {
                             
                             [self animateBubbleFromTopToBottom:bubble originX:originX originY:maxY];
                             
                             bubble.movingUpOrRight = YES;
                             
                         }];
        
    }
        
    }
    
    
}

-(void)animateBubbleFromBottomLeftToTopRight:(Bubble*)bubble originX:(CGFloat)originX originY:(CGFloat)originY
{
    
    if (self.shouldAnimate && !bubble.speed == 0)
    {
        
    
    
    CGFloat maxY = self.view.frame.size.height - bubble.diameter;
    CGFloat maxX = self.view.frame.size.width - bubble.diameter;
    
    BOOL onTop = originX >= maxX || originY <= 0;
    //BOOL onBottom = originX <= 0 || originY >= maxY;
    
    CGFloat newX;
    CGFloat newY;
    CGFloat finalX;
    CGFloat finalY;
    
    
    if (onTop)
    {
        
        newY = originX + originY;
        
        if (newY > maxY)
        {
            finalX = originX - (maxY - originY);
            finalY = maxY;
        }
        else
        {
            finalX = 0;
            finalY = newY  ;
        }
    
    }
    
    else
    {
        newX = originX + originY;
        
        if (newX > maxX)
        {
            finalX = maxX;
            finalY = newX - maxX;
        }
        else
        {
            finalX = newX;
            finalY = 0;
        }
    }
    
    CGFloat linearDistance = fabs(finalX - originX);
    
    CGFloat distance = linearDistance * 1.41;
    
    CGFloat time = distance / self.animationConstant / bubble.speed;
    
    [UIView animateWithDuration:time
                     animations:^{
                         bubble.frame = CGRectMake(finalX, finalY, bubble.diameter, bubble.diameter);
                         
                     } completion:^(BOOL finished) {
                         
                         [self animateBubbleFromBottomLeftToTopRight:bubble originX:finalX originY:finalY];
                     }];

        
    }
    
}

-(void)animateBubbleFromBottomRightToTopLeft:(Bubble*)bubble originX:(CGFloat)originX originY:(CGFloat)originY
{
    
    if (self.shouldAnimate && !bubble.speed == 0)
    {
        
    
    
    CGFloat maxY = self.view.frame.size.height - bubble.diameter;
    CGFloat maxX = self.view.frame.size.width - bubble.diameter;
    
    BOOL onTop = originX <= 0 || originY <= 0;
    
    CGFloat newX;
    CGFloat newY;
    CGFloat finalX;
    CGFloat finalY;
    
    
    if (onTop)
    {
        
        newY = originY + (maxX - originX);
        
        if (newY > maxY)
        {
            finalX = originX + (maxY - originY);
            finalY = maxY;
        }
        else
        {
            finalX = maxX;
            finalY = newY  ;
        }
        
    }
    
    else
    {
        newX = originX - originY;
        
        if (newX < 0)
        {
            finalX = 0;
            finalY = originY - originX;
        }
        else
        {
            finalX = newX;
            finalY = 0;
        }
    }
    
    CGFloat linearDistance = fabs(finalX - originX);
    
    CGFloat distance = linearDistance * 1.41;
    
    CGFloat time = distance / self.animationConstant / bubble.speed;
    
    [UIView animateWithDuration:time
                     animations:^{
                         bubble.frame = CGRectMake(finalX, finalY, bubble.diameter, bubble.diameter);
                         
                     } completion:^(BOOL finished) {
                         
                         [self animateBubbleFromBottomRightToTopLeft:bubble originX:finalX originY:finalY];
                     }];
        
    }
    
    
}

-(void)animateBubbleToRandomSpot:(Bubble*)bubble originX:(CGFloat)originX originY:(CGFloat)originY
{
    
    if (self.shouldAnimate && !bubble.speed == 0)
    {
    
    CGFloat maxY = self.view.frame.size.height - bubble.diameter;
    CGFloat maxX = self.view.frame.size.width - bubble.diameter;
    
    CGFloat newY = arc4random_uniform(maxY);
    CGFloat newX = arc4random_uniform(maxX);
    
    CGFloat horizontalDistance = fabs(newX - originX);
    CGFloat verticalDistance = fabs(newY - originY);
    
    CGFloat distance = sqrt((horizontalDistance * horizontalDistance + verticalDistance *verticalDistance));
    
    CGFloat time = distance / self.animationConstant / bubble.speed;
    
    [UIView animateWithDuration:time
                     animations:^{
                         bubble.frame = CGRectMake(newX, newY, bubble.diameter, bubble.diameter);
                         
                     } completion:^(BOOL finished) {
                         
                         [self animateBubbleToRandomSpot:bubble originX:newX originY:newY];
                     }];
        
    }
}







-(CGFloat)maxXGivenDiameter:(CGFloat)diameter
{
    
    CGFloat width = self.view.frame.size.width;
    
    CGFloat max = width - diameter;
    
    return max;
    
}


-(CGFloat)maxYGivenDiamater:(CGFloat)diameter
{
    
    CGFloat height = self.view.frame.size.height;
    
    CGFloat max = height - diameter;
    
    return max;
    
}

-(void)pauseBubbles
{
    
    for (Bubble *bubble in self.allBubbles)
    {
        [self pauseLayer:bubble.layer];
        
            bubble.currentX = [[bubble.layer presentationLayer] frame].origin.x;
            bubble.currentY = [[bubble.layer presentationLayer] frame].origin.y;
            bubble.savedMovingUpOrRight = bubble.movingUpOrRight;
            

    }
    
    self.isPaused = YES;
    
}

-(void)resumeBubbles
{
    
    self.isPaused = NO;
    
    for (Bubble *bubble in self.allBubbles)
    {
        [self resumeLayer:bubble.layer];
        
    }
    
    for (Bubble *bubble in self.bubblesMadeWhilePaused)
    {
        [self animateBubble:bubble];
    }
    
    for (Bubble *bubble in self.recreatedBubblesWhilePaused)
    {
        [self animateBubble:bubble];
    }
    
    [self.bubblesMadeWhilePaused removeAllObjects];
    [self.recreatedBubblesWhilePaused removeAllObjects];
    
}


-(void)pauseLayer:(CALayer*)layer
{

    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
    
}













//  ALL TAB BAR STUFF

-(void)createMainCircleButton
{
    
    
    self.mainCircleView = [[UIView alloc] init];
    
    [self.view addSubview:self.mainCircleView];
    
    self.mainCircleView.userInteractionEnabled = YES;
    
    self.mainCircleView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [self.mainCircleView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    
    [self.mainCircleView.centerYAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-27].active = YES;
    
    self.mainCircleHeight = [self.mainCircleView.heightAnchor constraintEqualToConstant:30];
    
    self.mainCircleWidth = [self.mainCircleView.widthAnchor constraintEqualToConstant:30];
    
    self.mainCircleHeight.active = YES;
    self.mainCircleWidth.active = YES;
    
    self.mainCircleView.backgroundColor = [UIColor whiteColor];
    self.mainCircleView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.mainCircleView.layer.borderWidth = 1;
    
    self.mainCircleView.layer.cornerRadius = 15;
    
    UITapGestureRecognizer *circleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(circleTapped)];
    circleTap.numberOfTapsRequired = 1;
    
    [self.mainCircleView addGestureRecognizer:circleTap];
    
    self.circleSmall = YES;
    
}

-(void)createTabBar
{
    
    self.tabBar = [[TabBarView alloc] init];
    
    [self.view addSubview:self.tabBar];
    
    self.tabBar.backgroundColor = [UIColor clearColor];
    
    self.tabBar.delegate = self;
    
    self.tabBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.tabBar.heightAnchor constraintEqualToConstant:52].active = YES;
    [self.tabBar.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.tabBar.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    
    self.tabBarWidth = [self.tabBar.widthAnchor constraintEqualToConstant:0];
    self.tabBarWidth.active = YES;
    self.tabBar.layer.borderWidth = 1;
    self.tabBar.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    [self.view bringSubviewToFront:self.mainCircleView];
    
}

-(void)growMainCircle
{
    
    //self.mainCircleView.layer.cornerRadius = 27;
    
    self.mainCircleHeight.active = NO;
    self.mainCircleWidth.active = NO;
    
    self.mainCircleHeight = [self.mainCircleView.heightAnchor constraintEqualToConstant:60];
    self.mainCircleWidth = [self.mainCircleView.widthAnchor constraintEqualToConstant:60];
    
    self.mainCircleHeight.active = YES;
    self.mainCircleWidth.active = YES;
    
    //self.mainCircleButton.alpha = 1;
    
}

-(void)shrinkMainCircle
{
    
    self.mainCircleView.layer.cornerRadius = 15;
    
    self.mainCircleHeight.active = NO;
    self.mainCircleWidth.active = NO;
    
    self.mainCircleHeight = [self.mainCircleView.heightAnchor constraintEqualToConstant:30];
    self.mainCircleWidth = [self.mainCircleView.widthAnchor constraintEqualToConstant:30];
    
    self.mainCircleHeight.active = YES;
    self.mainCircleWidth.active = YES;
    
    
}

-(void)extendTabBar
{
    
    self.tabBarWidth.active = NO;
    self.tabBarWidth = [self.tabBar.widthAnchor constraintEqualToAnchor:self.view.widthAnchor constant:2];
    self.tabBarWidth.active = YES;
    
    [self.view bringSubviewToFront:self.mainCircleButton];
    
    self.tabBar.layer.cornerRadius = 0;
    
}

-(void)shrinkTabBar
{
    
    self.tabBar.layer.cornerRadius = 27;
    
    self.tabBarWidth.active = NO;
    self.tabBarWidth = [self.tabBar.widthAnchor constraintEqualToConstant:0];
    self.tabBarWidth.active = YES;
    
    [self resetView];
    
}


-(void)circleTapped
{
    
    self.tapCircleLabel.alpha = 0;
    
    if (self.circleSmall)
    {
        
        [self mainCircleTappedWhileSmall];
    }
    
    
    else if (self.backgroundViewDisplayed || self.sizeViewDisplayed || self.speedViewDisplayed || self.settingsViewDisplayed)
    {
        
        [self mainCircleTappedWithViewDisplayed];
        
    }
    
    
    else
    {
        
        [self mainCircleTappedWhileBigAndNothingDisplayed];
        
    }
    
}


-(void)tabBarButtonTapped:(NSUInteger)index
{
    NSLog(@"tab bar tapped with index: %lu", index);
    
    
    if (index == 1)
    {
        [self colorViewTapped];
        
    }
    
    else if (index == 2)
    {
        [self sizeViewTapped];
    }
    
    else if (index == 3)
    {
        [self speedViewTapped];
    }
    
    else if (index == 4)
    {
        [self behaviorViewTapped];
    }
    
    
}

-(void)setUpBackgroundImageView
{
    
    self.backgroundImageView = [[UIImageView alloc] init];
    
    [self.view addSubview:self.backgroundImageView];
    
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.backgroundImageView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.backgroundImageView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.backgroundImageView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.backgroundImageView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    
    self.backgroundImageView.backgroundColor = [UIColor blackColor];
    
    self.backgroundImageView.alpha = 0;
    
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.imagePickerCalled = NO;
    
    
}

-(void)setUpBackgroundView
{
    
    self.backgroundView = [[BackgroundView alloc] init];
    
    self.backgroundView.delegate = self;
    
    [self.view addSubview:self.backgroundView];
    
    
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.backgroundView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:-1].active = YES;
    [self.backgroundView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:1].active = YES;
    [self.backgroundView.heightAnchor constraintEqualToConstant:230].active = YES;
    
    
    self.backgroundBottomConstraint = [self.backgroundView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:230];
    
    self.backgroundBottomConstraint.active = YES;
    
    self.backgroundView.layer.borderWidth = 1;
    self.backgroundView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.backgroundViewDisplayed = NO;
    
    
}

-(void)setUpSizeView
{
    self.sizeView = [[SizeView alloc] init];
    
    self.sizeView.delegate = self;
    
    [self.view addSubview:self.sizeView];
    
    self.sizeView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.sizeView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:-1].active = YES;
    [self.sizeView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:1].active = YES;
    [self.sizeView.heightAnchor constraintEqualToConstant:230].active = YES;
    self.sizeBottomConstraint = [self.sizeView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:230];
    
    self.sizeBottomConstraint.active = YES;
    
    self.sizeView.layer.borderWidth = 1;
    self.sizeView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    
    
    self.sizeViewDisplayed = NO;
    
}

-(void)setUpSpeedView
{
    self.speedView = [[SpeedAndBehaviorView alloc] init];
    
    self.speedView.delegate = self;
    
    [self.view addSubview:self.speedView];
    
    self.speedView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.speedView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:-1].active = YES;
    [self.speedView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:1].active = YES;
    [self.speedView.heightAnchor constraintEqualToConstant:230].active = YES;
    
    self.speedBottomConstraint = [self.speedView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:230];
    
    self.speedBottomConstraint.active = YES;
    
    self.speedView.layer.borderWidth = 1;
    self.speedView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.speedViewDisplayed = NO;
    
}

-(void)setUpSettingsView
{
    
    
    
    
    self.settingsView = [[SettingsView alloc] init];
    
    self.settingsView.delegate = self;
    
    self.settingsView.totalBubblesLabel.text = [NSString stringWithFormat:@"Total Bubbles: %lu",self.allBubbles.count];
    
    [self.view addSubview:self.settingsView];
    
    self.settingsView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.settingsView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:-1].active = YES;
    [self.settingsView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:1].active = YES;
    [self.settingsView.heightAnchor constraintEqualToConstant:230].active = YES;
    
    self.settingsBottomConstraint = [self.settingsView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:230];
    
    self.settingsBottomConstraint.active = YES;
    
    
    self.settingsView.layer.borderWidth = 1;
    self.settingsView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    
    self.settingsViewDisplayed = NO;
    
    
    
}

-(void)disableAllControl
{
    self.mainCircleButton.userInteractionEnabled = NO;
    self.tabBar.userInteractionEnabled = NO;
    self.backgroundView.userInteractionEnabled = NO;
    
    // other three views
}

-(void)enableAllControl
{
    self.mainCircleButton.userInteractionEnabled = YES;
    self.tabBar.userInteractionEnabled = YES;
    self.backgroundView.userInteractionEnabled = YES;
    
    // other three views
}

-(void)extendBackgroundView
{
    
    self.tabBar.viewLeftLeft.backgroundColor = [UIColor whiteColor];
    
    self.backgroundBottomConstraint.active = NO;
    
    self.backgroundBottomConstraint = [self.backgroundView.bottomAnchor constraintEqualToAnchor:self.tabBar.topAnchor constant:1];
    
    self.backgroundBottomConstraint.active = YES;
    
    self.backgroundViewDisplayed = YES;
}

-(void)shrinkBackgroundView
{
    self.backgroundBottomConstraint.active = NO;
    
    self.backgroundBottomConstraint = [self.backgroundView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:230];
    
    self.backgroundBottomConstraint.active = YES;
    
    self.backgroundViewDisplayed = NO;
    
}

-(void)extendSizeView
{
    self.tabBar.viewMiddleLeft.backgroundColor = [UIColor whiteColor];
    
    self.sizeBottomConstraint.active = NO;
    
    self.sizeBottomConstraint = [self.sizeView.bottomAnchor constraintEqualToAnchor:self.tabBar.topAnchor constant:1];
    
    self.sizeBottomConstraint.active = YES;
    
    self.sizeViewDisplayed = YES;
}

-(void)shrinkSizeView
{
    
    
    self.tabBar.viewMiddleLeft.backgroundColor = [UIColor whiteColor];
    
    self.sizeBottomConstraint.active = NO;
    
    self.sizeBottomConstraint = [self.sizeView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:230];
    
    self.sizeBottomConstraint.active = YES;
    
    self.sizeViewDisplayed = NO;
    
}

-(void)extendSpeedView
{
    self.tabBar.viewMiddleRight.backgroundColor = [UIColor whiteColor];
    
    self.speedBottomConstraint.active = NO;
    
    self.speedBottomConstraint = [self.speedView.bottomAnchor constraintEqualToAnchor:self.tabBar.topAnchor constant:1];
    
    self.speedBottomConstraint.active = YES;
    
    self.speedViewDisplayed = YES;
}

-(void)shrinkSpeedView
{
    self.speedBottomConstraint.active = NO;
    
    self.speedBottomConstraint = [self.speedView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:230];
    
    self.speedBottomConstraint.active = YES;
    
    self.speedViewDisplayed = NO;
    
}

-(void)extendSettingsView
{
    
    self.tabBar.viewRightRight.backgroundColor = [UIColor whiteColor];
    
    
    self.settingsBottomConstraint.active = NO;
    
    self.settingsBottomConstraint = self.settingsBottomConstraint = [self.settingsView.bottomAnchor constraintEqualToAnchor:self.tabBar.topAnchor constant:1];
    
    self.settingsBottomConstraint.active = YES;
    
    self.settingsViewDisplayed = YES;
    
    
}

-(void)shrinkBehaviorView
{
    
    self.settingsBottomConstraint.active = NO;
    
    self.settingsBottomConstraint = self.settingsBottomConstraint = [self.settingsView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:230];
    
    self.settingsBottomConstraint.active = YES;
    
}

-(void)resetTabBarIfOtherViewDisplayed
{
    
    
    if (self.settingsViewDisplayed)
    {
        [self shrinkBehaviorView];
        self.settingsViewDisplayed = NO;
    }
    else if (self.backgroundViewDisplayed)
    {
        [self shrinkBackgroundView];
        self.backgroundViewDisplayed = NO;
        
    }
    else if (self.sizeViewDisplayed)
    {
        
        [self shrinkSizeView];
        self.sizeViewDisplayed = NO;
    }
    else if (self.speedViewDisplayed)
    {
        [self shrinkSpeedView];
        self.speedViewDisplayed = NO;
    }
    
    self.tabBar.layer.borderWidth = 1;
    
    
}

-(void)viewsBackToGrayAnimate
{
    
    [UIView animateWithDuration:.05 animations:^{
        
        self.tabBar.viewLeftLeft.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
        self.tabBar.viewMiddleLeft.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
        self.tabBar.viewMiddleRight.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
        self.tabBar.viewRightRight.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    }];
    
    
    
}

-(void)viewsBackToGray
{
    self.tabBar.viewLeftLeft.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    self.tabBar.viewMiddleLeft.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    self.tabBar.viewMiddleRight.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    self.tabBar.viewRightRight.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
}



-(void)colorViewTapped
{
    [self disableAllControl];
    
    if (self.backgroundViewDisplayed)
    {
        [UIView animateWithDuration:.2 animations:^{
            
            
            [self resetTabBarIfOtherViewDisplayed];
            
            [self.view layoutIfNeeded];
            
            
        } completion:^(BOOL finished) {
            
            [self viewsBackToGray];
            
            self.backgroundViewDisplayed = NO;
            
            [self enableAllControl];
            
        }];
    }
    
    else if (self.sizeViewDisplayed || self.speedViewDisplayed || self.settingsViewDisplayed)
    {
        [self disableAllControl];
        
        [UIView animateWithDuration:.1 animations:^{
            
            [self resetTabBarIfOtherViewDisplayed];
            
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            [self viewsBackToGray];
            
            
            [UIView animateWithDuration:.2 animations:^{
                
                self.tabBar.layer.borderWidth = 0;
                
                [self extendBackgroundView];
                
                [self.view layoutIfNeeded];
                
                
            } completion:^(BOOL finished) {
                
                self.backgroundViewDisplayed = YES;
            }];
            
            
            [self enableAllControl];
            
            
        }];
        
    }
    
    else
    {
        
        [self disableAllControl];
        
        [UIView animateWithDuration:.2 animations:^{
            
            self.tabBar.layer.borderWidth = 0;
            
            [self extendBackgroundView];
            
            [self.view layoutIfNeeded];
            
            
        } completion:^(BOOL finished) {
            
            self.backgroundViewDisplayed = YES;
            
            [self enableAllControl];
        }];
        
    }
    
    
}

-(void)sizeViewTapped
{
    
    NSLog(@"sizeViewTapped");
    
    [self disableAllControl];
    
    if (self.sizeViewDisplayed)
    {
        
        NSLog(@"in the first if in size view");
        
        [UIView animateWithDuration:.2 animations:^{
            
            NSLog(@"in the animation");
            
            [self resetTabBarIfOtherViewDisplayed];
            
            [self.view layoutIfNeeded];
            
            
        } completion:^(BOOL finished) {
            
            [self viewsBackToGray];
            
            self.sizeViewDisplayed = NO;
            
            [self enableAllControl];
            
        }];
    }
    
    else if (self.backgroundViewDisplayed || self.speedViewDisplayed || self.settingsViewDisplayed)
    {
        
        
        [self disableAllControl];
        
        
        [UIView animateWithDuration:.1 animations:^{
            
            [self resetTabBarIfOtherViewDisplayed];
            
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            [self viewsBackToGray];
            
            
            [UIView animateWithDuration:.2 animations:^{
                
                self.tabBar.layer.borderWidth = 0;
                
                [self extendSizeView];
                
                [self.view layoutIfNeeded];
                
                
            } completion:^(BOOL finished) {
                
                self.sizeViewDisplayed = YES;
            }];
            
            
            [self enableAllControl];
            
            
        }];
        
    }
    
    else
    {
        
        NSLog(@"this is getting hit");
        
        [self disableAllControl];
        
        [UIView animateWithDuration:.2 animations:^{
            
            self.tabBar.layer.borderWidth = 0;
            
            [self extendSizeView];
            
            [self.view layoutIfNeeded];
            
            
        } completion:^(BOOL finished) {
            
            self.sizeViewDisplayed = YES;
            
            NSLog(@"self.sizeView is displayed is %d", self.sizeViewDisplayed);
            
            [self enableAllControl];
        }];
        
    }
    
    
    
    
}

-(void)speedViewTapped
{
    
    NSLog(@"speedViewTapped");
    
    [self disableAllControl];
    
    if (self.speedViewDisplayed)
    {
        
        NSLog(@"in the first if in size view");
        
        [UIView animateWithDuration:.2 animations:^{
            
            NSLog(@"in the animation");
            
            [self resetTabBarIfOtherViewDisplayed];
            
            [self.view layoutIfNeeded];
            
            
        } completion:^(BOOL finished) {
            
            [self viewsBackToGray];
            
            self.speedViewDisplayed = NO;
            
            [self enableAllControl];
            
        }];
    }
    
    else if (self.backgroundViewDisplayed || self.sizeViewDisplayed || self.settingsViewDisplayed)
    {
        
        
        [self disableAllControl];
        
        
        [UIView animateWithDuration:.1 animations:^{
            
            [self resetTabBarIfOtherViewDisplayed];
            
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            [self viewsBackToGray];
            
            
            [UIView animateWithDuration:.2 animations:^{
                
                self.tabBar.layer.borderWidth = 0;
                
                [self extendSpeedView];
                
                [self.view layoutIfNeeded];
                
                
            } completion:^(BOOL finished) {
                
                self.speedViewDisplayed = YES;
            }];
            
            
            [self enableAllControl];
            
            
        }];
        
    }
    
    else
    {
        
        NSLog(@"this is getting hit");
        
        [self disableAllControl];
        
        [UIView animateWithDuration:.2 animations:^{
            
            self.tabBar.layer.borderWidth = 0;
            
            [self extendSpeedView];
            
            [self.view layoutIfNeeded];
            
            
        } completion:^(BOOL finished) {
            
            self.speedViewDisplayed = YES;
            
            NSLog(@"self.sizeView is displayed is %d", self.sizeViewDisplayed);
            
            [self enableAllControl];
        }];
        
    }
    
}


-(void)behaviorViewTapped
{
    
    [self disableAllControl];
    
    if (self.settingsViewDisplayed)
    {
        
        [UIView animateWithDuration:.2 animations:^{
            
            [self resetTabBarIfOtherViewDisplayed];
            
            [self.view layoutIfNeeded];
            
            
        } completion:^(BOOL finished) {
            
            [self viewsBackToGray];
            
            self.settingsViewDisplayed = NO;
            
            [self enableAllControl];
            
        }];
    }
    
    else if (self.backgroundViewDisplayed || self.sizeViewDisplayed || self.speedViewDisplayed)
    {
        
        
        [self disableAllControl];
        
        
        [UIView animateWithDuration:.1 animations:^{
            
            [self resetTabBarIfOtherViewDisplayed];
            
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            [self viewsBackToGray];
            
            [UIView animateWithDuration:.2 animations:^{
                
                self.tabBar.layer.borderWidth = 0;
                
                [self extendSettingsView];
                
                [self.view layoutIfNeeded];
                
                
            } completion:^(BOOL finished) {
                
                self.settingsViewDisplayed = YES;
            }];
            
            [self enableAllControl];
            
        }];
        
    }
    
    else
    {
        
        [self disableAllControl];
        
        [UIView animateWithDuration:.2 animations:^{
            
            self.tabBar.layer.borderWidth = 0;
            
            [self extendSettingsView];
            
            [self.view layoutIfNeeded];
            
            
        } completion:^(BOOL finished) {
            
            self.settingsViewDisplayed = YES;
            
            [self enableAllControl];
        }];
        
    }
    
    
}



-(void)mainCircleTappedWhileBigAndNothingDisplayed
{
    [UIView animateWithDuration:.15
                     animations:^{
                         
                         [self shrinkTabBar];
                         
                         [self.view layoutIfNeeded];
                         
                         
                     } completion:^(BOOL finished) {
                         
                         
                         [UIView animateWithDuration:.15 animations:^{
                             
                             [self shrinkMainCircle];
                             
                             [self.view layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                             
                             [self enableAllControl];
                             
                             self.circleSmall = YES;
                             
                         }];
                     }];
}

-(void)mainCircleTappedWhileSmall
{
    [self disableAllControl];
    
    [UIView animateWithDuration:.15
                     animations:^{
                         
                         [self growMainCircle];
                         
                         [self.view layoutIfNeeded];
                         
                         
                     } completion:^(BOOL finished) {
                         
                         
                         [UIView animateWithDuration:.15 animations:^{
                             
                             [self extendTabBar];
                             
                             [self.view layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                             
                             [self enableAllControl];
                             
                             self.circleSmall = NO;
                             
                             
                             
                         }];
                     }];
    
    
    
}

-(void)mainCircleTappedWithViewDisplayed
{
    
    [self disableAllControl];
    
    [UIView animateWithDuration:.1
                     animations:^{
                         
                         [self resetTabBarIfOtherViewDisplayed];
                         
                         [self viewsBackToGray];
                         
                     } completion:^(BOOL finished) {
                         
                         
                         [UIView animateWithDuration:.05
                                          animations:^{
                                              
                                              [self shrinkTabBar];
                                              
                                              [self.view layoutIfNeeded];
                                              
                                              
                                          } completion:^(BOOL finished) {
                                              
                                              
                                              [UIView animateWithDuration:.15 animations:^{
                                                  
                                                  [self shrinkMainCircle];
                                                  
                                                  [self.view layoutIfNeeded];
                                                  
                                              } completion:^(BOOL finished) {
                                                  
                                                  [self enableAllControl];
                                                  
                                                  self.circleSmall = YES;
                                                  
                                              }];
                                          }];
                         
                         
                         
                         
                     }];
    
}




// size and color delegate methods

-(void)sizeChosen:(CGFloat)diameter
{
    
    self.bubbleDiameter = diameter;
    
    
}

-(void)bubbleColorChosenWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    
    self.bubbleColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
    
}










// Background view delegate methods

-(void)colorBackgroundButtonTapped
{
    self.backgroundImageView.alpha = 0;
}

-(void)colorChosenWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    
    self.view.backgroundColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

-(void)imageBackgroundButtonTapped
{
    
    self.backgroundImageView.alpha = 1;
}


-(void)addImageButtonTapped
{
    
    
    if (self.imagePickerCalled == NO)
    {
        [self setUpImagePicker];
        
        [self presentViewController:self.imagePicker animated:YES completion:^{
            // completion block;
        }];
    }
    else
    {
        [self presentViewController:self.imagePicker animated:YES completion:^{
            // completion block;
        }];
    }
}

-(void)setUpImagePicker
{
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    
    self.imagePicker.delegate = self;
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    self.imagePickerCalled = YES;
    
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    self.backgroundImageView.image = info[@"UIImagePickerControllerOriginalImage"];
    
    [self dismissViewControllerAnimated:self.imagePicker completion:^{
        // some code;
    }];
    
    self.backgroundView.imageView.image = info[@"UIImagePickerControllerOriginalImage"];
    
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:self.imagePicker completion:^{
        // some code
    }];
}


// Settings View delegates

-(void)undoLastBubbleTapped
{
    Bubble *lastBubble = [self.allBubbles lastObject];
    
    [lastBubble removeFromSuperview];
    
    [self.allBubbles removeObject:lastBubble];
    
     self.settingsView.totalBubblesLabel.text = [NSString stringWithFormat:@"Total Bubbles: %lu",self.allBubbles.count];

}

-(void)clearAllBubblesTapped
{
    
    for (Bubble *bubble in self.allBubbles)
    {
        [bubble removeFromSuperview];
    }
    
    [self.allBubbles removeAllObjects];
    
     self.settingsView.totalBubblesLabel.text = [NSString stringWithFormat:@"Total Bubbles: %lu",self.allBubbles.count];
    
    
}

-(void)pausePlayButtonTapped
{
    
    if (self.isPaused)
    {
        [self resumeBubbles];
        
        self.isPaused = NO;
    }
    else
    {
        [self pauseBubbles];
        
        self.isPaused = YES;
    }
    
}



// speed and behavior delegates


-(void)speedChosen:(NSInteger)speed
{
    self.animationSpeed = speed;
}

-(void)behaviorChosen:(NSInteger)behaviorIndex
{
    self.behaviorIndex = behaviorIndex;
    
   
}










@end
