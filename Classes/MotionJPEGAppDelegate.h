//
//  MotionJPEGAppDelegate.h
//  MotionJPEG
//
//  Created by Rene Hopf on 2/20/11.
//  Copyright 2011 Reroo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MotionJPEGViewController;

@interface MotionJPEGAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MotionJPEGViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MotionJPEGViewController *viewController;

@end

