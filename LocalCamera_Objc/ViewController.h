//
//  ViewController.h
//  LocalCamera_Objc
//
//  Created by SeongMinK on 2022/05/02.
//

#import <UIKit/UIKit.h>
#import <MetalKit/MetalKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController

@property AVCaptureSession *session;
@property (weak, nonatomic) IBOutlet MTKView *preview;

- (IBAction)onCameraToggleBtnClicked:(UIButton *)sender;

@end
