//
//  BruteForceViewController.m
//  RandomDistribution
//
//  Created by Thom Hoekstra on 30-09-12.
//  Copyright (c) 2012 Thom Hoekstra. All rights reserved.
//

#import "BruteForceViewController.h"

// Rectangle dimensions
#define MIN_WIDTH                   100
#define MIN_HEIGHT                  60
#define MAX_WIDTH                   200
#define MAX_HEIGHT                  120

#define RECT_COUNT                  20

#define MAX_PLACEMENT_ATTEMPTS      200

@interface BruteForceViewController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *rectSizes;

- (void)makeRects;

@end

@implementation BruteForceViewController

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = NSLocalizedString(@"Brute Force", @"Brute Force");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self makeRects];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeRects)];
    [self.view addGestureRecognizer:recognizer];
}

- (bool)rect:(CGRect)rect isIntersectingRects:(NSArray*)rectArray
{
    for (NSValue *rectValue in rectArray)
    {
        CGRect arrayRect = [rectValue CGRectValue];
        
        if (CGRectIntersectsRect(rect, arrayRect))
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)makeRects
{
    self.rectSizes = [NSMutableArray array];
    
    // Create dimensions for each rectangle
    for (int i = 0; i < RECT_COUNT; ++i)
    {
        // Generate a random width and height for this rectangle
        int width = MIN_WIDTH + rand() % (MAX_WIDTH - MIN_WIDTH);
        int height = MIN_HEIGHT + rand() % (MAX_HEIGHT - MIN_HEIGHT);
        
        // As NSArray only holds Objects, store the dimensions in a NSValue and then add the NSValue to the array
        [self.rectSizes addObject:[NSValue valueWithCGSize:CGSizeMake(width, height)]];
    }
    
    // A container view is used to easily get rid of all subviews.
    [self.containerView removeFromSuperview];
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1024.0f, 699.0f)];
    [self.view addSubview:self.containerView];
    
    NSMutableArray *rectArray = [NSMutableArray array];
    
    bool failedToPlaceAllRects = NO;
    
    for (int i = 0; i < RECT_COUNT; ++i)
    {
        
        CGRect rect;        
        int attemptCount = 0;
        
        // retrieve the dimensions from the size array
        int width = [[self.rectSizes objectAtIndex:i] CGSizeValue].width;
        int height = [[self.rectSizes objectAtIndex:i] CGSizeValue].height;
        
        do
        {
            // Make a rectangle with width and height and a random position
            rect = CGRectMake(rand() % (1024 - width), rand() % (699 - height), width, height); // 1024 = iPad screen width, 699 = iPad screenheight - statusbar - tapbar in landscape
            attemptCount++;
            
        } while ([self rect:rect isIntersectingRects:rectArray] && (attemptCount < MAX_PLACEMENT_ATTEMPTS)); // repeat while the rectangle is intersecting previous rectangles
        
        if (attemptCount >= MAX_PLACEMENT_ATTEMPTS) // Ouch! it was not possible to create a random rectangle wich doesn't intersect other rectangles in under MAX_PLACEMENT_ATTEMPTS attempts
        {
            failedToPlaceAllRects = YES; // The algorithm failed
            break;
        }
        
        
        // Add the created rectangle to the array
        [rectArray addObject:[NSValue valueWithCGRect:rect]];
    }
    
    if (failedToPlaceAllRects)
    {
        // The algorithm failed, and I wanted to point this out when this happened so create a red screen of algorithm failure
    
        self.containerView.backgroundColor = [UIColor redColor];
        
        UILabel *failedLabel = [[UILabel alloc] initWithFrame:self.containerView.frame];
        failedLabel.textAlignment = NSTextAlignmentCenter;
        failedLabel.text = [NSString stringWithFormat:@"Failed to place all %d rects\nTap to try again", RECT_COUNT];
        failedLabel.numberOfLines = 2;
        failedLabel.textColor = [UIColor whiteColor];
        failedLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        failedLabel.backgroundColor = [UIColor clearColor];
        
        [self.containerView addSubview:failedLabel];
    }
    else
    {
        // The algorithm didn't fail, so for each rectangle make a new UIView with a random color
        for (NSValue *rectValue in rectArray)
        {
            CGRect rect = [rectValue CGRectValue];
            
            UIView *rectView = [[UIView alloc] initWithFrame:rect];
            rectView.backgroundColor = [UIColor colorWithRed:fmodf((float)rand() / 100000.0f, 1.0f)
                                                       green:fmodf((float)rand() / 100000.0f, 1.0f)
                                                        blue:fmodf((float)rand() / 100000.0f, 1.0f)
                                                       alpha:1.0f];
            [self.containerView addSubview:rectView];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
