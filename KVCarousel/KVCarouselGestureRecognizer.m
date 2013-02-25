//
//  KVCarouselGestureRecognizer.m
//  Structures
//
//  Created by Johan Kool on 24/2/2013.
//  Copyright (c) 2013 Koolistov Pte. Ltd. All rights reserved.
//

#import "KVCarouselGestureRecognizer.h"

#import <QuartzCore/QuartzCore.h>

#define kAnimationDuration 0.25

@interface KVCarouselGestureRecognizer () {
    UIImageView *_temporaryImageView;
    CGPoint _originalOrigin;
    CGPoint _lastTranslation;
    KVCarouselDirection _direction;
    KVCarouselResult _loadedResult;
    KVCarouselResult _expectedResult;
    BOOL _previousResultAvailable;
    BOOL _nextResultAvailable;
}

@end

@implementation KVCarouselGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action {
    self = [super initWithTarget:target action:action];
    if (self) {
        self.allowedDirections = KVCarouselDirectionHorizontal;
        self.bounces = YES;
        self.gapSize = CGSizeZero;
        [self addTarget:self action:@selector(pan)];
    }
    return self;
}

- (void)pan {
    switch (self.state) {
        case UIGestureRecognizerStateBegan: {
            _direction = KVCarouselDirectionHorizontal;
            _loadedResult = KVCarouselResultCurrent;
            _expectedResult = KVCarouselResultCurrent;
            _previousResultAvailable = YES;
            _nextResultAvailable = YES;
            _originalOrigin = self.view.frame.origin;

            // Determine direction
            CGPoint translation = [self translationInView:self.view.superview];
             _lastTranslation = translation;
            if (fabsf(translation.y) > fabsf(translation.x)) {
                _direction = KVCarouselDirectionVertical;
            } else {
                _direction = KVCarouselDirectionHorizontal;
            }
            if (!(_direction | self.allowedDirections)) {
                _direction = self.allowedDirections;
            }

            if ([self.delegate respondsToSelector:@selector(recognizer:willStartInDirection:)]) {
                [self.delegate recognizer:self willStartInDirection:_direction];
            }

            // Get image for current state
            UIGraphicsBeginImageContextWithOptions(self.view.frame.size, YES, [self.view.window screen].scale);
            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *imageForCurrent = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

            // Add image to superview
            _temporaryImageView = [[UIImageView alloc] initWithImage:imageForCurrent];
            _temporaryImageView.frame = self.view.frame;
            [self.view.superview insertSubview:_temporaryImageView aboveSubview:self.view];

            KVCarouselResult resultToLoad = [self resultToLoad];
            if (_loadedResult != resultToLoad) {
                [self loadResult:resultToLoad];
                _loadedResult = resultToLoad;
            }

            [self adjustViewLocations];

            if ([self.delegate respondsToSelector:@selector(recognizer:didStartInDirection:)]) {
                [self.delegate recognizer:self didStartInDirection:_direction];
            }

            KVCarouselResult expectedResult = [self expectedResultWithVelocity:NO];
            if (_expectedResult != expectedResult) {
                if ([self.delegate respondsToSelector:@selector(recognizer:expectedResultChangedTo:inDirection:)]) {
                    [self.delegate recognizer:self expectedResultChangedTo:expectedResult inDirection:_direction];
                }
                _expectedResult = expectedResult;
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            KVCarouselResult resultToLoad = [self resultToLoad];
            if (_loadedResult != resultToLoad) {
                [self loadResult:resultToLoad];
                _loadedResult = resultToLoad;
            }

            [self adjustViewLocations];

            KVCarouselResult expectedResult = [self expectedResultWithVelocity:NO];
            if (_expectedResult != expectedResult) {
                if ([self.delegate respondsToSelector:@selector(recognizer:expectedResultChangedTo:inDirection:)]) {
                    [self.delegate recognizer:self expectedResultChangedTo:expectedResult inDirection:_direction];
                }
                _expectedResult = expectedResult;
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            KVCarouselResult expectedResult = [self expectedResultWithVelocity:YES];
            if ([self.delegate respondsToSelector:@selector(recognizer:willEndWithResult:inDirection:)]) {
                [self.delegate recognizer:self willEndWithResult:expectedResult inDirection:_direction];
            }
            [self adjustViewLocationsForFinalResult:expectedResult];
        }
            break;
        case UIGestureRecognizerStateCancelled: {
            if ([self.delegate respondsToSelector:@selector(recognizer:willEndWithResult:inDirection:)]) {
                [self.delegate recognizer:self willEndWithResult:KVCarouselResultCurrent inDirection:_direction];
            }
            [self adjustViewLocationsForFinalResult:KVCarouselResultCurrent];
        }
            break;
        default:
            break;
    }
}

- (KVCarouselResult)resultToLoad {
    KVCarouselResult resultToLoad = KVCarouselResultCurrent;
    CGPoint translation = [self translationInView:self.view.superview];
    if (_direction == KVCarouselDirectionHorizontal) {
        CGFloat translationX = MAX(MIN(translation.x, CGRectGetWidth(self.view.frame) + self.gapSize.width), -CGRectGetWidth(self.view.frame) - self.gapSize.width);

        if (translationX < 0.0f) {
            resultToLoad = KVCarouselResultNext;
        } else {
            resultToLoad = KVCarouselResultPrevious;
        }
    } else if (_direction == KVCarouselDirectionVertical) {
        CGFloat translationY = MAX(MIN(translation.y, CGRectGetHeight(self.view.frame) + self.gapSize.height), -CGRectGetHeight(self.view.frame) - self.gapSize.height);

        if (translationY < 0.0f) {
            resultToLoad = KVCarouselResultNext;
        } else {
            resultToLoad = KVCarouselResultPrevious;
        }
    }
    return resultToLoad;
}

- (KVCarouselResult)expectedResultWithVelocity:(BOOL)allowVelocity {
    KVCarouselResult expectedResult = KVCarouselResultCurrent;
    CGPoint translation = [self translationInView:self.view.superview];
    CGPoint velocity = [self velocityInView:self.view.superview];
    if (_direction == KVCarouselDirectionHorizontal) {
        CGFloat translationX = MAX(MIN(translation.x, CGRectGetWidth(self.view.frame) + self.gapSize.width), -CGRectGetWidth(self.view.frame) - self.gapSize.width);
        CGFloat halfWidth = 0.5f * CGRectGetWidth(self.view.frame) + 0.5f * self.gapSize.width;
        
        if ((translationX < -halfWidth) || (allowVelocity && (velocity.x * kAnimationDuration < -halfWidth))) {
            if (_nextResultAvailable) {
                expectedResult = KVCarouselResultNext;
            }
        } else if ((translationX > halfWidth) || (allowVelocity && (velocity.x * kAnimationDuration > halfWidth))) {
            if (_previousResultAvailable) {
                expectedResult = KVCarouselResultPrevious;
            }
        }
    } else if (_direction == KVCarouselDirectionVertical) {
        CGFloat translationY = MAX(MIN(translation.y, CGRectGetHeight(self.view.frame) + self.gapSize.height), -CGRectGetHeight(self.view.frame) - self.gapSize.height);
        CGFloat halfHeight = 0.5f * CGRectGetHeight(self.view.frame) + 0.5f * self.gapSize.height;

        if ((translationY < -halfHeight) || (allowVelocity && (velocity.y * kAnimationDuration < -halfHeight))) {
            if (_nextResultAvailable) {
                expectedResult = KVCarouselResultNext;
            }
        } else if ((translationY > halfHeight) || (allowVelocity && (velocity.y * kAnimationDuration > halfHeight))) {
            if (_previousResultAvailable) {
                expectedResult = KVCarouselResultPrevious;
            }
        }
    }
    return expectedResult;
}

- (void)loadResult:(KVCarouselResult)resultToLoad {
    if (resultToLoad == KVCarouselResultNext) {
        // Update view for next state here
        if ([self.delegate respondsToSelector:@selector(recognizer:canChangeToResult:inDirection:)]) {
            _nextResultAvailable = [self.delegate recognizer:self canChangeToResult:resultToLoad inDirection:_direction];
        }
        if (_nextResultAvailable) {
            if ([self.delegate respondsToSelector:@selector(recognizer:updateViewForResult:inDirection:)]) {
                [self.delegate recognizer:self updateViewForResult:resultToLoad inDirection:_direction];
            }
        }
    } else if (resultToLoad == KVCarouselResultPrevious) {
        // Update view for previous state here
        if ([self.delegate respondsToSelector:@selector(recognizer:canChangeToResult:inDirection:)]) {
            _previousResultAvailable = [self.delegate recognizer:self canChangeToResult:resultToLoad inDirection:_direction];
        }
        if (_previousResultAvailable) {
            if ([self.delegate respondsToSelector:@selector(recognizer:updateViewForResult:inDirection:)]) {
                [self.delegate recognizer:self updateViewForResult:resultToLoad inDirection:_direction];
            }
        }
    } else if (resultToLoad == KVCarouselResultCurrent) {
        // Update view for current state here
        if ([self.delegate respondsToSelector:@selector(recognizer:updateViewForResult:inDirection:)]) {
            [self.delegate recognizer:self updateViewForResult:resultToLoad inDirection:_direction];
        }
    }
}

- (void)adjustViewLocations {
    CGPoint translation = [self translationInView:self.view.superview];
    if (_direction == KVCarouselDirectionHorizontal) {
        CGFloat translationX = MAX(MIN(translation.x, CGRectGetWidth(self.view.frame) + self.gapSize.width), -CGRectGetWidth(self.view.frame) - self.gapSize.width);
   
        CGRect actualViewFrame = self.view.frame;
        if (_loadedResult == KVCarouselResultPrevious && _previousResultAvailable) {
            actualViewFrame.origin.x = -CGRectGetWidth(self.view.frame) + translationX;
            actualViewFrame.origin.x -= self.gapSize.width;
            self.view.hidden = NO;
        } else if (_loadedResult == KVCarouselResultPrevious && !_previousResultAvailable) {
            if (!self.bounces) {
                translationX = 0.0f;
            }
            self.view.hidden = YES;
        } else if (_loadedResult == KVCarouselResultNext && _nextResultAvailable) {
            actualViewFrame.origin.x = CGRectGetWidth(self.view.frame) + translationX;
            actualViewFrame.origin.x += self.gapSize.width;
            self.view.hidden = NO;
        } else if (_loadedResult == KVCarouselResultNext && !_nextResultAvailable) {
            if (!self.bounces) {
                translationX = 0.0f;
            }
            self.view.hidden = YES;
        } else {
            self.view.hidden = YES;
        }
        self.view.frame = actualViewFrame;

        CGRect temporaryImageFrame = _temporaryImageView.frame;
        temporaryImageFrame.origin.x = translationX;
        _temporaryImageView.frame = temporaryImageFrame;
    } else if (_direction == KVCarouselDirectionVertical) {
        CGFloat translationY = MAX(MIN(translation.y, CGRectGetHeight(self.view.frame) + self.gapSize.height), -CGRectGetHeight(self.view.frame) - self.gapSize.height);

        CGRect actualViewFrame = self.view.frame;
        if (_loadedResult == KVCarouselResultPrevious && _previousResultAvailable) {
            actualViewFrame.origin.y = -CGRectGetHeight(self.view.frame) + translationY;
            actualViewFrame.origin.y -= self.gapSize.height;
            self.view.hidden = NO;
        } else if (_loadedResult == KVCarouselResultPrevious && !_previousResultAvailable) {
            if (!self.bounces) {
                translationY = 0.0f;
            }
            self.view.hidden = YES;
        } else if (_loadedResult == KVCarouselResultNext && _nextResultAvailable) {
            actualViewFrame.origin.y = CGRectGetHeight(self.view.frame) + translationY;
            actualViewFrame.origin.y += self.gapSize.height;
            self.view.hidden = NO;
        } else if (_loadedResult == KVCarouselResultNext && !_nextResultAvailable) {
            if (!self.bounces) {
                translationY = 0.0f;
            }
            self.view.hidden = YES;
        } else {
            self.view.hidden = YES;
        }
        self.view.frame = actualViewFrame;

        CGRect temporaryImageFrame = _temporaryImageView.frame;
        temporaryImageFrame.origin.y = translationY;
        _temporaryImageView.frame = temporaryImageFrame;
    }
}

- (void)adjustViewLocationsForFinalResult:(KVCarouselResult)result {
    [UIView animateWithDuration:kAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (_direction == KVCarouselDirectionHorizontal) {
                if (result == KVCarouselResultPrevious) {
                    CGRect temporaryImageFrame = _temporaryImageView.frame;
                    temporaryImageFrame.origin.x = CGRectGetWidth(self.view.frame) + self.gapSize.width;
                    _temporaryImageView.frame = temporaryImageFrame;

                    CGRect actualViewFrame = self.view.frame;
                    actualViewFrame.origin = _originalOrigin;
                    self.view.frame = actualViewFrame;
                } else if (result == KVCarouselResultCurrent) {
                    CGRect temporaryImageFrame = _temporaryImageView.frame;
                    temporaryImageFrame.origin = _originalOrigin;
                    _temporaryImageView.frame = temporaryImageFrame;

                    if (_loadedResult == KVCarouselResultPrevious) {
                        CGRect actualViewFrame = self.view.frame;
                        actualViewFrame.origin.x = -CGRectGetWidth(self.view.frame) - self.gapSize.width;
                        self.view.frame = actualViewFrame;
                    } else if (_loadedResult == KVCarouselResultNext) {
                        CGRect actualViewFrame = self.view.frame;
                        actualViewFrame.origin.x = CGRectGetWidth(self.view.frame) + self.gapSize.width;
                        self.view.frame = actualViewFrame;
                    }
                } else if (result == KVCarouselResultNext) {
                    CGRect temporaryImageFrame = _temporaryImageView.frame;
                    temporaryImageFrame.origin.x = -CGRectGetWidth(self.view.frame) - self.gapSize.width;
                    _temporaryImageView.frame = temporaryImageFrame;

                    CGRect actualViewFrame = self.view.frame;
                    actualViewFrame.origin = _originalOrigin;
                    self.view.frame = actualViewFrame;
                }
            }  else if (_direction == KVCarouselDirectionVertical) {
                if (result == KVCarouselResultPrevious) {
                    CGRect temporaryImageFrame = _temporaryImageView.frame;
                    temporaryImageFrame.origin.y = CGRectGetHeight(self.view.frame) + self.gapSize.height;
                    _temporaryImageView.frame = temporaryImageFrame;

                    CGRect actualViewFrame = self.view.frame;
                    actualViewFrame.origin = _originalOrigin;
                    self.view.frame = actualViewFrame;
                } else if (result == KVCarouselResultCurrent) {
                    CGRect temporaryImageFrame = _temporaryImageView.frame;
                    temporaryImageFrame.origin = _originalOrigin;
                    _temporaryImageView.frame = temporaryImageFrame;

                    if (_loadedResult == KVCarouselResultPrevious) {
                        CGRect actualViewFrame = self.view.frame;
                        actualViewFrame.origin.y = -CGRectGetHeight(self.view.frame) - self.gapSize.height;
                        self.view.frame = actualViewFrame;
                    } else if (_loadedResult == KVCarouselResultNext) {
                        CGRect actualViewFrame = self.view.frame;
                        actualViewFrame.origin.y = CGRectGetHeight(self.view.frame) + self.gapSize.height;
                        self.view.frame = actualViewFrame;
                    }
                } else if (result == KVCarouselResultNext) {
                    CGRect temporaryImageFrame = _temporaryImageView.frame;
                    temporaryImageFrame.origin.y = -CGRectGetHeight(self.view.frame) - self.gapSize.height;
                    _temporaryImageView.frame = temporaryImageFrame;

                    CGRect actualViewFrame = self.view.frame;
                    actualViewFrame.origin = _originalOrigin;
                    self.view.frame = actualViewFrame;
                }
            }
   } completion:^(BOOL finished) {
       CGRect actualViewFrame = self.view.frame;
       actualViewFrame.origin = _originalOrigin;
       self.view.frame = actualViewFrame;
       self.view.hidden = NO;
       
       [_temporaryImageView removeFromSuperview];

       if (_loadedResult != result) {
           [self loadResult:result];
       }
       
       if ([self.delegate respondsToSelector:@selector(recognizer:didEndWithResult:inDirection:)]) {
           [self.delegate recognizer:self didEndWithResult:result inDirection:_direction];
       }
   }];
}

@end
