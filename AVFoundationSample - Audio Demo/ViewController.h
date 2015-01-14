//
//  ViewController.h
//  AVFoundationSample - Audio Demo
//
//  Created by Kyle Carruthers on 2014-12-23.
//  Copyright (c) 2014 Kyle Carruthers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UISlider *playPositionSlider;

-(IBAction)recordPausePressed:(id)sender;
-(IBAction)stopPressed:(id)sender;
-(IBAction)playPressed:(id)sender;
-(IBAction)sliderPushed:(id)sender;

@end
