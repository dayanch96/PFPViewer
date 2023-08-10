#import "ShareImageViewController.h"

@implementation ShareImageViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"xmark"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(closeButtonTapped:)];

    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"square.and.arrow.up"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(shareButtonTapped:)];    

    self.title = @"💕";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = dismissButton;
    self.navigationItem.rightBarButtonItem = shareButton;
    
    [[UIDevice currentDevice]._tapticEngine actuateFeedback:1];
    
    if (self.gifDataToShare) {
        FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] initWithFrame:self.view.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:self.gifDataToShare];
        [self.view addSubview:imageView];
    }

    if ([self.imageToShare isKindOfClass:[YYImage class]] && ((YYImage *)self.imageToShare).animatedImageData) {
        YYAnimatedImageView *animatedImageView = [[YYAnimatedImageView alloc] initWithImage:(YYImage *)self.imageToShare];
        animatedImageView.frame = self.view.bounds;
        animatedImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:animatedImageView];
    } else {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = (UIImage *)self.imageToShare;
        [self.view addSubview:imageView];
    }
}

- (void)closeButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareButtonTapped:(id)sender {
    if ([self.imageToShare isKindOfClass:[YYImage class]] && ((YYImage *)self.imageToShare).animatedImageData) {
        NSData *animatedWebPData = ((YYImage *)self.imageToShare).animatedImageData;

        // Decode animated webp since Photos doesnt support it ;D
        YYImageDecoder *decoder = [YYImageDecoder decoderWithData:animatedWebPData scale:[UIScreen mainScreen].scale];
        NSMutableArray *frames = [NSMutableArray new];
        for (NSUInteger i = 0; i < decoder.frameCount; i++) {
            YYImageFrame *frame = [decoder frameAtIndex:i decodeForDisplay:YES];
            if (frame) {
                [frames addObject:frame];
            }
        }

        // Create gif from decoded webp frames
        YYImageEncoder *gifEncoder = [[YYImageEncoder alloc] initWithType:YYImageTypeGIF];
        gifEncoder.loopCount = 0;
        for (YYImageFrame *frame in frames) {
            [gifEncoder addImage:frame.image duration:frame.duration];
        }
        NSData *animatedGIFData = [gifEncoder encode];

        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[animatedGIFData] applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    } else {
        NSData *imageData;
        if ([self.imageToShare isKindOfClass:[UIImage class]]) {
            imageData = UIImagePNGRepresentation((UIImage *)self.imageToShare);
        } else {
            imageData = (NSData *)self.imageToShare;
        }

        NSArray *activityItems = self.gifDataToShare ? @[self.gifDataToShare] : @[imageData];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}
@end
