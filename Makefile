.PHONY: all clean obj

CXX?=g++
CC?=gcc
OS:=$(shell uname)

WARNINGS=-Wall -Wextra -Wno-char-subscripts \
         -Wpointer-arith -Wwrite-strings -Wdisabled-optimization \
         -Wformat -Wcast-align -Wno-unused-function -Wno-unused-parameter \
         -pedantic -Wunused-variable -Wno-attributes -Wno-pedantic  -Wno-ignored-attributes \
         -Wno-missing-braces -Wno-unknown-pragmas

OPT_MINUS_OPENMP= -O3 -funroll-loops -pipe -fno-strict-aliasing -DUSE_PDQSORT \
                  -DNOT_THREADSAFE -mpopcnt

CXXFLAGS=$(OPT_MINUS_OPENMP) -std=c++17 $(WARNINGS) \
         -DDASHING_VERSION=\"$(shell git describe --abbrev=4 --always)\" -fdiagnostics-color=always

# Include directories
ZSTD_INCLUDE_DIRS=bonsai/zstd/zlibWrapper bonsai/zstd/lib/common bonsai/zstd/lib
INCLUDE=-Ibonsai/clhash/include -I. -Ibonsai/zlib -Ibonsai/hll/libpopcnt -Iinclude -Ibonsai/circularqueue \
        $(patsubst %,-I%,$(ZSTD_INCLUDE_DIRS)) -Ibonsai/hll/vec -Ibonsai -Ibonsai/include/ \
        -Ibonsai/hll/include -Ibonsai/hll -Ibonsai/hll/include/sketch -Ibonsai/hll/vec -Ibonsai/hll/include/blaze/

LIB=-ldl
LD=-L. 

# Object files
OBJS=$(patsubst %.c,%.o,$(wildcard src/*.c) bonsai/klib/kthread.o) \
     $(patsubst %.cpp,%.o,$(wildcard src/*.cpp)) bonsai/klib/kstring.o clhash.o

#was obj before (instead of dashing)
all: dashing

#was obj before
dashing: $(OBJS)

%.o: %.cpp
    $(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -o $@

%.o: %.c
    $(CC) $(CXXFLAGS) $(INCLUDE) -c $< -o $@

clean:
    rm -f $(OBJS) && cd bonsai/zstd && $(MAKE) clean && cd ../../bonsai/zlib && $(MAKE) clean && cd ../..
