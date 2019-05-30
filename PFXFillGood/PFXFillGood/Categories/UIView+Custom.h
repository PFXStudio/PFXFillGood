/**
 * Copyright (C) Hanwha Systems Ltd., 2015. All rights reserved.
 *
 * This software is covered by the license agreement between
 * the end user and Hanwha Systems Ltd., and may be
 * used and copied only in accordance with the terms of the
 * said agreement.
 *
 * Hanwha Systems Ltd., assumes no responsibility or
 * liability for any errors or inaccuracies in this software,
 * or any consequential, incidental or indirect damage arising
 * out of the use of the software.
 */

#import <UIKit/UIKit.h>

/**
 *  UIView 확장
 */
@interface UIView (Custom)


/**
 바운스 애니메이션
 
 @param duration 애니메이션 시간
 @param delay 딜레이
 @param dampingRatio 댐핑 값
 @param velocity 바운스 값
 @param options 옵션 값들
 @param animations 애니메이션 콜백
 @param completion 애니메이션 종료 콜백
 */
+ (void)animateAcceleratedBounceEffectWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

/**
 *  라운드 레이어
 */
- (void)roundLayer;

/**
 *  화면 캡쳐
 */
- (UIImage *)capture;

@end
