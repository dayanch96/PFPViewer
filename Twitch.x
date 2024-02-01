#import "ShareImageViewController.h"

%hook TWImageView
- (void)layoutSubviews {
    %orig;

    if ([[((TWImageView *)self).placeholder description] containsString:@"avatar_placeholder"]) {
        ((TWImageView *)self).userInteractionEnabled = YES;

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showPFP:)];
        longPress.minimumPressDuration = 0.3;
        [((TWImageView *)self) addGestureRecognizer:longPress];
    }
}

%new
- (void)showPFP:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {

        NSURL *imageURL = ((TWImageView *)self).url;
        if (imageURL) {
            ShareImageViewController *shareVC = [[ShareImageViewController alloc] init];
            shareVC.imageToShare = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:shareVC];
            navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
            [[[UIApplication sharedApplication] delegate].window.rootViewController presentViewController:navigationController animated:YES completion:nil];
        }
    }
}
%end

%ctor {
    %init(TWImageView = objc_getClass("TwitchCoreUI.TWImageView"));
}