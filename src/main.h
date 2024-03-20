// main.h -> created this file myself

#ifndef MAIN_H
#define MAIN_H

#include <unordered_map>
#include <string>

namespace bns {
    // Assuming executable and other necessary items are defined elsewhere and need to be accessible.
    extern std::string executable;

    // Function prototypes that might be called from outside or are otherwise relevant for inclusion.
    int dashing_main(int argc, char *argv[]);
    void version_info(char *argv[]);

    // You might need to include prototypes for any other functions you expect to call directly from outside,
    // or for any global variables you need to access.
}

#endif // MAIN_H
