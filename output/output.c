#include <stdio.h>
#include <string.h>

int main() {

    char msg[100];
    int a;
    int b;
    float x;
    float y;
    int ans1;
    float ans2;

    float t0, t1, t2;

    printf("Enter msg : ");
    scanf("%s", &msg);
    printf("You entered ");
    printf("%s\n", msg);
    a = 5;
    b = 2;
    x = 2.200000;
    y = 3.300000;
    t0 = a + b;
    ans1 = t0;
    t1 = x + y;
    ans2 = t1;
    printf("%d\n", ans1);
    printf("%f\n", ans2);
    if (a > b) {
    printf("a is greater than b\n");
    }
    while (b < 5) {
    printf("%d\n", b);
    t2 = b + 1;
    b = t2;
    }

    return 0;
}
