#include <stdio.h>

#define RB_USERSPACE    0x2000000000000000ULL
extern int reboot3(uint64_t arg);

int main(int argc, char *argv[]) {
	reboot3(RB_USERSPACE);
	return 1;
}
