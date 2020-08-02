################################################################################
#
#
# Usage:
#
#    make
#    make PORT_NAME=<name> TARGET=<dbg/rel>
#

#SEC=5
#SEC=$(shell python -c 'from random import randint; print(randint(1, 5));')
#	sleep $(SEC)
#	@$(ECHO_N) " Slept for $(SEC) sec "

#	echo "RV: $${PIPESTATUS[0]}"
#	if [ "$${PIPESTATUS[0]}" -ne "0" ]; then \
#	  ${ECHO_E} ${RED}"Build Fail!!!\n"${RESET}; \
#	  exit 1; \
#	fi

#$(MAKECMDGOALS)

#GCC_EXISTS :=            $(shell command -v gcc 2> /dev/null)
#GPP_EXISTS :=            $(shell command -v g++ 2> /dev/null)
#GDB_EXISTS :=            $(shell command -v gdb 2> /dev/null)
#VALGRIND_EXISTS :=       $(shell command -v valgrind 2> /dev/null)
#SED_EXISTS :=            $(shell command -v sed 2> /dev/null)
#PERL_EXISTS :=           $(shell command -v perl 2> /dev/null)
#GIT_EXISTS :=            $(shell command -v git 2> /dev/null)
#DOXYGEN_EXISTS :=        $(shell command -v doxygen 2> /dev/null)
#DOT_EXISTS :=            $(shell command -v dot 2> /dev/null)
#JLINK_EXISTS :=          $(shell command -v JLinkExe 2> /dev/null)
#SALEAE_EXISTS :=         $(shell command -v Saleae 2> /dev/null)
#PICOCOM_EXISTS :=        $(shell command -v picocom 2> /dev/null)
#FIREFOX_EXISTS :=        $(shell command -v firefox 2> /dev/null)
#FLINT_EXISTS :=          $(shell command -v flint 2> /dev/null)

# We need sed, check if it exists
#ifndef SED_EXISTS
#	$(error "Please install 'sed' scripting language!")
#endif

# Project version
#ifdef GIT_EXISTS
#  PROJECT_NUMBER ?=      $(shell git describe --always \
#                         --dirty=" (with uncommitted changes)" --long --tags)
#endif


# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
# Credits to: https://gist.github.com/prwhite/8168133
#HELP_FUNC := \
#        %help; \
#        while(<>) { \
#                if(/^([a-z0-9_-]+):.*\#\#(?:@(\w+))?\s(.*)$$/) { \
#                        push(@{$$help{$$2}}, [$$1, $$3]); \
#                } \
#        }; \
#        print "Usage: make $(TPUT_YELLOW)[target]$(TPUT_RESET)\n\n"; \
#        for ( sort keys %help ) { \
#                print "$(TPUT_WHITE)$$_:$(TPUT_RESET)\n"; \
#                printf("  $(TPUT_YELLOW)%-20s$(TPUT_RESET) \
#                        $(TPUT_GREEN)%s$(TPUT_RESET)\n", $$_->[0], \
#                        $$_->[1]) for @{$$help{$$_}}; \
#                print "\n"; \
#        }

#TEST_CXXFLAGS =          -I"$(CPPUTEST_DIR)/include/"\
#                         -I"$(CPPUTEST_DIR)/include/CppUTest/MemoryLeakDetectorNewMacros.h"

#TEST_LDFLAGS =           -L"$(CPPUTEST_DIR)/cpputest_build/lib/"\
#                         -lCppUTest\
#                         -lCppUTestExt

#.PHONY: runTests
#runTests: ##@tests Run all tests.
#runTests: $(BIN_DIR)$(HOST_DIR)$(EXEC)_runTests
#	@$(ECHO)
#	@./$< -c | $(SED) 's/^/\t/'


#.PHONY: help
#help: ##@options Shows a list of all available make options.
#ifndef PERL_EXISTS
#	$(warning "Please set variable 'COLOR' to NO!")
#endif
#	@perl                 -e '$(HELP_FUNC)' $(MAKEFILE_LIST)

#..............................................................................#
#	Documentation

# Get version number from git
# https://christianhujer.github.io/Git-Version-in-Doxygen/
# TODO: Add port/ and build for TARGET_DIR
#.PHONY: doc
#doc: ##@doc Generates documentation.
#doc: export PROJECT_NUMBER ?= "Beta"
#doc: export PROJECT_NAME ?=   "Untitled"
#doc: export PROJECT_BRIEF ?=  ""
#doc:
#	$(DOCUMENTATION)
#	$(MKDIR_P)            $(DOC_DIR)html
#	@(cd conf/doxygen/ && doxygen)
#
#.PHONY: show
#show: ##@doc Shows documentation.
#show: doc
#ifdef FIREFOX_EXISTS
#	@firefox $(DOC_DIR)html/index.html >>/dev/null
#else
#	$(warning "Please install 'chromium-browser'!")
#endif

#TODO: Build with the same flags gcc compiler!
#.PHONY: lint
#lint: ##@analysis Lint static analysis (flexelint).
#lint: version
#ifndef FLINT_EXISTS
#	$(error "Please install 'flint'!")
#endif
#	@$(ECHO)
#	@$(MKDIR_P)           $(TMP_DIR)
#	@make                 -C $(TMP_DIR) \
#                              -f $(PC_LINT_DIR)/config/compiler/co-gcc.mak \
#                              CC_BIN=$(CC_HOST) \
#                              GXX_BIN=$(CXX_HOST) \
#                              CFLAGS=$(HOST_CFLAGS) \
#                              CXXFLAGS=$(HOST_CXXFLAGS) \
#                              CPPFLAGS= \
#                              COMMON_FLAGS= \
#                              > /dev/null
#	@$(FLINT)	      -w1 -t4 \
#                              -i$(TMP_DIR) \
#                              -i$(PC_LINT_DIR)/config/author \
#                              -i$(PC_LINT_DIR)/config/compiler \
#                              -i$(PC_LINT_DIR)/config/environment \
#                              co-gcc.lnt \
#                              env-posix.lnt \
#                              $(INCLUDES) \
#                              $(HOST_C_SRCs)
#	@$(ECHO)
#
#.PHONY: valgrind
#valgrind: ##@analysis Valgrind dynamic analysis.
#valgrind: build
#ifndef VALGRIND_EXISTS
#	$(error "Please install 'valgrind' dynamical analyser!")
#endif
#	@valgrind             $(BIN_DIR)$(HOST_DIR)$(EXEC)
#
#.PHONY: todo
#todo: ##@analysis Check for programmer notes in code.
#	@egrep                -nr -Rw --color 'bug|BUG|Bug'    $(SRC_DIR) $(INC_DIR) port/ || true
#	@egrep                -nr -Rw --color 'todo|TODO|Todo' $(SRC_DIR) $(INC_DIR) port/ || true
#	@egrep                -nr -Rw --color 'test|TEST|Test' $(SRC_DIR) $(INC_DIR) port/ || true


################################################################################
#    Makefile & Shell
#

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
.DEFAULT_GOAL = all

#.................................................
#    Check GNU Make version

# We use GNU Make
VERSION := $(shell $(MAKE) --version)
ifneq ($(firstword $(VERSION)),GNU)
  $(error GNU Make is required)
endif

# Minimum working version
MAKE_VERSION_NEEDED := 4.1
MAKE_VERSION_TEST   := $(filter $(MAKE_VERSION_NEEDED),$(firstword $(sort $(MAKE_VERSION) $(MAKE_VERSION_NEEDED))))
ifndef MAKE_VERSION_TEST
  $(error GNU Make is needed at least version $(MAKE_VERSION_NEEDED))
endif

#.................................................
#    Parallel make

#NPROCS    := $(shell echo $$(($(shell grep -c processor /proc/cpuinfo)+1)))
#MAKEFLAGS += --jobs=$(NPROCS)
#MAKEFLAGS += --output-sync=target
#MAKEFLAGS += --output-sync=recurse


################################################################################
#    Project
#

#.................................................
#    Project's name

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR  := $(dir $(MKFILE_PATH))
PROJ_NAME   := $(shell basename $(MKFILE_DIR))

#.................................................
#    Host's OS

ifdef SYSTEMROOT
  MACHINE = win32
  $(error Windows compatibility is not verified)
else
  ifeq ($(shell uname), Linux)
    MACHINE = posix
  else
    $(error Makefile does not support this OS)
  endif
endif

#.................................................
#    Validate build configuration options (TARGET)

TARGET ?= dbg
ifneq ($(TARGET),dbg)
  ifneq ($(TARGET),rel)
    $(error "TARGET" variable can not be "$(TARGET)")
  endif
endif


#.................................................
#    Detect and validate ports (PORT_NAME)

AVAILABLE_PORTS   := $(sort $(patsubst port/%/,%,$(dir $(wildcard port/*/.))))
PORT_NAME_ISVALID := $(findstring $(PORT_NAME),$(AVAILABLE_PORTS))

# Validate PORT_NAME
ifdef PORT_NAME
  ifndef PORT_NAME_ISVALID
    $(error '$(PORT_NAME)' is an invalid port name)
  endif
endif

################################################################################
#    TOOLS
#

ECHO     := echo
ECHO_E   := echo -e
ECHO_N   := echo -n
ECHO_NE  := echo -ne
RM_RF    := rm -rf
MKDIR_P  := mkdir -p
MV_F     := mv -f
TOUCH    := touch
TEE      := tee
XARGS_R0 := xargs -r -0
TPUT     := tput
GTAGS    := gtags

################################################################################
#    Default toolchain
#

AS  = gcc -x assembler-with-cpp
CC  = gcc
CXX = g++
LD  = gcc
SZ  = size
OC  = objcopy
NM  = nm

CPPFLAGS =
ASFLAGS  =
CFLAGS   =
CXXFLAGS =
LDFLAGS  =


################################################################################
#    Colors
#

COLORS :=$(shell $(TPUT) colors 2> /dev/null)

ifneq ($(shell test $(COLORS) -ge 8; echo $$?),0)
  # Reset
  RESET  := ''

  # Regular Colors
  BLACK  := ''
  RED    := ''
  GREEN  := ''
  YELLOW := ''
  BLUE   := ''
  PURPLE := ''
  CYAN   := ''
  WHITE  := ''
else
  # Reset
  RESET  := '\033[0m'

  # Regular Colors
  BLACK  := '\033[0;30m'
  RED    := '\033[0;31m'
  GREEN  := '\033[0;32m'
  YELLOW := '\033[0;33m'
  BLUE   := '\033[0;34m'
  PURPLE := '\033[0;35m'
  CYAN   := '\033[0;36m'
  WHITE  := '\033[0;37m'
endif

################################################################################
#    Files
#

#.................................................
#    Auxiliary files that build depends on

AUX = Makefile compiler.mk

ifdef PORT_NAME
  ifneq (,$(wildcard port/$(PORT_NAME)/Makefile))
    AUX += port/$(PORT_NAME)/Makefile
  endif
endif

#.................................................
#    Source

AS_SRCs  += $(shell find "src/" -name "*.[s|S]")
C_SRCs   += $(shell find "src/" -name "*.[c|C]")
CXX_SRCs += $(shell find "src/" -name "*.cpp")

ifdef PORT_NAME
  AS_SRCs  += $(shell find "port/$(PORT_NAME)/" -name "*.[s|S]")
  C_SRCs   += $(shell find "port/$(PORT_NAME)/" -name "*.[c|C]")
  CXX_SRCs += $(shell find "port/$(PORT_NAME)/" -name "*.cpp")
endif

AS_SRCs  := $(sort $(AS_SRCs))
C_SRCs   := $(sort $(C_SRCs))
CXX_SRCs := $(sort $(CXX_SRCs))

#.................................................
#    Source

ifdef PORT_NAME
  ifdef TARGET
    BIN_OUTDIR := bin/$(PORT_NAME)/$(TARGET)/
    OBJ_OUTDIR := obj/$(PORT_NAME)/$(TARGET)/
  else
    BIN_OUTDIR := bin/$(PORT_NAME)/
    OBJ_OUTDIR := obj/$(PORT_NAME)/
  endif
else
  BIN_OUTDIR   := bin/
  OBJ_OUTDIR   := obj/
endif

OBJS=  $(sort $(AS_SRCs:%.s=$(OBJ_OUTDIR)%.o))
OBJS+= $(sort $(C_SRCs:%.c=$(OBJ_OUTDIR)%.o))
OBJS+= $(sort $(CXX_SRCs:%.cpp=$(OBJ_OUTDIR)%.o))


#.................................................
#    Includes

CPPFLAGS+=-Iinc/

ifdef PORT_NAME
  CPPFLAGS+=-Iport/
endif

################################################################################
#    Compiler
#

-include compiler.mk

ifdef PORT_NAME
  -include port/$(PORT_NAME)/Makefile
endif

COMPILE.AS  ?= $(AS)  -c $< -o $@ $(CPPFLAGS) $(ASFLAGS)
COMPILE.CC  ?= $(CC)  -c $< -o $@ $(CPPFLAGS) $(CFLAGS)
COMPILE.CXX ?= $(CXX) -c $< -o $@ $(CPPFLAGS) $(CXXFLAGS)
LINK        ?= $(LD)     $^ -o $@ $(CPPFLAGS) $(LDFLAGS)

################################################################################
#    Rules
#

#.................................................
#    STM32 HAL drivers

.PHONY: all
all: build
	@$(ECHO_E) $(GREEN)"Build finished succesfully"$(RESET)


.PHONY: version
version:
	@$(ECHO_NE) $(BLUE)"Version "$(RESET)
	@./scripts/get_version.sh 1>/dev/null
	@$(ECHO_E) $(GREEN)"OK"$(RESET)


.PHONY: tags
tags:
	@$(ECHO_NE) $(BLUE)"GTAGS "$(RESET)
#	@$(GTAGS) -c --gtagslabel=new-ctags -i
#	@$(ECHO_E) $(GREEN)"OK"$(RESET)
	@$(ECHO_E) $(YELLOW)"Disabled"$(RESET)


.PHONY: check
check:
# Validate that if ports are available, make is run with PORT_NAME
ifndef PORT_NAME
  ifdef AVAILABLE_PORTS
	$(info  Ports are detected. Options are '$(AVAILABLE_PORTS)')
	$(info )
	$(error Please run make like so 'make PORT_NAME=<port name>')
  endif
endif

.PHONY: build
build: check\
       version\
       tags\
       $(BIN_OUTDIR)$(PROJ_NAME).elf\
       $(BIN_OUTDIR)$(PROJ_NAME).bin\
       $(BIN_OUTDIR)$(PROJ_NAME).hex\
       $(BIN_OUTDIR)$(PROJ_NAME).sym\
       $(BIN_OUTDIR)$(PROJ_NAME).size


.PHONY: clean
clean:
	@$(RM_RF) GTAGS
	@$(RM_RF) GPATH
	@$(RM_RF) GRTAGS
#	py3clean .
	@$(RM_RF) bin
	@$(RM_RF) obj
	@$(ECHO) "Cleaned project"


.PHONY: info
info:
	@$(ECHO_E) $(BLUE)"AS_SRCs:"$(RESET)
	for i in $(sort $(AS_SRCs)) ; \
	  do \
	    echo "    $$i"; \
	  done
	@$(ECHO_E) $(BLUE)"C_SRCs:"$(RESET)
	for i in $(sort $(C_SRCs)) ; \
	  do \
	    echo "    $$i"; \
	  done
	@$(ECHO_E) $(BLUE)"CXX_SRCs:"$(RESET)
	for i in $(sort $(CXX_SRCs)) ; \
	  do \
	    echo "    $$i"; \
	  done
#	@$(ECHO_E) $(BLUE)"OBJS:"$(RESET)
#	for i in $(OBJS) ; \
#	  do \
#	    echo "    $$i"; \
#	  done
	@$(ECHO) ""
	@$(ECHO_E) $(BLUE)"AS:  "$(RESET)$(COMPILE.AS)
	@$(ECHO_E) $(BLUE)"CC:  "$(RESET)$(COMPILE.CC)
	@$(ECHO_E) $(BLUE)"CXX: "$(RESET)$(COMPILE.CXX)
	@$(ECHO_E) $(BLUE)"LD:  "$(RESET)$(LINK)

################################################################################
#    Functions
#

RUN_DOS2UNIX =
#define RUN_DOS2UNIX =
#	@dos2unix -k $< 2> /dev/null
#endef

RUN_ASTYLE =
#define RUN_ASTYLE =
#	@astyle -q $<
#endef

RUN_GTAGS =
#define RUN_GTAGS =
#	@$(MKDIR_P) $(OBJ_OUTDIR)tags/
#	@$(GTAGS) -c --gtagslabel=new-ctags -i --single-update $< $(OBJ_OUTDIR)tags
#endef

################################################################################
#    Rules
#

# Compile assembly
$(OBJ_OUTDIR)%.o: %.s $(AUX)
	@$(ECHO_NE) $(BLUE)"AS  "$(RESET)"$< "
	@$(MKDIR_P) $(dir $@)
	$(RUN_DOS2UNIX)
	@$(COMPILE.AS) 2>&1 | $(TEE) $(@:%.o=%.err) | $(XARGS_R0) $(ECHO_E) $(RED)"FAIL\n\n"$(RESET)
	@$(MV_F) $(@:%.o=%.Td) $(@:%.o=%.d) && $(TOUCH) $@ || { $(ECHO_E) $(RED)"FAIL\n\n"$(RESET); exit 1; }
	$(RUN_GTAGS)
	@$(ECHO_E) $(GREEN)"OK"$(RESET)


# Compile C
$(OBJ_OUTDIR)%.o: %.c $(OBJ_OUTDIR)%.d $(AUX)
	@$(ECHO_NE) $(BLUE)"CC  "$(RESET)"$< "
	@$(MKDIR_P) $(dir $@)
	$(RUN_DOS2UNIX)
	$(RUN_ASTYLE)
	@$(COMPILE.CC) 2>&1 | $(TEE) $(@:%.o=%.err) | $(XARGS_R0) $(ECHO_E) $(RED)"FAIL\n\n"$(RESET)
	@$(MV_F) $(@:%.o=%.Td) $(@:%.o=%.d) && $(TOUCH) $@ || { $(ECHO_E) $(RED)"FAIL\n\n"$(RESET); exit 1; }
	$(RUN_GTAGS)
	@$(ECHO_E) $(GREEN)"OK"$(RESET)


# Compile C++
$(OBJ_OUTDIR)%.o: %.cpp $(OBJ_OUTDIR)%.d $(AUX)
	@$(ECHO_NE) $(BLUE)"CXX "$(RESET)"$< "
	@$(MKDIR_P) $(dir $@)
	$(RUN_DOS2UNIX)
	$(RUN_ASTYLE)
	@$(COMPILE.CXX) 2>&1 | $(TEE) $(@:%.o=%.err) | $(XARGS_R0) $(ECHO_E) $(RED)"FAIL\n\n"$(RESET)
	@$(MV_F) $(@:%.o=%.Td) $(@:%.o=%.d) && $(TOUCH) $@ || { $(ECHO_E) $(RED)"FAIL\n\n"$(RESET); exit 1; }
	$(RUN_GTAGS)
	@$(ECHO_E) $(GREEN)"OK"$(RESET)


# Link
$(BIN_OUTDIR)$(PROJ_NAME).elf: $(OBJS)
	@$(ECHO_NE) $(BLUE)"LD  "$(RESET)"$@ "
	@$(MKDIR_P) $(dir $@)
	@$(LINK) 2>&1 | $(TEE) $(@:%.o=%.err) | $(XARGS_R0) $(ECHO_E) $(RED)"FAIL\n\n"$(RESET)
	@$(ECHO_E) $(GREEN)"OK"$(RESET)


# Bin
%.bin: %.elf
	@$(ECHO_NE) $(BLUE)"BIN "$(RESET)"$@ "
	@$(MKDIR_P) $(dir $@)
	@$(OC) -O binary -S $< $@
	@$(ECHO_E) $(GREEN)"OK"$(RESET)


# Hex
%.hex: %.elf
	@$(ECHO_NE) $(BLUE)"HEX "$(RESET)"$@ "
	@$(MKDIR_P) $(dir $@)
	@$(OC) -O ihex $< $@
	@$(ECHO_E) $(GREEN)"OK"$(RESET)


# Symbols
%.sym: %.elf
	@$(ECHO_NE) $(BLUE)"NM  "$(RESET)"$@ "
	@$(MKDIR_P) $(dir $@)
	@$(NM) -n $< > $@
	@$(ECHO_E) $(GREEN)"OK"$(RESET)


# Size
%.size: %.elf
	@$(ECHO_NE) $(BLUE)"SZ  "$(RESET)"$@ "
	@$(ECHO_E) $(GREEN)"OK"$(RESET)
	@$(SZ) $^ --format=sysv 1>$@
	@$(ECHO) ""
	@$(SZ) $^
	@$(ECHO) ""


################################################################################
#    Auto-depedencies
#

# Manage auto-depedencies( this must be at the end )
DEPS=$(OBJS:%.o=%.d)

.PRECIOUS: $(DEPS)
$(DEPS): $(AUX)
#	@$(ECHO_E) $(BLUE)"D   "$(RESET)"$@ "

-include $(DEPS)
