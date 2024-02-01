#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "YYImage/YYImage.h"
#import "JGProgressHUD/JGProgressHUD.h"

@interface _UITapticEngine : NSObject
- (void)actuateFeedback:(NSInteger)count;
@end

@interface UIDevice (Private)
- (_UITapticEngine *)_tapticEngine;
@end

@protocol ShareImageViewControllerDelegate <NSObject>
- (void)didVCDismiss;
@end

@interface ShareImageViewController : UIViewController
@property (nonatomic, weak) id<ShareImageViewControllerDelegate> delegate;
@property (nonatomic, strong) UIImage *imageToShare;
@property (nonatomic, strong) NSData *gifDataToShare;
@end

@interface ShareImageViewController ()
@end

// Discord
// PFPs
@interface RCTImageSource : NSObject
@property (nonatomic, copy, readonly) NSURLRequest *request;
@end

@interface DCDFastImageView : UIImageView <ShareImageViewControllerDelegate>
@property (nonatomic, strong) RCTImageSource *source;
- (void)showImage:(UILongPressGestureRecognizer *)sender;
- (void)didVCDismiss;
@end

// Banners
@interface RCTImageView : UIImageView <ShareImageViewControllerDelegate>
@property (nonatomic, strong) NSArray *imageSources;
- (void)showImage:(UILongPressGestureRecognizer *)sender;
- (void)didVCDismiss;
@end

// TikTok
@interface BDImage : UIImage
@property (nonatomic, strong, readwrite) NSURL *bd_webURL;
@end

@interface BDImageView : UIImageView
@property (nonatomic, strong, readwrite) BDImage *bd_baseImage;
@end

@interface AWEProfileImagePreviewView : UIView
@property (nonatomic, strong, readwrite) BDImageView *avatar;
- (void)showPFP:(UILongPressGestureRecognizer *)sender;
@end

// Twitch
@interface TWImageView : UIImageView
@property (nonatomic, strong, readwrite) UIImage *placeholder;
@property (nonatomic, copy, readwrite) NSURL *url;
- (void)showPFP:(UILongPressGestureRecognizer *)sender;
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

// YouTube
@interface ASNetworkImageNode : NSObject
@property (atomic, copy, readwrite) NSURL *URL;
@end

@interface ELMImageNode : ASNetworkImageNode
@end

@interface _ASDisplayView : UIView
@property (nonatomic, strong, readwrite) ELMImageNode *keepalive_node;
- (void)savePFP:(UILongPressGestureRecognizer *)sender;
@end