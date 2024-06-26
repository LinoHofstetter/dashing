#ifndef DASHING_CORE_H
#define DASHING_CORE_H

#include "dashing.h"
#include "sketch_and_cmp.h"
#include <string>
#include <unordered_map>
#include <algorithm>
#include <cctype>

// Forward declarations of the functions referenced in the map

namespace bns {
    int sketch_main(int, char**);
    int union_main(int, char**);
    int dist_main(int, char**);
    int hll_main(int, char**);
    int view_main(int, char**);
    int fold_main(int, char**);
    int panel_main(int, char**);
    int card_main(int, char**);
    int print_binary_main(int, char**);
    int dist_by_seq_main(int, char**);
    int cmp_by_seq_main(int, char**);
    int sketch_by_seq_main(int, char**);
    
    
}

void version_info(char *argv[]);
int dashing_main(int argc, char *argv[]);


#endif // DASHING_CORE_H
