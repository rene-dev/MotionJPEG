//
//  MotionJPEGViewController.h
//  MotionJPEG
//
//  Created by Rene Hopf on 2/20/11.
//  Copyright 2011 Reroo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MotionJPEGViewController : UIViewController {
	IBOutlet UIImageView *image;
	IBOutlet UILabel *FPSLabel;
	UIImage *currentFrame;
	NSMutableData *receivedData1;
	NSMutableData *receivedData2;
	NSMutableData *currentData;
	NSURLConnection *connection;
	NSURL *URL;
	NSTimer *FPSTimer;
	int frameCounter;
}

-(void)showFPS;
-(IBAction)saveToCameraRoll;

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) UIImageView *image;
@property (nonatomic, retain) NSMutableData *receivedData1;
@property (nonatomic, retain) NSMutableData *receivedData2;
@property (nonatomic, retain) NSMutableData *currentData;
@property (nonatomic, retain) UILabel *FPSLabel;

@end

