//
//  ViewController.m
//  AVFoundationSample - Audio Demo
//
//  Created by Kyle Carruthers on 2014-12-23.
//  Copyright (c) 2014 Kyle Carruthers. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}
@end

@implementation ViewController
@synthesize stopButton, playButton, recordPauseButton, playPositionSlider;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [playButton setEnabled:NO];
    [stopButton setEnabled:NO];
    
    NSArray *pathComponents = [NSArray arrayWithObjects: [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.mp4", nil];
    
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    NSMutableDictionary *recordSetting = [NSMutableDictionary new];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = true;
    [recorder prepareToRecord];
    
    // Set up the slider's initial settings
    playPositionSlider.minimumValue = 0;
    playPositionSlider.value = 0;
    [playPositionSlider setContinuous:YES];
    [playPositionSlider setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Stop the recording
- (IBAction)stopPressed:(id)sender {
    
    // If recording is recording then stop it
    if (recorder.isRecording)
        [recorder stop];
    
    // Stop the player if it is playing
    if (player.isPlaying)
    {
        [player stop];
        playPositionSlider.value = 0;
        playPositionSlider.enabled = NO;
    }
    
    // Make sure the audio session is not active
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO error:nil];
    
    // Make the stop button inactive since nothing is playing
    stopButton.enabled = NO;
}

// Play the recorded message
-(IBAction)playPressed:(id)sender {
    
    // Can't play back if the recorder is recording
    if (!recorder.recording)
    {
        // Set up the player
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        player.delegate = self;
        
        // Set up the slider to track the play time
        playPositionSlider.maximumValue = [player duration];
        [playPositionSlider setEnabled:YES];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
        [stopButton setEnabled:YES];
        
        // Finally play the captured audio
        [player prepareToPlay];
        [player play];
    }
}

// Strart recording or pause the recording
-(IBAction)recordPausePressed:(id)sender {
    
    if (player.playing)
        [player stop];
    
    // Change the RECORD/PAUSE button based on if the recorder is recording or not
    if (!recorder.recording)
    {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        [recorder record];
        [recordPauseButton setTitle:@"Pause" forState: UIControlStateNormal];
    }
    else
    {
        [recorder pause];
        [recordPauseButton setTitle:@"Resume" forState: UIControlStateNormal];
    }
    
    // Update the buttons
    stopButton.enabled = YES;
    playButton.enabled = NO;
    playPositionSlider.enabled = NO;
}

// Update the play time whenever the user moves the slider
-(IBAction)sliderPushed:(id)sender {
    [player stop];
    player.currentTime = playPositionSlider.value;
    [player prepareToPlay];
    [player play];
}

// Update the slider whenever the timer tracking the play time updates
-(void)updateTime: (NSTimer *) timer {
    
    if (player.isPlaying)
        playPositionSlider.value = player.currentTime;
}

// Change button status when the recorder is finished recording
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    
    stopButton.enabled = NO;
    playButton.enabled = YES;
}

// Show the user that the recording finished playing
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Done" message:@"Finished Playing the recording!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


@end
