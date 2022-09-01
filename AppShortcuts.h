#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class SBIconListView;
@interface SBIconListModel : NSObject
- (NSArray *)icons;
@end

@class SBSApplicationShortcutItem;
@interface SBIconView : UIView
@property (nonatomic, strong) id icon;
- (BOOL)isFolderIcon;
@end



@class UIWindow;

@interface PreferencesAppController : UIApplication
@property(nonatomic, readonly) NSArray<UIWindow *> *windows;
@end