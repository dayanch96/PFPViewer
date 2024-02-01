#import "ShareImageViewController.h"

UIWindow *window;

static void showImageFromURL(id delegate, NSString *URLString) {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(size=)\\d+" options:0 error:nil];
    NSRange range = NSMakeRange(0, [URLString length]);
    URLString = [regex stringByReplacingMatchesInString:URLString options:0 range:range withTemplate:@"size=4096"];

    dispatch_async(dispatch_get_main_queue(), ^{
        UIImpactFeedbackGenerator *haptic = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [haptic prepare];
        [haptic impactOccurred];

        window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.windowLevel = UIWindowLevelAlert + 1;
        window.rootViewController = [[UIViewController alloc] init];
        [window makeKeyAndVisible];

        JGProgressHUD *downloadingHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        downloadingHUD.interactionType = JGProgressHUDInteractionTypeBlockNoTouches;
        [downloadingHUD showInView:window];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]];

            dispatch_async(dispatch_get_main_queue(), ^{
                [downloadingHUD dismissAnimated:YES];

                if (data) {
                    NSString *extension = [[URLString componentsSeparatedByString:@"?size="].firstObject pathExtension];

                    ShareImageViewController *shareVC = [[ShareImageViewController alloc] init];
                    shareVC.delegate = delegate;
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:shareVC];
                    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;

                    if (extension && [extension isEqualToString:@"gif"]) {
                        shareVC.gifDataToShare = data;
                    } else {
                        UIImage *image = [UIImage imageWithData:data];
                        NSData *pngData = UIImagePNGRepresentation(image);
                        UIImage *pngImage = [UIImage imageWithData:pngData];
                        shareVC.imageToShare = pngImage;
                    }

                    [window.rootViewController presentViewController:navigationController animated:YES completion:nil];
                }
            });
        });
    });
}

%hook DCDFastImageView
- (instancetype)initWithFrame:(CGRect)frame {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)];
    longPress.minimumPressDuration = 0.3;
    [self addGestureRecognizer:longPress];

    return %orig;
}

- (void)layoutSubviews {
    %orig;

    // Disable interaction with animated effect on profile picture
    if ([[self.source description] containsString:@"avatar-decoration-presets"]) {
        [self setUserInteractionEnabled:NO];
    }
}

%new
- (void)showImage:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {

        NSString *URLString = self.source.request.URL.absoluteString;
        if (URLString) showImageFromURL(self, URLString);
    }
}

%new
- (void)didVCDismiss {
    [window removeFromSuperview];
    window = nil;
}
%end

%hook RCTImageView
- (id)initWithBridge:(id)arg1 {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)];
    longPress.minimumPressDuration = 0.3;
    [self addGestureRecognizer:longPress];

    return %orig;
}

%new
- (void)showImage:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {

        RCTImageSource *source = self.imageSources[0];
        NSString *URLString = source.request.URL.absoluteString;
        if (URLString) showImageFromURL(self, URLString);
    }
}

%new
- (void)didVCDismiss {
    [window removeFromSuperview];
    window = nil;
}
%end
