#include <stdio.h>
#include <errno.h>
#define __LIBRARY__
#include <unistd.h>
#include <stdio.h>

#define __NR_iam 72
_syscall1(int, iam, const char *, name);

int main(int argc, char **argv)
{
    printf("%s\n", argv[1]);
    iam(argv[1]);
    return 0;
}