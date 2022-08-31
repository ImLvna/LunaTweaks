#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSUserDefaults+Private.h>
#import "AppShortcuts.h"

static BOOL isEnabled = YES;
static BOOL scShowFamily = YES;
static BOOL scIsDisabled = NO;
static BOOL scPinBypass = NO;
static BOOL isDebug = NO;


//function to toggle always allowed
static void toggleAlwaysAllowed(NSString *bundleID) {
    NSLog(@"toggleAlwaysAllowed");
}

@interface SBSApplicationShortcutIcon : NSObject
@end
@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic, retain) NSString *type;
@property (nonatomic, copy) NSString *localizedTitle;
@property (nonatomic, copy) SBSApplicationShortcutIcon *icon;
- (void)setIcon:(SBSApplicationShortcutIcon *)arg1;
@end
@interface SBSApplicationShortcutCustomImageIcon : SBSApplicationShortcutIcon
- (id)initWithImagePNGData:(id)arg1;
@end


%group debug
%hook SBIconView


- (NSArray *)applicationShortcutItems {
	if([self isFolderIcon]) return %orig;

	// Add shortcut item to activate editor
	// I found this really cool gist to allow me to do this, tyvm to the author <3
	// Link: https://gist.github.com/MTACS/8e26c4f430b27d6a1d2a11f0a828f250

    //i took this code from atria
    //https://github.com/ren7995/Atria/blob/3d72a00dd25f9c6ff5e59250974ce87c28af8aef/Hooks/IconView.xm
    
	NSMutableArray *items = [%orig mutableCopy];
	if(!items) items = [NSMutableArray new];


    SBSApplicationShortcutItem *item = [[objc_getClass("SBSApplicationShortcutItem") alloc] init];
	item.localizedTitle = @"Toggle Always Allowed";
	item.type = @"com.luna.lunatweaks.togglealways";

	// SFSymbols
	UIImage *image = [UIImage systemImageNamed:@"hourglass"];

	// Tint our image
	image = [image imageWithTintColor:[UIColor labelColor]];

	// Get data respresentation of the image
	NSData *iconData = UIImagePNGRepresentation(image);
	SBSApplicationShortcutCustomImageIcon *icon = [[objc_getClass("SBSApplicationShortcutCustomImageIcon") alloc] initWithImagePNGData:iconData];
	[item setIcon:icon];


	[items addObject:item];

	return items;
}

+ (void)activateShortcut:(SBSApplicationShortcutItem *)item withBundleIdentifier:(NSString *)bundleID forIconView:(SBIconView *)iconView {
	if([[item type] isEqualToString:@"com.luna.lunatweaks.togglealways"]) {
		toggleAlwaysAllowed(bundleID);
	} else {
		%orig;
	}
}
%end
%end


%group screentime
%hook SBIconView



- (bool)allowsBlockedForScreenTimeExpiration {
    return 0;
} 
- (void)setAllowsBlockedForScreenTimeExpiration:(bool)arg1 {
    arg1 = 0;
} 
%end


%hook SBNotificationBannerDestination
- (bool)_isBundleIdentifierBlockedForScreenTimeExpiration:(id)arg1 {
    arg1 = NULL;
    return %orig;
}
- (BOOL)_isContentSuppressedForNotificationRequest:(id)arg1 {
    arg1 = NULL;
    return %orig;
}
- (bool)_isBundleIdentifierBlockedForCommunicationPolicy:(id)arg1 {
    return 0;
} 
%end
%hook SBDeviceApplicationScreenTimeLockoutViewProvider
- (void)_activateIfPossible {
    return;
    
}
- (void)_deactivateIfPossible {
    return;
    
}
%end

//make color purple if its disabled
%hook _UIBatteryView
- (UIColor *)fillColor {
    return [UIColor systemPurpleColor];
}
%end



%hook SBApplication
- (bool)isTimedOutForIcon:(id)arg1 {
    return 0;
} 
%end

%hook SBMainFluidSwitcherLiveContentOverlayCoordinator
- (bool)_layoutStateContainsElementBlockedForScreenTimeExpiration:(id)arg1 {
    return 0;
} 
%end

%hook SBCommunicationPolicyManager
- (bool)shouldScreenTimeSuppressNotificationsForBundleIdentifier:(id)arg1 {
    return 0;
} 
%end

%hook SBNCAlertingController
- (bool)_shouldScreenTimeSuppressNotificationsForBundleIdentifier:(id)arg1 {
    return 0;
}
- (bool)_shouldScreenTimeSuppressNotificationRequest:(id)arg1 {
    return 0;
} 
- (bool)_isBundleIdentifierBlockedForScreenTimeExpiration:(id)arg1 {
    return 0;
} 
- (bool)_isBundleIdentifierBlockedForCommunicationPolicy:(id)arg1 {
    return 0;
} 
%end

%hook SBTestAutomationService
- (void)systemServiceServer:(id)arg1 client:(id)arg2 setApplicationBundleIdentifier:(id)arg3 blockedForScreenTime:(bool)arg4 {
    arg4 = 0;
    return %orig;
} 
%end



%hook SBFloatingFluidSwitcherLiveContentOverlayCoordinator
- (bool)_isLayoutElementBlockedForScreenTimeExpiration:(id)arg1 {
    return 0;
} 
%end

%hook _SBDMPolicyTestAppInfo
- (bool)isBlockedForScreenTimeExpiration {
    return 0;
} 
%end

%hook SBScreenTimeTestRecipe
+ (void)_setApplicationBundleIdentifiers:(id)arg1 blockedForScreenTimeExpiration:(bool)arg2 {
    arg2 = 0;
    return %orig;
} 
%end

%hook SBDashBoardApplicationInformer
- (bool)_isBundleIdentifierBlockedForScreenTimeExpiration:(id)arg1 {
    return 0;
} 
%end


%end

%group pinBypass
%hook STPINController
- (bool)_isPINValid:(id)arg1 {
    return 1;
} 
- (bool)_authenticateWithPIN:(id)arg1 forUser:(id)arg2 allowPasscodeRecovery:(bool)arg3 error:(id*)arg4 {
    return 1;
} 
%end

%hook STRestrictionsPINController
- (bool)validatePIN:(id)arg1 {
    return 1;
} 
%end

%hook STPINListViewController
- (bool)validatePIN:(id)arg1 forPINController:(id)arg2 {
    return 1;
} 
%end

%hook STLockoutRestrictionsPINController
+ (bool)isRestrictionsPasscodeSet {
    return 0;
} 
%end

%hook STLockoutPolicyController
- (bool)shouldAllowOneMoreMinute {
    return 1;
} 
%end
%end

%group family

%hook STUser
- (bool)isParent {
    return 1;
}
%end
%end

static void loadPrefs()
{
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.luna.lunatweaksprefs.plist"];
    if(prefs)
    {
        isEnabled = ( [prefs objectForKey:@"LunaTweaksIsEnabled"] ? [[prefs objectForKey:@"LunaTweaksIsEnabled"] boolValue] : isEnabled );
        scShowFamily = ( [prefs objectForKey:@"screentimefamily"] ? [[prefs objectForKey:@"screentimefamily"] boolValue ] : scShowFamily );
        scIsDisabled = ( [prefs objectForKey:@"screentimedisable"] ? [[prefs objectForKey:@"screentimedisable"] boolValue ] : scIsDisabled );
        scPinBypass = ( [prefs objectForKey:@"screentimepin"] ? [[prefs objectForKey:@"screentimepin"] boolValue ] : scPinBypass );
        isDebug = ( [prefs objectForKey:@"debug"] ? [[prefs objectForKey:@"debug"] boolValue ] : isDebug );
        NSLog(@"[LunaTweaks] Settings Updated");
        NSLog(@"[LunaTweaks] isEnabled: %@", isEnabled ? @"true" : @"false");
        NSLog(@"[LunaTweaks] scShowFamily: %@", scShowFamily ? @"true" : @"false");
        NSLog(@"[LunaTweaks] scIsDisabled: %@", scIsDisabled ? @"true" : @"false");
        NSLog(@"[LunaTweaks] scPinBypass: %@", scPinBypass ? @"true" : @"false");
        NSLog(@"[LunaTweaks] isDebug: %@", isDebug ? @"true" : @"false");
        if(!isEnabled) return;
        if(scIsDisabled) %init(screentime);
        if(scPinBypass) %init(pinBypass);
        if(scShowFamily) %init(family);
        if(isDebug) %init(debug);
    }
}

%ctor
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.luna.lunatweaksprefs/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}
