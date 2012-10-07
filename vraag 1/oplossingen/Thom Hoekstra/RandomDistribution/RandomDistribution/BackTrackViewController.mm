//
//  PhysicsViewController.m
//  RandomDistribution
//
//  Created by Thom Hoekstra on 30-09-12.
//  Copyright (c) 2012 Thom Hoekstra. All rights reserved.
//

#import "BackTrackViewController.h"

// Rectangle dimensions
#define MIN_WIDTH                   100
#define MIN_HEIGHT                  60
#define MAX_WIDTH                   200
#define MAX_HEIGHT                  120

#define RECT_COUNT                  25

#define MAX_PLACEMENT_ATTEMPTS      20 // placement attempts per branch
#define MAX_BRANCHES                5

#define LOGGING_ENABLED             YES

@interface BackTrackViewController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *rectSizes;

- (void)makeRects;
- (void)logRects:(NSArray*)rects;

@end

@implementation BackTrackViewController

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = NSLocalizedString(@"Backtracking", @"Backtracking");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
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


- (void)logRects:(NSArray*)rects
{
    if( LOGGING_ENABLED )
        NSLog(@"[%@%@]", [@"" stringByPaddingToLength:rects.count withString:@"-" startingAtIndex:0], [@"" stringByPaddingToLength:RECT_COUNT - rects.count withString:@" " startingAtIndex:0]);
}

- (bool)attemptToPlaceRectBetweenCurrentRects:(NSMutableArray *)currentRects
{
    if (currentRects.count >= RECT_COUNT)
    {
        // all rectangles are in the array, that means that there aren't any intersecting rectangles, so this attempt/branch is valid
        return true;
    }
    
    // retrieve the dimensions from the size array
    int width = [[self.rectSizes objectAtIndex:currentRects.count] CGSizeValue].width;
    int height = [[self.rectSizes objectAtIndex:currentRects.count] CGSizeValue].height;
    
    for (int i = 0; i < MAX_BRANCHES; ++i)
    {
        CGRect rect;
        int attemptCount = 0;
        
        do
        {
            // Make a rectangle with width and height and a random position
            rect = CGRectMake(rand() % (1024 - width), rand() % (699 - height), width, height);
            attemptCount++;
            
        } while ([self rect:rect isIntersectingRects:currentRects] && (attemptCount < MAX_PLACEMENT_ATTEMPTS));
        
        if (attemptCount >= MAX_PLACEMENT_ATTEMPTS)
        {
            // It wasn't possible to find a position for the rectangle in under MAX_PLACEMENT_ATTEMPTS attempts so this branch is false 
            return false;
        }
        
        [currentRects addObject:[NSValue valueWithCGRect:rect]];
        
        [self logRects:currentRects];
        
        // attempt to place the next rectangle when the calculated rectangle is added to the array
        if ([self attemptToPlaceRectBetweenCurrentRects:currentRects])
        {
            return true;
        }
        else
        {
            // if the attempt failed, remove the rectangle and try to start the branch with a new position
            [currentRects removeLastObject];
            
            [self logRects:currentRects];
        }
    }
    
    // Every branch failed
    return false;
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
    
    if (![self attemptToPlaceRectBetweenCurrentRects:rectArray])
    {
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
