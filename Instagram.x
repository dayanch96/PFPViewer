#import "ShareImageViewController.h"

@interface IGImageSpecifier : NSObject
@property(readonly, nonatomic) NSURL *url;
@end

@interface IGImageView : UIImageView
@property(retain, nonatomic) IGImageSpecifier *imageSpecifier;
@end

@interface IGProfilePicturePreviewViewController : UIViewController
{ IGImageView *_profilePictureView; }
- (void)addHandleLongPress;
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
@end

%hook IGProfilePicturePreviewViewController
- (void)viewDidLoad {
    %orig;
    [self addHandleLongPress];
}

%new
- (void)addHandleLongPress {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.3;
    [self.view addGestureRecognizer:longPress];
}

%new
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        IGImageView *profilePictureView = [self valueForKey:@"_profilePictureView"];

        NSURL *url = profilePictureView.imageSpecifier.url;
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        NSData *pngData = UIImagePNGRepresentation(image);
        UIImage *pngImage = [UIImage imageWithData:pngData];
                    
        UIViewController *currentController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (currentController.presentedViewController) currentController = currentController.presentedViewController;

        if ([currentController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *currentNavController = (UINavigationController *)currentController;
            currentController = currentNavController.topViewController;
        }

        ShareImageViewController *shareVC = [[ShareImageViewController alloc] init];
        shareVC.imageToShare = pngImage;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:shareVC];
        navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0 green:29/255.0 blue:83/255.0 alpha:255/255.0];
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        [currentController presentViewController:navigationController animated:YES completion:nil];
    }
}
%end