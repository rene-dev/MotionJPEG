//
//  MotionJPEGViewController.m
//  MotionJPEG
//
//  Created by Rene Hopf on 2/20/11.
//  Copyright 2011 Reroo. All rights reserved.
//

#import "MotionJPEGViewController.h"

@implementation MotionJPEGViewController
@synthesize image,connection,receivedData1,receivedData2,currentData,FPSLabel;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	frameCounter = 0;
	FPSTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showFPS) userInfo:nil repeats:YES];

	URL = [NSURL URLWithString:@"https://intern.ist-wunderbar.com/image.php"];

	NSURLRequest *theRequest=[NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:6.0];
    
    //tell NSURL to ignore invalid SSL certificates
    [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[URL host]];
	
    connection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	receivedData1 = [[NSMutableData data]retain];//alloc buffers
	receivedData2 = [[NSMutableData data]retain];
	currentData = receivedData1;
	
	[URL release];
	[super viewDidLoad];
}

#pragma mark -
#pragma mark NSURLConnection delegation

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
{
	[currentData appendData:data];//append new incomming data to data
}

- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response{
	if([[response MIMEType] isEqualToString:@"image/jpeg"] && [currentData length] != 0){
		currentFrame = [UIImage imageWithData:currentData];
		[image setImage:currentFrame];//show image
		frameCounter++;
	}
	else {
		NSLog(@"other data:%@",currentData);
	}
	currentFrame = nil;
	if (currentData == receivedData1)//swap buffers
        currentData = receivedData2;        
    else
        currentData = receivedData1;    
	[currentData setLength:0];
	[currentFrame release];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	NSLog(@"connectionDidFinishLoading,%i",[currentData length]);
	NSLog(@"end of Stream, this should never happen");
    theConnection =nil;
	receivedData1=nil;	
	receivedData2=nil;
    [receivedData1 release];
	[receivedData2 release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	UIAlertView *connectionErrorAlert = [[UIAlertView alloc]
										 initWithTitle:nil
										 message:[NSString stringWithFormat:@"%@",[error localizedDescription]]
										 delegate:self 
										 cancelButtonTitle:nil
										 otherButtonTitles:@"OK", nil];
	[connectionErrorAlert show];
	[connectionErrorAlert release];
}

#pragma mark -
#pragma mark Camera Roll

-(IBAction)saveToCameraRoll{
	UIImageWriteToSavedPhotosAlbum(image.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
	if (error != NULL)
    {
		NSLog(@"%@",error);	
    }
    else
    {
		UIAlertView *imageSavedAlert = [[UIAlertView alloc]
								initWithTitle:@"MotionJPEG"
								message:@"Image Saved."
								delegate:self 
								cancelButtonTitle:nil
								otherButtonTitles:@"OK", nil];
		[imageSavedAlert show];
		[imageSavedAlert release];
    }
}

#pragma mark -
#pragma mark FPS

-(void)showFPS{
	FPSLabel.text = [NSString stringWithFormat:@"%i FPS",frameCounter];
	frameCounter = 0;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[image release];
	[connection release];
	[receivedData1 release];
	[receivedData2 release];
	[currentData release];
	[FPSLabel release];
    [super dealloc];
}

@end
