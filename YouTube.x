#import "ShareImageViewController.h"

%hook _ASDisplayView
- (void)setKeepalive_node:(id)arg1 {
    %orig;
    NSString *description = [self description];
    if ([description containsString:@"ELMImageNode-View"] && [description containsString:@"eml.avatar"]) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savePFP:)];
        longPress.minimumPressDuration = 0.3;
        [self addGestureRecognizer:longPress];
    }
}

%new
- (void)savePFP:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {

        NSString *URLString = self.keepalive_node.URL.absoluteString;
        if (URLString) {
            NSRange sizeRange = [URLString rangeOfString:@"=s"];
            if (sizeRange.location != NSNotFound) {
                NSRange dashRange = [URLString rangeOfString:@"-" options:0 range:NSMakeRange(sizeRange.location, URLString.length - sizeRange.location)];
                if (dashRange.location != NSNotFound) {
                    NSString *newURLString = [URLString stringByReplacingCharactersInRange:NSMakeRange(sizeRange.location + 2, dashRange.location - sizeRange.location - 2) withString:@"1024"];
                    NSURL *PFPURL = [NSURL URLWithString:newURLString];

                    ShareImageViewController *shareVC = [[ShareImageViewController alloc] init];
                    shareVC.imageToShare = [UIImage imageWithData:[NSData dataWithContentsOfURL:PFPURL]];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:shareVC];
                    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
                    UIViewController *currentController = [[UIApplication sharedApplication] delegate].window.rootViewController;
                    [currentController presentViewController:navigationController animated:YES completion:nil];
                }
            }
        }
    }
}
%end