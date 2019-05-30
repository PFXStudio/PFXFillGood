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

#import "UIView+Custom.h"

@implementation UIView (Custom)

+ (void)animateAcceleratedBounceEffectWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
    if (([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)) {
        [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:dampingRatio initialSpringVelocity:velocity options:options animations:animations completion:completion];
    } else {
        [UIView animateWithDuration:duration delay:delay options:options animations:animations completion:completion];
    }
}

- (void)roundLayer
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8)
    {
        return;
    }
    
    [self.layer setCornerRadius:5];
    [self.layer setMasksToBounds:YES];
}

- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
