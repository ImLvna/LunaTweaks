
#import <SpringBoard/SBDeviceApplicationSceneOverlayViewProvider.h>
#import <libobjc.A.dylib/FADigitalHealthDelegate.h>

@class FALockOutViewController, NSString;

@interface SBDeviceApplicationScreenTimeLockoutViewProvider : SBDeviceApplicationSceneOverlayViewProvider <FADigitalHealthDelegate> {

	FALockOutViewController* _lockoutViewController;
}
@property (readonly) unsigned long long hash; 
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
-(id)initWithSceneHandle:(id)arg1 delegate:(id)arg2 ;
-(void)_handleInstalledAppsChanged:(id)arg1 ;
-(void)_activateIfPossible;
-(void)_deactivateIfPossible;
-(id)_realOverlayViewController;
-(void)lockOutViewControllerDidFinishDismissing:(id)arg1 ;
-(void)dealloc;
@end
