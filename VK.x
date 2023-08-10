#import "ShareImageViewController.h"

// People you may know
%hook DimmingButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = %orig(frame);
    if (self) [self addHandleLongPress];
    return self;
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
        [[UIDevice currentDevice]._tapticEngine actuateFeedback:1];
        WAImageView *imageView = [self lookForWAImageView:self];

        if (imageView) {
            NSString *avatarImageView = imageView.url;

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
}

%new
- (WAImageView *)lookForWAImageView:(UIView *)view {
    if ([view isKindOfClass:objc_lookUpClass("WAImageView")]) {
        return (WAImageView *)view;
    }

    for (UIView *subview in view.subviews) {
        WAImageView *imageView = [self lookForWAImageView:subview];
        if (imageView) return imageView;
    } return nil;
}
%end

// Modern UI PFPs
%hook ProfilePhotoView
- (BOOL)isUserInteractionEnabled { return YES; }
%end

// Old UI PFPs
%hook UserProfileMainPhoto
- (instancetype)initWithFrame:(CGRect)frame {
    self = %orig(frame);
    if (self) [self addHandleLongPress];
    return self;
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
        [[UIDevice currentDevice]._tapticEngine actuateFeedback:1];
        NSString *avatarImageView = self.photoURL;

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