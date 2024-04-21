################################################################################
#
#    GNU Make makefile for cross-compile and Test driven development in
#    Assembly/C/C++ for multi-targeted environments.
#
#    ----- Feature -----
#
#    - Multi language support: Assembly/C/C++ (single or mixed)
#    - Auto code versioning( via git tags )
#    - Automatic source discovery via predefined search paths.
#    - Supports test driven development (Optional).
#    - Speedy compilation with ccache (Optional).
#    - Expandable custom Makefile per platform. (Optional).
#
#    ----- Filesystem -----
#
#    - inc:        Mandatory directory that includes to hardware independent
#                  code.
#    - src:        Mandatory directory that holds hardware independent code.
#    - port:       Optional directory that holds hardware dependent code.
#    - components: Optional directory for software components.
#                  Normally it is a git submodule pointing to the platform.
#                  Features: Automatical discovery.
#    - thirdparty: Optional directory for software components.
#                  Normally it is a git submodule pointing to the platform.
#                  Features: No Automatical discovery.
#    - tests:      Optional directory for unit tests
#                  Features: Automatical discovery.
#    - conf:       Directory that holds configuration files.
#    - scripts:    Directory for keeping scripts.
#
#    ----- Terminology -----
#
#    HAL:                  Hardware abstraction layer.
#    CAL:                  Compiler abstraction layer.
#    OSAL:                 OS abstraction layer.
#    Platform:             A system composed of a spesific compiler, cpu
#                          architecture and OS (or freestanding).
#    Platform dependent:   Attribute for code that depends on a combination of
#                          compiler, hardware and OS that can be abstracted.
#    Hardware dependent:   Attribute for code that is low level, meaning that
#                          depends on specific hardware.
#    Hardware independent: Portable code to any system.
#
#
#    Maintainer: Kanelis Elias (e.kanelis@voidbuffer.com)
#    License:    MIT
#


################################################################################
#
# Usage:
#
#    make
#    make PORT_NAME=<name> TARGET=<dbg/rel>
#


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
#    Paths

MAKEFILE_FILEPATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MAKEFILE_DIRPATH  := $(dir $(MAKEFILE_FILEPATH))

TESTSMK_FILEPATH := $(MAKEFILE_DIRPATH)tests.mk

COMPILERMK_FILEPATH := $(MAKEFILE_DIRPATH)compiler.mk

#.................................................
#    Project's name

PROJ_NAME := $(shell basename $(MAKEFILE_DIRPATH))

# App directory is optional.
# So in case there is not any use proj as the app name
APP_NAMES := $(sort $(notdir $(shell if [ -d "apps/" ]; then find "apps/" -maxdepth 1 -type d -not -path "apps" -print; fi)))
DEFAULT_APP_NAME := $(if $(APP_NAMES),$(firstword $(APP_NAMES)),$(PROJ_NAME))

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

# Validate PORT_NAME
ifdef PORT_NAME
  PORT_NAME_ISVALID := $(findstring $(PORT_NAME),$(AVAILABLE_PORTS))
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
TEE_A    := tee -a
XARGS_R0 := xargs -r -0
TPUT     := tput
GTAGS    := gtags
SED      := sed
RLWRAP   := rlwrap -I -R -a -A --no-warnings
CAT      := cat

################################################################################
#    Default toolchain
#

AS  = gcc -x assembler-with-cpp
CC  = gcc
CXX = g++
LD  = gcc
AR  = ar
SZ  = size
OC  = objcopy
NM  = nm

CPPFLAGS =
ASFLAGS  =
CFLAGS   =
CXXFLAGS =
LDFLAGS  =

################################################################################
#    Utils
#

FILTER_OUT = $(foreach element,$(2),$(if $(findstring $(1),$(element)),,$(element)))
FILTER     = $(foreach element,$(2),$(if $(findstring $(1),$(element)),$(element)))

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


#.................................................
#    Notify user

ifndef PORT_NAME
define notify
    @$(ECHO_NE) $(BLACK)"[$(PROJ_NAME)] "$(BLUE)"$(1)"$(RESET)"$(2) "
endef
else
define notify
    @$(ECHO_NE) $(BLACK)"[$(PORT_NAME)] "$(BLUE)"$(1)"$(RESET)"$(2) "
endef
endif

################################################################################
#    Files
#

#.................................................
#    Auxiliary files that build depends on

AUX = $(MAKEFILE_FILEPATH) $(COMPILERMK_FILEPATH)

ifdef PORT_NAME
  ifneq (,$(wildcard port/$(PORT_NAME)/Makefile))
    AUX += port/$(PORT_NAME)/Makefile
  endif
endif

#.................................................
#    Source

AS_SRCs  += $(shell if [ -d "apps/" ]; then find "apps/" -type f -name '*.[s|S]'; fi)
C_SRCs   += $(shell if [ -d "apps/" ]; then find "apps/" -type f -name '*.[c|C]'; fi)
CXX_SRCs += $(shell if [ -d "apps/" ]; then find "apps/" -type f -name '*.cpp'; fi)

AS_SRCs  += $(shell if [ -d "src/" ]; then find "src/" -type f -name '*.[s|S]'; fi)
C_SRCs   += $(shell if [ -d "src/" ]; then find "src/" -type f -name '*.[c|C]'; fi)
CXX_SRCs += $(shell if [ -d "src/" ]; then find "src/" -type f -name '*.cpp'; fi)

ifdef PORT_NAME
  AS_SRCs  += $(shell find "port/$(PORT_NAME)/" -name "*.[s|S]")
  C_SRCs   += $(shell find "port/$(PORT_NAME)/" -name "*.[c|C]")
  CXX_SRCs += $(shell find "port/$(PORT_NAME)/" -name "*.cpp")
endif

COMPONENTS :=
ifneq (,$(wildcard components))
  COMPONENTS += $(sort $(notdir $(shell find "components" -maxdepth 1 -type d -not -path "components" -print)))
endif

AS_SRCs  += $(foreach COMPONENT,$(COMPONENTS),$(shell find "components/$(COMPONENT)/src/" -name "*.[s|S]"))
C_SRCs   += $(foreach COMPONENT,$(COMPONENTS),$(shell find "components/$(COMPONENT)/src/" -name "*.[c|C]"))
CXX_SRCs += $(foreach COMPONENT,$(COMPONENTS),$(shell find "components/$(COMPONENT)/src/" -name "*.cpp"))

AS_SRCs  := $(sort $(AS_SRCs))
C_SRCs   := $(sort $(C_SRCs))
CXX_SRCs := $(sort $(CXX_SRCs))

#.................................................
#    Output dir

ifdef PORT_NAME

ifdef TARGET
    BIN_OUTDIR  := gen/build/$(PORT_NAME)/$(TARGET)/bin/
    OBJ_OUTDIR  := gen/build/$(PORT_NAME)/$(TARGET)/obj/
  else
    BIN_OUTDIR  := gen/build/$(PORT_NAME)/bin/
    OBJ_OUTDIR  := gen/build/$(PORT_NAME)/obj/
  endif
else
  BIN_OUTDIR    := gen/build/bin/
  OBJ_OUTDIR    := gen/build/obj/
endif

OBJS=  $(sort $(AS_SRCs:%.s=$(OBJ_OUTDIR)%.o))
OBJS+= $(sort $(C_SRCs:%.c=$(OBJ_OUTDIR)%.o))
OBJS+= $(sort $(CXX_SRCs:%.cpp=$(OBJ_OUTDIR)%.o))

#.................................................
#    Includes

CPPFLAGS +=-Iinc/
CPPFLAGS +=-Isrc/

CPPFLAGS += $(foreach COMPONENT,$(COMPONENTS),-Icomponents/$(COMPONENT)/inc/)
CPPFLAGS += $(foreach COMPONENT,$(COMPONENTS),-Icomponents/$(COMPONENT)/src/)

ifdef PORT_NAME
  CPPFLAGS+=-Iport/
endif

################################################################################
#    Compiler
#

-include $(COMPILERMK_FILEPATH)

ifdef PORT_NAME
  -include port/$(PORT_NAME)/Makefile
endif

COMPILE.AS  ?= $(AS)  -c $< -o $@ $(CPPFLAGS) $(ASFLAGS)
COMPILE.CC  ?= $(CC)  -c $< -o $@ $(CPPFLAGS) $(CFLAGS)
COMPILE.CXX ?= $(CXX) -c $< -o $@ $(CPPFLAGS) $(CXXFLAGS)

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

define runApp
  ./$(BIN_OUTDIR)$(DEFAULT_APP_NAME).elf
endef

# Function to calculate the size of the elf
define sizeElf
  @$(SZ) "$(1)" > "$(2)"
endef


################################################################################
#    Rules
#

.PHONY: all
all: build
	@$(ECHO_E) $(GREEN)"Build finished succesfully"$(RESET)

.PHONY: size
size: $(BIN_OUTDIR)$(DEFAULT_APP_NAME).size
	@$(CAT) $<
	@$(ECHO)

.PHONY: version
version:
	$(call notify,"Version ","")
	@./scripts/get_version.sh 1>/dev/null
	@$(ECHO_E) $(GREEN)"OK"$(RESET)

.PHONY: tags
tags:
	$(call notify,"Gtags ","")
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

BUILD_APPS_ELF  := $(foreach APP_NAME,$(APP_NAMES),$(BIN_OUTDIR)$(APP_NAME).elf)
BUILD_APPS_BIN  := $(foreach APP_NAME,$(APP_NAMES),$(BIN_OUTDIR)$(APP_NAME).bin)
BUILD_APPS_HEX  := $(foreach APP_NAME,$(APP_NAMES),$(BIN_OUTDIR)$(APP_NAME).hex)
BUILD_APPS_SYM  := $(foreach APP_NAME,$(APP_NAMES),$(BIN_OUTDIR)$(APP_NAME).sym)
BUILD_APPS_SIZE := $(foreach APP_NAME,$(APP_NAMES),$(BIN_OUTDIR)$(APP_NAME).size)

.PHONY: build
build: check \
       version \
       tags \
       ${BUILD_APPS_ELF} \
       ${BUILD_APPS_BIN} \
       ${BUILD_APPS_HEX} \
       ${BUILD_APPS_SYM} \
       ${BUILD_APPS_SIZE} \
       runTests \
       size

.PHONY: clean
clean:
	@$(RM_RF) GTAGS
	@$(RM_RF) GPATH
	@$(RM_RF) GRTAGS
	py3clean .
	@$(RM_RF) gen
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
	@$(ECHO_E) $(BLUE)"OBJS:"$(RESET)
	for i in $(OBJS) ; \
	  do \
	    echo "    $$i"; \
	  done
	@$(ECHO) ""
	@$(ECHO_E) $(BLUE)"AS:  "$(RESET)$(COMPILE.AS)
	@$(ECHO_E) $(BLUE)"CC:  "$(RESET)$(COMPILE.CC)
	@$(ECHO_E) $(BLUE)"CXX: "$(RESET)$(COMPILE.CXX)
	@$(ECHO) ""
	@$(ECHO_E) $(BLUE)"COMPONENTS: "$(RESET)$(COMPONENTS)

.PHONY: run
run:
	@if [ ! -f commands ]; then
		@$(RLWRAP) -H .cmd_history $(call runApp)
	@else
		@$(RLWRAP) -f commands -H .cmd_history $(call runApp)
	@fi


################################################################################
#    Rules
#

# Compile assembly
$(OBJ_OUTDIR)%.o: %.s $(AUX)
	$(call notify,"AS  ","$<")
	@$(MKDIR_P) $(dir $@)
	$(RUN_DOS2UNIX)
	@$(COMPILE.AS) 2>&1 | $(TEE) $(@:%.o=%.err) | $(XARGS_R0) $(ECHO_E) $(RED)"FAIL\n\n"$(RESET)
	@$(MV_F) $(@:%.o=%.Td) $(@:%.o=%.d) && $(TOUCH) $@ || { $(ECHO_E) $(RED)"FAIL\n\n"$(RESET); exit 1; }
	$(RUN_GTAGS)
	@$(ECHO_E) $(GREEN)"OK"$(RESET)


# Compile C
$(OBJ_OUTDIR)%.o: %.c $(OBJ_OUTDIR)%.d $(AUX)
	$(call notify,"CC  ","$<")
	@$(MKDIR_P) $(dir $@)
	$(RUN_DOS2UNIX)
	$(RUN_ASTYLE)
	@$(COMPILE.CC) 2>&1 | $(TEE) $(@:%.o=%.err) | $(XARGS_R0) $(ECHO_E) $(RED)"FAIL\n\n"$(RESET)
	@$(MV_F) $(@:%.o=%.Td) $(@:%.o=%.d) && $(TOUCH) $@ || { $(ECHO_E) $(RED)"FAIL\n\n"$(RESET); exit 1; }
	$(RUN_GTAGS)
	@$(ECHO_E) $(GREEN)"OK"$(RESET)


# Compile C++
$(OBJ_OUTDIR)%.o: %.cpp $(OBJ_OUTDIR)%.d $(AUX)
	$(call notify,"CXX ","$<")
	@$(MKDIR_P) $(dir $@)
	$(RUN_DOS2UNIX)
	$(RUN_ASTYLE)
	@$(COMPILE.CXX) 2>&1 | $(TEE) $(@:%.o=%.err) | $(XARGS_R0) $(ECHO_E) $(RED)"FAIL\n\n"$(RESET)
	@$(MV_F) $(@:%.o=%.Td) $(@:%.o=%.d) && $(TOUCH) $@ || { $(ECHO_E) $(RED)"FAIL\n\n"$(RESET); exit 1; }
	$(RUN_GTAGS)
	@$(ECHO_E) $(GREEN)"OK"$(RESET)


# Link
PRECIOUS: $(OBJS)
$(BIN_OUTDIR)%.elf: $(OBJS)
	$(call notify,"LD  ","$@")
	@$(MKDIR_P) $(dir $@)
	$(eval APP_OBJS := $(call FILTER,$(OBJ_OUTDIR)apps/$(basename $(notdir $@))/,$^))
	$(eval COMMON_OBJS := $(call FILTER_OUT,$(OBJ_OUTDIR)apps/,$^))
	@$(LD) $(APP_OBJS) $(COMMON_OBJS) -o $@ $(CPPFLAGS) $(LDFLAGS) 2>&1 | $(TEE) $(@:%.o=%.err) | $(XARGS_R0) $(ECHO_E) $(RED)"FAIL\n\n"$(RESET)
	@$(ECHO_E) $(GREEN)"OK"$(RESET)


# Bin
%.bin: %.elf
	$(call notify,"BIN ","$@")
	@$(MKDIR_P) $(dir $@)
	@$(OC) -O binary -S $< $@
	@$(ECHO_E) $(GREEN)"OK"$(RESET)


# Hex
%.hex: %.elf
	$(call notify,"HEX ","$@")
	@$(MKDIR_P) $(dir $@)
	@$(OC) -O ihex $< $@
	@$(ECHO_E) $(GREEN)"OK"$(RESET)


# Symbols
%.sym: %.elf
	$(call notify,"NM  ","$@")
	@$(MKDIR_P) $(dir $@)
	@$(NM) -n $< > $@
	@$(ECHO_E) $(GREEN)"OK"$(RESET)


# Size
%.size: %.elf
	$(call notify,"SZ  ","$@")
	$(call sizeElf,"$<","$@")
	@$(ECHO_E) $(GREEN)"OK"$(RESET)


################################################################################
#    Unit tests
#

.PHONY: runTests
runTests:
ifdef PORT_NAME
	@$(MAKE) PORT_NAME=posix --no-print-directory -f $(TESTSMK_FILEPATH) runCppUtest
else
	@$(MAKE) --no-print-directory -f $(TESTSMK_FILEPATH) runCppUtest
endif

################################################################################
#    Auto-depedencies
#

# We only enable the autodependencies on non recursive calls
# because the tests.mk is including this Makefile on the start.
ifeq (0,${MAKELEVEL})

# Manage auto-depedencies( this must be at the end )
DEPS=$(OBJS:%.o=%.d)

.PRECIOUS: $(DEPS)
$(DEPS): $(AUX)
#	$(call notify,"D   ","$@")
#	@$(ECHO) ""

-include $(DEPS)

endif
