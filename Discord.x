#import "ShareImageViewController.h"

%hook DCDFastImageView
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
        RCTImageSource *avatarImageView = self.source;

        if (avatarImageView) {
            NSString *imageUrlDescription = [avatarImageView description];
            if (imageUrlDescription && [imageUrlDescription isKindOfClass:[NSString class]]) {
                NSRange startRange = [imageUrlDescription rangeOfString:@"URL="];
                NSRange endRange = [imageUrlDescription rangeOfString:@", size"];

                if (startRange.location != NSNotFound && endRange.location != NSNotFound) {
                    NSUInteger startIndex = startRange.location + startRange.length;
                    NSUInteger endIndex = endRange.location;
                    NSRange urlRange = NSMakeRange(startIndex, endIndex - startIndex);
                    NSString *imageLink = [imageUrlDescription substringWithRange:urlRange];

                    NSArray *components = [imageLink componentsSeparatedByString:@"?size="];
                    NSString *newImageLink;
                    if (components.count >= 2) newImageLink = [NSString stringWithFormat:@"%@?size=1280", components.firstObject];

                    NSURL *url = [NSURL URLWithString:newImageLink];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    NSString *cleanedLink = [newImageLink componentsSeparatedByString:@"?size="].firstObject;

                    UIImage *image = [UIImage imageWithData:data];
                    NSString *extension = [cleanedLink pathExtension];

                    ShareImageViewController *shareVC = [[ShareImageViewController alloc] init];
                    shareVC.gifDataToShare = data;
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:shareVC];
                    navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0 green:29/255.0 blue:83/255.0 alpha:255/255.0];
                    UIViewController *currentController = [UIApplication sharedApplication].keyWindow.rootViewController;
                    [currentController presentViewController:navigationController animated:YES completion:nil];

                    if (extension && [extension isEqualToString:@"gif"]) {
                        shareVC.gifDataToShare = data;
                    } else {
                        NSData *pngData = UIImagePNGRepresentation(image);
                        UIImage *pngImage = [UIImage imageWithData:pngData];
                        shareVC.imageToShare = pngImage;
                    }
                }
            }
        }
    }
}
%end

%hook RCTImageView
- (id)initWithBridge:(id)arg1 {
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
        NSArray *avatarImageView = self.imageSources;

        if (avatarImageView) {
            NSString *imageUrlDescription = [avatarImageView description];
            if (imageUrlDescription && [imageUrlDescription isKindOfClass:[NSString class]]) {
                NSRange startRange = [imageUrlDescription rangeOfString:@"URL="];
                NSRange endRange = [imageUrlDescription rangeOfString:@", size"];

                if (startRange.location != NSNotFound && endRange.location != NSNotFound) {
                    NSUInteger startIndex = startRange.location + startRange.length;
                    NSUInteger endIndex = endRange.location;
                    NSRange urlRange = NSMakeRange(startIndex, endIndex - startIndex);
                    NSString *imageLink = [imageUrlDescription substringWithRange:urlRange];

                    NSArray *components = [imageLink componentsSeparatedByString:@"?size="];
                    NSString *newImageLink;
                    if (components.count >= 2) newImageLink = [NSString stringWithFormat:@"%@?size=1280", components.firstObject];

                    NSURL *url = [NSURL URLWithString:newImageLink];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    NSString *cleanedLink = [newImageLink componentsSeparatedByString:@"?size="].firstObject;
                    
                    UIImage *image = [UIImage imageWithData:data];
                    NSString *extension = [cleanedLink pathExtension];

                    ShareImageViewController *shareVC = [[ShareImageViewController alloc] init];
                    shareVC.gifDataToShare = data;
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:shareVC];
                    navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0 green:29/255.0 blue:83/255.0 alpha:255/255.0];
                    UIViewController *currentController = [UIApplication sharedApplication].keyWindow.rootViewController;
                    [currentController presentViewController:navigationController animated:YES completion:nil];

                    if (extension && [extension isEqualToString:@"gif"]) {
                        shareVC.gifDataToShare = data;
                    } else {
                        NSData *pngData = UIImagePNGRepresentation(image);
                        UIImage *pngImage = [UIImage imageWithData:pngData];
                        shareVC.imageToShare = pngImage;
                    }
                }
            }
        }
    }
}
%end
