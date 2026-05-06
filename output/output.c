#include <stdio.h>
#include <string.h>

int main() {

    int a;
    int i;

    int t0, t1;

    printf("Enter any number : ");
    scanf("%d", &a);
    i = 1;
    while (i <= 10) {
    t0 = a * i;
    printf("%d\n", t0);
    t1 = i + 1;
    i = t1;
    }

    return 0;
}
