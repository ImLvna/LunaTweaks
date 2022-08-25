#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <Foundation/NSUserDefaults+Private.h>

static BOOL isEnabled = YES;
static BOOL scShowFamily = YES;
static BOOL scIsDisabled = NO;



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
    if(isEnabled && scIsDisabled) {
    } else {
        NSLog(@"[LunaTweaks] (void)_activateIfPossible Called");
        %orig;
    }
}
%end
%hook SBDeviceApplicationScreenTimeLockoutViewProvider
- (void)_deactivateIfPossible {
    if(isEnabled && scIsDisabled) {
    } else {
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
