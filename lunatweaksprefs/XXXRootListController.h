#import <Preferences/PSListController.h>
#import <Cephei/HBRespringController.h>

@interface XXXRootListController : PSListController

@end

@interface NSTask : NSObject
@property(copy)NSString* launchPath;
- (void)launch;
@end