//
//  ViewController.m
//  LocalCamera_Objc
//
//  Created by SeongMinK on 2022/05/02.
//

#import "ViewController.h"

@interface ViewController () {
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
    id<MTLTexture> _texture;

    CVMetalTextureCacheRef _textureCache;
}

@end

@implementation ViewController

@synthesize session;
@synthesize preview;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    preview.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    preview.contentMode = UIViewContentModeScaleAspectFit;
    
    _device = MTLCreateSystemDefaultDevice();
    preview.device = _device;
    
    CVMetalTextureCacheCreate(NULL, NULL, _device, NULL, &_textureCache);
    
    session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
                                                                     mediaType:AVMediaTypeVideo
                                                                      position:AVCaptureDevicePositionBack];
    
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
    
    if (videoInput) {
        if ([session canAddInput:videoInput]) {
            [session addInput:videoInput];
        }
    } else {
        NSLog(@"Error: %@", error);
    }
    
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [session addOutput:output];
    output.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32BGRA) };
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [preview.layer addSublayer:previewLayer];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        previewLayer.frame = self.preview.bounds;
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.session startRunning];
    });
}

- (void)drawInMTKView:(MTKView *)view {
    if (_texture) {
        id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
        
        [commandBuffer presentDrawable:view.currentDrawable];
        [commandBuffer commit];
        
        _texture = nil;
    }
}

- (IBAction)onCameraToggleBtnClicked:(UIButton *)sender {
    [session beginConfiguration];
    
    AVCaptureInput* currentCameraInput = [session.inputs objectAtIndex:0];
    [session removeInput:currentCameraInput];
    
    AVCaptureDevice *newCamera = nil;
    if (((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack) {
        newCamera = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
                                                       mediaType:AVMediaTypeVideo
                                                        position:AVCaptureDevicePositionFront];
    } else {
        newCamera = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
                                                       mediaType:AVMediaTypeVideo
                                                        position:AVCaptureDevicePositionBack];
    }
    
    NSError *err = nil;
    AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:&err];
    if (!newVideoInput || err) {
        NSLog(@"Error creating capture device input: %@", err.localizedDescription);
    } else {
        [session addInput:newVideoInput];
    }
    
    [session commitConfiguration];
}

@end
