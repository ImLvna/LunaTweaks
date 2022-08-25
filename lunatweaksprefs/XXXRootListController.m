#import <Foundation/Foundation.h>
#import "XXXRootListController.h"
#import <spawn.h>


UIBlurEffect* blur;
UIVisualEffectView* blurView;

@implementation XXXRootListController

//credit litten
 -(void)respring {

    blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
    [blurView setFrame:self.view.bounds];
    [blurView setAlpha:0.0];
    [[self view] addSubview:blurView];

    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [blurView setAlpha:1.0];
    } completion:^(BOOL finished) {
        [self respringUtil];
    }];

}
//credit litten
- (void)respringUtil {
    NSTask* task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/sbreload"];

    [HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=LunaTweaks"]];

    [task launch];

}
 -(void)userspace {

         pid_t pid;
         const char* args[] = {"sh", "-c", "echo alpine | sudo -S /usr/local/bin/rebootuserspace", NULL};
         posix_spawn(&pid, "/usr/bin/sh", NULL, NULL, (char* const*)args, NULL);

      }

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

@end
