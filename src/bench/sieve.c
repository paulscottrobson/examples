#include <stdbool.h>
#include <stdint.h>
// #include <stdio.h>

#define size 8190
uint8_t flags[size + 1]; // marks primes, 0 unused

const uint8_t cIter = 50;
uint16_t i, prime, k, count, iter;

int main()
{
    // printf("%d iterations\n", cIter);
    __asm__("lda %v", cIter);
    __asm__("sta $e0");

    for (iter = 1; iter <= cIter; iter++)
    {
        __asm__("lda %v", iter);
        __asm__("sta $e1");

        count = 0; // 0 primes so far
        for (i = 1; i <= size; i++)
            flags[i] = 1; // all assumed prime

        for (i = 2; i <= size; i++)
        { // have to start with 2
            if (flags[i])
            { // if its prime
                prime = i;
                k = prime + prime;
                while (k <= size)
                {
                    flags[k] = false; // mark multiples as not prime
                    k += prime;
                }
                count = count + 1; // found one more
            }
        }
    }
    // printf("%d primes\n", count);
    __asm__("lda %v", count);
    __asm__("sta $e0");
    __asm__("lda %v + 1", count);
    __asm__("sta $e1");

    // halt CPU
    __asm__("lda #$FF");
    __asm__("sta $fff1");

    while (true)
    {
    }
}
