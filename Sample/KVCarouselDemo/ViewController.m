//
//  ViewController.m
//  KVCarouselTest
//
//  Created by Johan Kool on 24/2/2013.
//  Copyright (c) 2013 Koolistov. All rights reserved.
//

#import "ViewController.h"

#import "KVCarouselGestureRecognizer.h"

@interface ViewController () <KVCarouselGestureRecognizerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger row;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    KVCarouselGestureRecognizer *carouselRecognizer = [[KVCarouselGestureRecognizer alloc] init];
    carouselRecognizer.delegate = self;
    carouselRecognizer.gapSize = CGSizeMake(10, 20);
    carouselRecognizer.allowedDirections = KVCarouselDirectionHorizontal|KVCarouselDirectionVertical;
    carouselRecognizer.bounces = YES;
    [self.label addGestureRecognizer:carouselRecognizer];
    self.label.userInteractionEnabled = YES;

    self.pageControl.numberOfPages = 6;

    [self updateLabelForRow:self.row column:self.column];
}

- (void)updateLabelForRow:(NSInteger)row column:(NSInteger)column {
    self.label.text = [NSString stringWithFormat:@"R%dC%d", row, column];
}

- (BOOL)recognizer:(KVCarouselGestureRecognizer *)recognizer canChangeToResult:(KVCarouselResult)result inDirection:(KVCarouselDirection)direction {
    if (direction == KVCarouselDirectionHorizontal) {
        if (result == KVCarouselResultPrevious) {
            return (self.column > 0);
        } else if (result == KVCarouselResultNext) {
            return (self.column < 5);
        }
    } else if (direction == KVCarouselDirectionVertical) {
        if (result == KVCarouselResultPrevious) {
            return (self.row > 0);
        } else if (result == KVCarouselResultNext) {
            return (self.row < 10);
        }
    }
    return NO;
}

- (void)recognizer:(KVCarouselGestureRecognizer *)recognizer willStartInDirection:(KVCarouselDirection)direction {
    NSLog(@"will start %@", recognizer);
}
- (void)recognizer:(KVCarouselGestureRecognizer *)recognizer didStartInDirection:(KVCarouselDirection)direction {
    NSLog(@"did start %@", recognizer);
}

- (void)recognizer:(KVCarouselGestureRecognizer *)recognizer updateViewForResult:(KVCarouselResult)result inDirection:(KVCarouselDirection)direction {
    NSLog(@"update view for result %d direction %d for %@", result, direction, recognizer);
    if (direction == KVCarouselDirectionHorizontal) {
        if (result == KVCarouselResultPrevious) {
            [self updateLabelForRow:self.row column:self.column - 1];
        } else if (result == KVCarouselResultNext) {
            [self updateLabelForRow:self.row column:self.column + 1];
        }
    } else if (direction == KVCarouselDirectionVertical) {
        if (result == KVCarouselResultPrevious) {
            [self updateLabelForRow:self.row - 1 column:self.column];
        } else if (result == KVCarouselResultNext) {
            [self updateLabelForRow:self.row + 1 column:self.column];
        }
    }
}

- (void)recognizer:(KVCarouselGestureRecognizer *)recognizer expectedResultChangedTo:(KVCarouselResult)result inDirection:(KVCarouselDirection)direction {
    NSLog(@"now expecting result %d direction %d for %@", result, direction, recognizer);
    if (direction == KVCarouselDirectionHorizontal) {
        if (result == KVCarouselResultPrevious) {
            self.pageControl.currentPage = self.column - 1;
        } else if (result == KVCarouselResultNext) {
            self.pageControl.currentPage = self.column + 1;
        } else if (result == KVCarouselResultCurrent) {
            self.pageControl.currentPage = self.column;
        }
    } 
}

- (void)recognizer:(KVCarouselGestureRecognizer *)recognizer willEndWithResult:(KVCarouselResult)result inDirection:(KVCarouselDirection)direction {
    NSLog(@"will end with result %d direction %d for %@", result, direction, recognizer);
}

- (void)recognizer:(KVCarouselGestureRecognizer *)recognizer didEndWithResult:(KVCarouselResult)result inDirection:(KVCarouselDirection)direction {
    NSLog(@"did end with result %d direction %d for %@", result, direction, recognizer);
    if (direction == KVCarouselDirectionHorizontal) {
        if (result == KVCarouselResultPrevious) {
            self.column--;
        } else if (result == KVCarouselResultNext) {
            self.column++;
        }
    } else if (direction == KVCarouselDirectionVertical) {
        if (result == KVCarouselResultPrevious) {
            self.row--;
        } else if (result == KVCarouselResultNext) {
            self.row++;
        }
    }
    [self updateLabelForRow:self.row column:self.column];
    self.pageControl.currentPage = self.column;
}

- (UIImage *)recognizer:(KVCarouselGestureRecognizer *)recognizer gapImageForDirection:(KVCarouselDirection)direction {
    return nil;
}
@end
