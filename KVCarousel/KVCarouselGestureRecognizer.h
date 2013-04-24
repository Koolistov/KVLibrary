//
//  KVCarouselGestureRecognizer.h
//  KVLibrary
//
//  Created by Johan Kool on 24/2/2013.
//  Copyright (c) 2013 Koolistov Pte. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KVCarouselGestureRecognizer;

typedef NS_OPTIONS(NSInteger, KVCarouselDirection) {
    KVCarouselDirectionHorizontal = 1 << 0,
    KVCarouselDirectionVertical = 1 << 1
};

typedef NS_ENUM(NSInteger, KVCarouselResult) {
    KVCarouselResultCurrent,
    KVCarouselResultPrevious,
    KVCarouselResultNext
};

/**
 * Protocol to be implemented by delegates of KVCarouselGestureRecognizer.
 */
@protocol KVCarouselGestureRecognizerDelegate <NSObject>

@optional

/** @name Carousel boundaries and content */

/**
 * Asks the delegate wether it can provide a result in a given direction. This method is optional. If not present, `YES` is assumed.
 *
 * @param recognizer Recognizer
 * @param result Result of change
 * @param direction Direction of change
 *
 * @result Return `YES` if changing is possible, `NO` if not possible.
 */
- (BOOL)recognizer:(KVCarouselGestureRecognizer *)recognizer canChangeToResult:(KVCarouselResult)result inDirection:(KVCarouselDirection)direction;

/**
 * Asks the delegate to update the view for a change in a direction.
 *
 * @param recognizer Recognizer
 * @param result Result of change
 * @param direction Direction of change
 *
 * @result Return `YES` if changing is possible, `NO` if not possible.
 */
- (void)recognizer:(KVCarouselGestureRecognizer *)recognizer updateViewForResult:(KVCarouselResult)result inDirection:(KVCarouselDirection)direction;

/** @name Starting and stopping */

/**
 * Informs the delegate that the user is about to start panning the view.
 *
 * @param recognizer Recognizer
 * @param direction Direction of change
 */
- (void)recognizer:(KVCarouselGestureRecognizer *)recognizer willStartInDirection:(KVCarouselDirection)direction;

/**
 * Informs the delegate that the user did start panning the view.
 *
 * @param recognizer Recognizer
 * @param direction Direction of change
 */
- (void)recognizer:(KVCarouselGestureRecognizer *)recognizer didStartInDirection:(KVCarouselDirection)direction;

/**
 * Informs the delegate that the user is about to end panning the view.
 *
 * @param recognizer Recognizer
 * @param result End result of change
 * @param direction Direction of change
 */
- (void)recognizer:(KVCarouselGestureRecognizer *)recognizer willEndWithResult:(KVCarouselResult)result inDirection:(KVCarouselDirection)direction;

/**
 * Informs the delegate that the user did end panning the view.
 *
 * @param recognizer Recognizer
 * @param result End result of change
 * @param direction Direction of change
 */
- (void)recognizer:(KVCarouselGestureRecognizer *)recognizer didEndWithResult:(KVCarouselResult)result inDirection:(KVCarouselDirection)direction;

/** @name Carousel events */

/**
 * Informs the delegate that the expected outcome of the panning has changed.
 *
 * @param recognizer Recognizer
 * @param result Expected result of change
 * @param direction Direction of change
 */
- (void)recognizer:(KVCarouselGestureRecognizer *)recognizer expectedResultChangedTo:(KVCarouselResult)result inDirection:(KVCarouselDirection)direction;

@end

/**
 * This gesture recognizer lets you add interactive carousel-like behavior to any view. The gesture recognizer delegate is extended with the methods from the KVCarouselGestureRecognizerDelegate protocol.
 */
@interface KVCarouselGestureRecognizer : UIPanGestureRecognizer

/** @name Carousel delegate */

/**
 * Delegate.
 */
@property (nonatomic, weak) id <KVCarouselGestureRecognizerDelegate, UIGestureRecognizerDelegate> delegate;

/** @name Configuring carousel behavior */

/**
 * Bitmask of allowed directions of swiping in carousel. Defaults to `KVCarouselDirectionHorizontal`.
 */
@property (nonatomic, assign) KVCarouselDirection allowedDirections;

/**
 * Toggles bouncing at the edges. Defaults to `YES`.
 */
@property (nonatomic, assign) BOOL bounces;

/**
 * Sets the size of the gap between views. Defaults to `CGSizeZero`.
 */
@property (nonatomic, assign) CGSize gapSize;


@end

