#import <Foundation/Foundation.h>
#import "XXXRootListController.h"
#import <spawn.h>

@implementation XXXRootListController
 -(void)respring {

         pid_t pid;
         const char* args[] = {"killall", "-9", "backboardd", NULL};
         posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);

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
