# GCC Compiler

################################################################################
#    Ccache
#

export CCACHE_DIR=/tmp/ccache/makefile/$(PROJ_NAME)
CCACHE=ccache

################################################################################
#    Toolchain
#

AS  = $(CCACHE) gcc -x assembler-with-cpp
CC  = $(CCACHE) gcc
CXX = $(CCACHE) g++
LD  = gcc
AR  = ar
SZ  = size
OC  = objcopy
NM  = nm

################################################################################
#    Flags
#

# Compiler errors and warnings
CPPFLAGS += \
            -Werror -Wall -Wextra -Wshadow \
            -Wpedantic -pedantic-errors -Wformat=2 -Wformat-truncation -Wundef \
            -Wcomments -Wmisleading-indentation \
            -Wstrict-aliasing -fstrict-aliasing \
            -Wduplicated-branches -Wduplicated-cond \
            -Wcast-align -Wdangling-else \
            -Wunused-parameter -Wimplicit-fallthrough -Wunused-function \
            -fno-common -Wdouble-promotion

# Linker warnings are treated as errors
LDFLAGS += -Wl,--fatal-warnings

CPPFLAGS += -Wmisleading-indentation -Wmaybe-uninitialized
# CPPFLAGS += -Wpadded

# Do not show more than a few errors at a time.
CPPFLAGS += -fmax-errors=5

CFLAGS += -Wmissing-prototypes # Valid only for C

# Generate stack usage information (*.su)
CPPFLAGS += -fstack-usage -Wstack-protector -Wstack-usage=50

# Eliminate unused code
CPPFLAGS += -ffunction-sections -fdata-sections
LDFLAGS += -Wl,--gc-sections

# Map file (replace elf suffix if it exists)
LDFLAGS += -Wl,-Map,$(if $(findstring .elf,$@),$(@:%.elf=%.map),$@.map)

# C language specification
CFLAGS += -std=c99

# C++ language specification
CXXFLAGS += -std=c++11

# Autodependency
CPPFLAGS += -MT $@ -MMD -MP -MF $(@:%.o=%.Td)

# Generate listing
CPPFLAGS += -Wa,-a,-ad,-alms=$(@:%.o=%.lst)

# Debug/Release flags
ifeq ($(TARGET),dbg)
  CPPFLAGS+=-g3 -Og -gdwarf-2 -DDEBUG
endif

ifeq ($(TARGET),rel)
  CPPFLAGS+=-O3 -DNDEBUG
endif

################################################################################
#    Configuration
#
