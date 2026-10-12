#include <cstdio>
#include <cstdlib>
#include "moving_max.h"

int main() {
    int in[N_SAMPLES], out[N_SAMPLES];
    
    for (int i = 0; i < N_SAMPLES; i++) {
        in[i] = (rand() % 2001) - 1000;
    }

    moving_max(in, out);

    int errors = 0;
    for (int n = 0; n < N_SAMPLES; n++) {
        int start = (n - (WINDOW - 1) < 0) ? 0 : n - (WINDOW - 1);
        int ref = in[start];
        for (int k = start + 1; k <= n; k++) {
            if (in[k] > ref)
                ref = in[k];
        }
        if (ref != out[n])
        {
            printf("ERR n=%d: got %d, expecred %d\n", n, out[n], ref);
            errors++;
        }
    }
    printf(errors ? "FAIL (%d errors)\n" : "PASS\n", errors);
    return errors ? 1 : 0;
}