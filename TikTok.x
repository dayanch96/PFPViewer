#import "ShareImageViewController.h"

%hook AWEProfileImagePreviewView
- (id)initWithFrame:(CGRect)arg1 image:(id)arg2 imageURL:(id)arg3 backgroundColor:(id)arg4 userID:(id)arg5 type:(NSUInteger)arg6 {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showPFP:)];
    longPress.minimumPressDuration = 0.3;
    [self addGestureRecognizer:longPress];

    return %orig;
}

%new
- (void)showPFP:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {

        NSURL *avatar = self.avatar.bd_baseImage.bd_webURL;
        if (avatar) {
            YYImage *webpImage = [YYImage imageWithData:[NSData dataWithContentsOfURL:avatar]];

            UIViewController *currentController = [[UIApplication sharedApplication] delegate].window.rootViewController;
            while (currentController.presentedViewController) currentController = currentController.presentedViewController;

            if ([currentController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *currentNavController = (UINavigationController *)currentController;
                currentController = currentNavController.topViewController;
            }

            ShareImageViewController *shareVC = [[ShareImageViewController alloc] init];
            shareVC.imageToShare = webpImage;
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:shareVC];
            navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0 green:29/255.0 blue:83/255.0 alpha:255/255.0];
            navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
            [currentController presentViewController:navigationController animated:YES completion:nil];
        }
    }
}
%end