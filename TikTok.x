#import "ShareImageViewController.h"

%hook AWEProfileImagePreviewView
- (id)initWithFrame:(CGRect)arg1 image:(id)arg2 imageURL:(id)arg3 backgroundColor:(id)arg4 userID:(id)arg5 type:(NSUInteger)arg6 {
    self = %orig;
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
        UIImageView *avatarImageView = self.avatar;

        if (avatarImageView) {
            NSString *imageUrlDescription = [avatarImageView description];
            if (imageUrlDescription && [imageUrlDescription isKindOfClass:[NSString class]]) {
                NSRange startRange = [imageUrlDescription rangeOfString:@"imageUrl="];
                NSRange endRange = [imageUrlDescription rangeOfString:@">"];

                if (startRange.location != NSNotFound && endRange.location != NSNotFound) {
                    NSUInteger startIndex = startRange.location + startRange.length;
                    NSUInteger endIndex = endRange.location;
                    NSRange urlRange = NSMakeRange(startIndex, endIndex - startIndex);
                    NSString *imageLink = [imageUrlDescription substringWithRange:urlRange];
                    NSURL *url = [NSURL URLWithString:imageLink];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    YYImage *webpImage = [YYImage imageWithData:data];
                        
                    UIViewController *currentController = [UIApplication sharedApplication].keyWindow.rootViewController;
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
    }
}
%end