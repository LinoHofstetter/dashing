#include "dashing.h"
#include "sketch_and_cmp.h"
using namespace bns;
#if HAS_AVX_512
#  pragma message("Building with AVX512 support")
#elif __AVX2__
#  pragma message("Building with AVX2 support")
#elif __SSE4_1__
#  pragma message("Building with SSE4.1 support")
#else
#  pragma message("Building with no vectorization support [this will likely fail]")
#endif


void version_info(char *argv[]) {
    std::fprintf(stderr, "Dashing version: %s\n", DASHING_VERSION);
    std::exit(1);
}

int dashing_main(int argc, char *argv[]) { //modified name of the main function to expose it
    bns::executable = argv[0];
    const std::unordered_map<std::string, int (*)(int, char**)> submap
{
    {"sketch", sketch_main},
    {"union", union_main},
    {"setdist", dist_main},
    {"dist", dist_main},
    {"cmp", dist_main},
    {"hll", hll_main},
    {"view", view_main},
    {"fold", fold_main},
    {"panel", panel_main},
    {"card", card_main},
    {"printmat", print_binary_main},
    {"dist_by_seq", dist_by_seq_main},
    {"cmp_by_seq", dist_by_seq_main},
    {"sketch_by_seq", sketch_by_seq_main},
    {"sbs", sketch_by_seq_main}
};

    std::fprintf(stderr, "Dashing version: %s\n", DASHING_VERSION);
    if(argc == 1) main_usage(argv);
    auto it = submap.find(argv[1]);
    if(it != submap.end()) return it->second(argc - 1, argv + 1);
    else {
        for(const char *const *p(argv + 1); *p; ++p) {
            std::string v(*p);
            std::transform(v.begin(), v.end(), v.begin(), [](auto c) {return std::tolower(c);});
            if(v == "-h" || v == "--help") main_usage(argv);
            if(v == "-v" || v == "--version") version_info(argv);
        }
        std::fprintf(stderr, "Usage: %s <subcommand> [options...]. Use %s <subcommand> for more options.\n"
                             "Subcommands:\n"
                              "  sketch\n"
                              "    Produces k-mer/minimizer sketches from genomes.\nTo sketch by sequence record rather than by file, see sketch_by_seq.\n"
                              "  sketch_by_seq\n"
                              "     Produces k-mer/minimizer sketches from a set of sequences from a sequence file. See cmp_by_seq for comparable distance calculation.\n"
                              "  cmp\n"
                              "       Compares sketches by options, including distance, similarity, and containment. cmp_by_seq sketches by sequence rather than by file.\n"
                              "  union\n"
                              "       Performs a union between sets of sketches\n"
                              "  view\n"
                              "       Emit register values for HLLs for human readability\n"
                              "  printmat\n"
                              "       Displays binary output\n"
                              " fold\n "
                              "       Compresses HLLs from a larger size to smaller sizes.\n"
                              "dist is also now a synonym for cmp, but this may be removed.\n"
                     , *argv, *argv);
        UNRECOVERABLE_ERROR(std::string("Invalid subcommand ") + argv[1] + " provided.");
    }
    return EXIT_FAILURE;
}

