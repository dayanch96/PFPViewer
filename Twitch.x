#import "ShareImageViewController.h"

%hook TWImageView
- (void)layoutSubviews {
    %orig;
    [((TWImageView *)self) addHandleLongPress];
}

%new
- (void)addHandleLongPress {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.3;
    [self addGestureRecognizer:longPress];
}

%new
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        TWImageView *imageView = (TWImageView *)self;
        NSURL *avatarImageView = imageView.url;

        if (avatarImageView) {
            NSString *imageUrlDescription = [avatarImageView description];
            if (imageUrlDescription && [imageUrlDescription isKindOfClass:[NSString class]]) {
                NSURL *url = [NSURL URLWithString:imageUrlDescription];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:data];
                NSData *pngData = UIImagePNGRepresentation(image);
                UIImage *pngImage = [UIImage imageWithData:pngData];
                    
                ShareImageViewController *shareVC = [[ShareImageViewController alloc] init];
                shareVC.imageToShare = pngImage;
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:shareVC];
                navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0 green:29/255.0 blue:83/255.0 alpha:255/255.0];
                navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
                UIViewController *currentController = [UIApplication sharedApplication].keyWindow.rootViewController;
                [currentController presentViewController:navigationController animated:YES completion:nil];
            }
        }
    }
}
%end

%ctor {
    %init(TWImageView = objc_getClass("TwitchCoreUI.TWImageView"));
}