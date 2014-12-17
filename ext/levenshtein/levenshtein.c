# include <string.h>
# include <stdlib.h>
#include "levenshtein.h"

# ifdef LEV_CASE_INSENSITIVE
# include <ctype.h>
# define eq(x, y) (tolower(x) == tolower(y))
# else
# define eq(x, y) ((x) == (y))
# endif

static unsigned int min3(unsigned int x, unsigned int y, unsigned int z) {
        if (x > y)
                x = y;
        if (x > z)
                x = z;
        return x;
}

unsigned int levenshtein (const char *word1, const char *word2) {
        size_t len1 = strlen(word1),
                len2 = strlen(word2);

        /* strip common prefixes */
        while (len1 > 0 && len2 > 0 && eq(word1[0], word2[0]))
                word1++, word2++, len1--, len2--;

        /* handle degenerate cases */
        if (len1 == 0) return len2;
        if (len2 == 0) return len1;


        unsigned int v[len2 + 1];

        /* first row */
        for (unsigned int j = 0; j < len2 + 1; j++)
                v[j] = j;

        unsigned int cur = 0;
        for (unsigned int i = 1; i <= len1; i++) {
                /* first value of new row */
                unsigned int prev = i;
                for (unsigned int j = 1; j <= len2; j++) {
                        /*
                         * cost of replacement is 0 if the two chars are the same, otherwise 1.
                         */
                        unsigned int cost = !(eq(word1[i - 1], word2[j - 1]));
                        /* find the least cost of insertion, deletion, or replacement */
                        cur = min3(v[j] + 1, prev + 1, v[j - 1] + cost);
                        /* stash the previous row's cost in the column vector */
                        v[j - 1] = prev;
                        /* make the cost of the next transition current */
                        prev = cur;
                }
/* keep the final cost at the bottom of the column */
                v[len2] = cur;
        }
        return v[len2];
}

#ifdef DEBUG
#include <stdio.h>
#include "levenshtein.h"

int main (int argc, char **argv) {
        unsigned int distance;
        if (argc < 3) return -1;
        distance = levenshtein(argv[1], argv[2]);
        printf("%s vs %s: %u\n", argv[1], argv[2],distance);
}
#endif
