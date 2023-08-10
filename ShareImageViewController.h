#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "YYImage/YYImage.h"
#import "FLAnimatedImage.h"

@interface _UITapticEngine : NSObject
- (void)actuateFeedback:(NSInteger)count;
@end

@interface UIDevice (Private)
- (_UITapticEngine *)_tapticEngine;
@end

@interface ShareImageViewController : UIViewController
@property (nonatomic, strong) UIImage *imageToShare;
@property (nonatomic, strong) NSData *gifDataToShare;
@end

@interface ShareImageViewController ()
@end

// Discord
// PFPs
@interface RCTImageSource : NSObject
@end

@interface DCDFastImageView : UIImageView
@property (nonatomic, strong) RCTImageSource *source;
- (void)addHandleLongPress;
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
@end

// Banners
@interface RCTImageView : UIImageView
@property (nonatomic, strong) NSArray *imageSources;
- (void)addHandleLongPress;
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
@end

// TikTok
@interface AWEProfileImagePreviewView: UIView
@property(strong, nonatomic, readwrite) UIImageView *avatar;
- (void)addHandleLongPress;
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
@end

// Twitch
@interface TWImageView : UIImageView
@property (nonatomic, strong) NSURL *url;
- (void)addHandleLongPress;
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
@end

// VK
// People you may know
@interface WAImageView : UIImageView
@property (nonatomic, strong) NSString *url;
@end

@interface DimmingButton : UIControl
- (void)addHandleLongPress;
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
- (WAImageView *)lookForWAImageView:(UIView *)view;
@end

//Old UI PFPs
@interface UserProfileMainPhoto : UIImageView
@property (nonatomic, strong) NSString *photoURL;
- (void)addHandleLongPress;
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
@end