//
//  ViewController.h
//  LocalCamera_Objc
//
//  Created by SeongMinK on 2022/05/02.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController

@property AVCaptureSession *session;
@property AVCaptureDevice *inputDevice;
@property AVCapturePhotoOutput *photoOutput;
@property (weak, nonatomic) IBOutlet UIImageView *preview;

- (IBAction)onCameraToggleBtnClicked:(UIButton *)sender;

@end
