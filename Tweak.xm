#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSUserDefaults+Private.h>

static BOOL isEnabled = YES;
static BOOL scShowFamily = YES;
static BOOL scIsDisabled = NO;
static BOOL scPinBypass = NO;



%hook SBNotificationBannerDestination
- (bool)_isBundleIdentifierBlockedForScreenTimeExpiration:(id)arg1 {
    if(isEnabled && scIsDisabled) {
        NSLog(@"[LunaTweaks] (bool)_isBundleIdentifierBlockedForScreenTimeExpiration:(id)arg1 Called");
        arg1 = NULL;
    }
    return %orig;
}
%end
%hook SBNotificationBannerDestination
- (BOOL)_isContentSuppressedForNotificationRequest:(id)arg1 {
    if(isEnabled && scIsDisabled) {
        NSLog(@"[LunaTweaks] (BOOL)_isContentSuppressedForNotificationRequest:(id)arg1 Called");
        arg1 = NULL;
    }
    return %orig;
}
%end
%hook SBDeviceApplicationScreenTimeLockoutViewProvider
- (void)_activateIfPossible {
    if(!isEnabled && !scIsDisabled) {
        NSLog(@"[LunaTweaks] (void)_activateIfPossible Called");
        %orig;
    }
}
%end
%hook SBDeviceApplicationScreenTimeLockoutViewProvider
- (void)_deactivateIfPossible {
    if(!isEnabled && !scIsDisabled) {
        NSLog(@"[LunaTweaks] (void)_deactivateIfPossible Called");
        %orig;
    }
}
%end
%hook SBDeviceApplicationScreenTimeLockoutViewProvider
- (void)_handleInstalledAppsChanged:(id)arg1 {
    if(isEnabled && scIsDisabled) {
        NSLog(@"[LunaTweaks] (void)_handleInstalledAppsChanged:(id)arg1 Called");
    }
    %orig(arg1);
}
%end




%hook STPINController
- (bool)_isPINValid:(id)arg1 {
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
%end

%hook SBNCAlertingController
- (bool)_shouldScreenTimeSuppressNotificationRequest:(id)arg1 {
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

%hook SBNCAlertingController
- (bool)_isBundleIdentifierBlockedForScreenTimeExpiration:(id)arg1 {
    if(isEnabled && scIsDisabled) {
        return 0;
    }
    return %orig;
} 
%end

%hook SBNCAlertingController
- (bool)_isBundleIdentifierBlockedForCommunicationPolicy:(id)arg1 {
    if(isEnabled && scIsDisabled) {
        return 0;
    }
    return %orig;
} 
%end


%hook SBNotificationBannerDestination
- (bool)_isBundleIdentifierBlockedForCommunicationPolicy:(id)arg1 {
    if(isEnabled && scIsDisabled) {
        return 0;
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

%hook SBIconView
- (bool)allowsBlockedForScreenTimeExpiration {
    if(isEnabled && scIsDisabled) {
        return 0;
    }
    return %orig;
} 
%end

%hook SBIconView
- (void)setAllowsBlockedForScreenTimeExpiration:(bool)arg1 {
    if(isEnabled && scIsDisabled) {
        arg1 = 0;
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
