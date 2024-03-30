.PHONY: all clean lib

CXX?=g++
CC?=gcc

WARNINGS=-Wall -Wextra -Wno-char-subscripts \
         -Wpointer-arith -Wwrite-strings -Wdisabled-optimization \
         -Wformat -Wcast-align -Wno-unused-function -Wno-unused-parameter \
         -pedantic -Wunused-variable -Wno-attributes -Wno-pedantic -Wno-ignored-attributes \
         -Wno-missing-braces -Wno-unknown-pragmas

EXTRA?=
INCPLUS?=
EXTRA_LD?=
DBG:=
OS:=$(shell uname)
FLAGS=
GIT_VERSION := $(shell git describe --abbrev=4 --always)

OPT_MINUS_OPENMP= -O3 -funroll-loops \
    -pipe -fno-strict-aliasing -DUSE_PDQSORT \
    -DNOT_THREADSAFE -mpopcnt \
    $(FLAGS) $(EXTRA)

OPT=$(OPT_MINUS_OPENMP) # -lgomp /* sometimes needed */-lomp /* for clang */
ifneq (,$(findstring clang++,$(CXX)))
    OPT+=-fopenmp -lomp
else
    OPT+=-fopenmp
endif

XXFLAGS=-fno-rtti
CXXFLAGS=$(OPT) $(XXFLAGS) -std=c++17 $(WARNINGS) \
     -DDASHING_VERSION=\"$(GIT_VERSION)\"  -fdiagnostics-color=always

LIB=-ldl
LD=-L. $(EXTRA_LD)

ZSTD_INCLUDE_DIRS=bonsai/zstd/zlibWrapper bonsai/zstd/lib/common bonsai/zstd/lib
ZSTD_INCLUDE=$(patsubst %,-I%,$(ZSTD_INCLUDE_DIRS))
ZFLAGS=-DZWRAP_USE_ZSTD=1
ZCOMPILE_FLAGS=$(ZFLAGS) -lzstd

INCLUDE=-Ibonsai/clhash/include -I. -Ibonsai/zlib -Ibonsai/hll/libpopcnt -Iinclude -Ibonsai/circularqueue $(ZSTD_INCLUDE) $(INCPLUS) -Ibonsai/hll/vec -Ibonsai -Ibonsai/include/ \
    -Ibonsai/hll/include -Ibonsai/hll -Ibonsai/hll/include/sketch -Ibonsai/hll/vec -Ibonsai/hll/include/blaze/

# Object files
OBJS=$(patsubst %.c,%.o,$(wildcard src/*.c) bonsai/klib/kthread.o) $(patsubst %.cpp,%.o,$(wildcard src/*.cpp)) bonsai/klib/kstring.o clhash.o

# Name of library
LIB_NAME=libdashing.a

all: $(LIB_NAME)

$(LIB_NAME): $(OBJS)
    ar rcs $(LIB_NAME) $(OBJS)

%.o: %.cpp
    $(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -o $@

%.o: %.c
    $(CC) $(CXXFLAGS) $(INCLUDE) -c $< -o $@

clean:
    rm -f $(OBJS) $(LIB_NAME)
