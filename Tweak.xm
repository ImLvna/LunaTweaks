#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSUserDefaults+Private.h>
#import "AppShortcuts.h"

static BOOL isEnabled = YES;
static BOOL scShowFamily = YES;
static BOOL scIsDisabled = NO;
static BOOL scPinBypass = NO;


//function to toggle always allowed
static void toggleAlwaysAllowed() {
    NSLog(@"toggleAlwaysAllowed");
    %init(Class)
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


%hook SBIconView


- (NSArray *)applicationShortcutItems {
	if([self isFolderIcon]) return %orig;
    if(!isEnabled) return %orig;

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


- (bool)allowsBlockedForScreenTimeExpiration {
    if(isEnabled && scIsDisabled) {
        return 0;
    }
    return %orig;
} 
- (void)setAllowsBlockedForScreenTimeExpiration:(bool)arg1 {
    if(isEnabled && scIsDisabled) {
        arg1 = 0;
    }
    return %orig;
} 
%end


%hook SBNotificationBannerDestination
- (bool)_isBundleIdentifierBlockedForScreenTimeExpiration:(id)arg1 {
    if(isEnabled && scIsDisabled) {
        NSLog(@"[LunaTweaks] (bool)_isBundleIdentifierBlockedForScreenTimeExpiration:(id)arg1 Called");
        arg1 = NULL;
    }
    return %orig;
}
- (BOOL)_isContentSuppressedForNotificationRequest:(id)arg1 {
    if(isEnabled && scIsDisabled) {
        NSLog(@"[LunaTweaks] (BOOL)_isContentSuppressedForNotificationRequest:(id)arg1 Called");
        arg1 = NULL;
    }
    return %orig;
}
- (bool)_isBundleIdentifierBlockedForCommunicationPolicy:(id)arg1 {
    if(isEnabled && scIsDisabled) {
        return 0;
    }
    return %orig;
} 
%end
%hook SBDeviceApplicationScreenTimeLockoutViewProvider
- (void)_activateIfPossible {
    if(!isEnabled && !scIsDisabled) {
        return %orig;
    }
    NSLog(@"[LunaTweaks] (void)_activateIfPossible Called");
}
- (void)_deactivateIfPossible {
    if(!isEnabled && !scIsDisabled) {
        return %orig;
    }
    NSLog(@"[LunaTweaks] (void)_deactivateIfPossible Called");
}
%end

//make color purple if its disabled
%hook _UIBatteryView
- (UIColor *)fillColor {
    if(isEnabled && scIsDisabled) {
        return [UIColor systemPurpleColor];
    }
	return %orig;
}
%end



%hook STPINController
- (bool)_isPINValid:(id)arg1 {
    if(isEnabled && scPinBypass) {
        return 1;
    }
    return %orig;
} 
- (bool)_authenticateWithPIN:(id)arg1 forUser:(id)arg2 allowPasscodeRecovery:(bool)arg3 error:(id*)arg4 {
    if(isEnabled && scPinBypass) {
        return 1;
    }
    return %orig;
} 
%end

%hook STRestrictionsPINController
- (bool)validatePIN:(id)arg1 {
    if(isEnabled && scPinBypass) {
        return 1;
    }
    return %orig;
} 
%end

%hook STPINListViewController
- (bool)validatePIN:(id)arg1 forPINController:(id)arg2 {
    if(isEnabled && scPinBypass) {
        return 1;
    }
    return %orig;
} 
%end

%hook STLockoutRestrictionsPINController
+ (bool)isRestrictionsPasscodeSet {
    if(isEnabled && scPinBypass) {
        return 0;
    }
    return %orig;
} 
%end

%hook STLockoutPolicyController
- (bool)shouldAllowOneMoreMinute {
    if(isEnabled && scPinBypass) {
        return 1;
    }
    return %orig;
} 
%end


%hook SBApplication
- (bool)isTimedOutForIcon:(id)arg1 {
    if(isEnabled && scIsDisabled) {
        return 0;
    }
    return %orig;
} 
%end

%hook SBMainFluidSwitcherLiveContentOverlayCoordinator
- (bool)_layoutStateContainsElementBlockedForScreenTimeExpiration:(id)arg1 {
    if(isEnabled && scIsDisabled) {
        return 0;
    }
    return %orig;
} 
%end

%hook SBCommunicationPolicyManager
- (bool)shouldScreenTimeSuppressNotificationsForBundleIdentifier:(id)arg1 {
    if(isEnabled && scIsDisabled) {
        return 0;
    }
    return %orig;
} 
%end

%hook SBNCAlertingController
- (bool)_shouldScreenTimeSuppressNotificationsForBundleIdentifier:(id)arg1 {
    if(isEnabled && scIsDisabled) {
        return 0;
    }
    return %orig;
}
- (bool)_shouldScreenTimeSuppressNotificationRequest:(id)arg1 {
    if(isEnabled && scIsDisabled) {
        return 0;
    }
    return %orig;
} 
- (bool)_isBundleIdentifierBlockedForScreenTimeExpiration:(id)arg1 {
    if(isEnabled && scIsDisabled) {
        return 0;
    }
    return %orig;
} 
- (bool)_isBundleIdentifierBlockedForCommunicationPolicy:(id)arg1 {
    if(isEnabled && scIsDisabled) {
        return 0;
    }
    return %orig;
} 
%end

%hook SBTestAutomationService
- (void)systemServiceServer:(id)arg1 client:(id)arg2 setApplicationBundleIdentifier:(id)arg3 blockedForScreenTime:(bool)arg4 {
    if(isEnabled && scIsDisabled) {
        arg4 = 0;
    }
    return %orig;
} 
%end



%hook SBFloatingFluidSwitcherLiveContentOverlayCoordinator
- (bool)_isLayoutElementBlockedForScreenTimeExpiration:(id)arg1 {
    if(isEnabled && scIsDisabled) {
        return 0;
    }
    return %orig;
} 
%end

%hook _SBDMPolicyTestAppInfo
- (bool)isBlockedForScreenTimeExpiration {
    if(isEnabled && scIsDisabled) {
        return 0;
    }
    return %orig;
} 
%end

%hook SBScreenTimeTestRecipe
+ (void)_setApplicationBundleIdentifiers:(id)arg1 blockedForScreenTimeExpiration:(bool)arg2 {
    if(isEnabled && scIsDisabled) {
        arg2 = 0;
    }
    return %orig;
} 
%end

%hook SBDashBoardApplicationInformer
- (bool)_isBundleIdentifierBlockedForScreenTimeExpiration:(id)arg1 {
    if(isEnabled && scIsDisabled) {
        return 0;
    }
    return %orig;
} 
%end





%hook STUser
- (bool)isParent {
    if(isEnabled && scShowFamily) {
        NSLog(@"[LunaTweaks] (bool)isParent Called");
        return 1;
    }
    return %orig;
}
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
        NSLog(@"[LunaTweaks] Settings Updated");
        NSLog(@"[LunaTweaks] isEnabled: %@", isEnabled ? @"true" : @"false");
        NSLog(@"[LunaTweaks] scShowFamily: %@", scShowFamily ? @"true" : @"false");
        NSLog(@"[LunaTweaks] scIsDisabled: %@", scIsDisabled ? @"true" : @"false");
    }
}

%ctor
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.luna.lunatweaksprefs/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}
