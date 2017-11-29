#-------------------------------------------------------------------------------
#
#            ____________________________________________________
#           /                                                    \
#          |    _____________________________________________     |
#          |   |                                             |    |
#          |   |  embedded@tdd ~ $ make help                 |    |
#          |   |                                             |    |
#          |   |    GNU Make makefile for cross-compile      |    |
#          |   |    and Test driven development in C         |    |
#          |   |                                             |    |
#          |   |    Type "make help" to view all available   |    |
#          |   |    options.                                 |    |
#          |   |                                             |    |
#          |   |    Maintainer:                              |    |
#          |   |    Kanelis Ilias (hkanelhs@yahoo.gr)        |    |
#          |   |                                             |    |
#          |   |    URL:                                     |    |
#          |   |    Version:   Beta                          |    |
#          |   |    Date:      2017/11/17                    |    |
#          |   |                                             |    |
#          |   |    License:   MIT                           |    |
#          |   |_____________________________________________|    |
#          |                                                      |
#           \_____________________________________________________/
#                  \_______________________________________/
#	 _____           _              _     _          _   _____ ____  ____  
#	| ____|_ __ ___ | |__   ___  __| | __| | ___  __| | |_   _|  _ \|  _ \ 
#	|  _| | '_ ` _ \| '_ \ / _ \/ _` |/ _` |/ _ \/ _` |   | | | | | | | | |
#	| |___| | | | | | |_) |  __/ (_| | (_| |  __/ (_| |   | | | |_| | |_| |
#	|_____|_| |_| |_|_.__/ \___|\__,_|\__,_|\___|\__,_|   |_| |____/|____/ 
#
#-------------------------------------------------------------------------------
#
#
#	Variable			Descriptions					Configurations
#   ========			============					==============
#
#-------------------------------------------------------------------------------
#	
#	BUILD_MODE			Compile in debug mode.			debug
#														release
#
#	PLATFORM			Select target or host.			target			
#														host
#
#	PROJECT_NUMBER		Select the version of the		(Calculated from git)
#						program.
#
#	EXEC				Name of the executable.			program
#
#	TESTS_EXEC			Name of the tests executable.	runAlltests
#
#	PROJECT_NAME		The name of the project.		Untitled
#
#	PROJECT_BRIEF		One sentence about the project.	
#
#-------------------------------------------------------------------------------
#
#	CPPUTEST_DIR		Directory of cppUtest.			
#
#	TARGET_TC_PATH		Path of target toolchain path.	
#
#	TARGET_TC_PREFIX	Target toolchain prefix.		arm-none-eabi-
#
#
#
#	TARGET_CPU			CPU architecture-type.			cortex-m0
#
#	TARGET_FPU			Target hardware support for		
#						floating-point operations.
#
#	TARGET_FLOAT_ABI	Target hardware support for		
#						floating-point operations 
#						application binary interface.
#
#-------------------------------------------------------------------------------
#
#	COLORS				Make output in color.			Any  = Color output.
#														NO = No color output.
#
#-------------------------------------------------------------------------------
#
#	USER_CXX_INCs		C++ include directories.			
#	USER_CXX_SRCs		C++ source directories.				
#	USER_C_INCs			C include directories.				
#	USER_C_SRCs			C source directories.				
#
#	USER_TEST_CXX_INCs	Test C++ include directories.		
#	USER_TEST_CXX_SRCs	Test C++ source directories.		
#	USER_TEST_C_INCs	Test C include directories.			
#	USER_TEST_C_SRCs	Test C source directories.			
#
#	USER_ASFLAGS		Assembler extra flags.				
#	USER_CFLAGS			C compiler extra flags.				
#	USER_LDFLAGS		Linker extra flags.					
#	TARGET_LDSCRIPT		Path of the target linker			
#						script.	
#-------------------------------------------------------------------------------

#Include custom configurations if they exist
-include config.mk

#-------------------------------------------------------------------------------
#	  _______          _             _     _       
#	 |__   __|        | |           (_)   | |      
#	    | | ___   ___ | |   _____  ___ ___| |_ ___ 
#	    | |/ _ \ / _ \| |  / _ \ \/ / / __| __/ __|
#	    | | (_) | (_) | | |  __/>  <| \__ \ |_\__ \
#	    |_|\___/ \___/|_|  \___/_/\_\_|___/\__|___/
#
#-------------------------------------------------------------------------------

GCC_EXISTS := $(shell command -v gcc 2> /dev/null)
GPP_EXISTS := $(shell command -v g++ 2> /dev/null)
GDB_EXISTS := $(shell command -v gdb 2> /dev/null)
WINE_EXISTS := $(shell command -v wine 2> /dev/null)
VALGRIND_EXISTS := $(shell command -v valgrind 2> /dev/null)
PERL_EXISTS := $(shell command -v perl 2> /dev/null)
GIT_EXISTS := $(shell command -v git 2> /dev/null)
DOXYGEN_EXISTS := $(shell command -v doxygen 2> /dev/null)
DOT_EXISTS := $(shell command -v dot 2> /dev/null)
JLINK_EXISTS := $(shell command -v JLinkExe 2> /dev/null)
SALEAE_EXISTS := $(shell command -v Saleae 2> /dev/null)
PICOCOM_EXISTS := $(shell command -v picocom 2> /dev/null)
CHROMIUM_EXISTS := $(shell command -v chromium-browser 2> /dev/null)

#-------------------------------------------------------------------------------
#	  _____           _           _   
#	 |  __ \         (_)         | |  
#	 | |__) | __ ___  _  ___  ___| |_ 
#	 |  ___/ '__/ _ \| |/ _ \/ __| __|
#	 | |   | | | (_) | |  __/ (__| |_ 
#	 |_|   |_|  \___/| |\___|\___|\__|
#	                _/ |              
#	               |__/               
#	
#-------------------------------------------------------------------------------

################################################################################
################		Project options		####################################
################################################################################

#-------------------------------------------------------------------------------
#						Names

EXEC ?=					program
TESTS_EXEC ?=			runAlltests

ifdef GIT_EXISTS
  PROJECT_NUMBER ?=		$(shell git describe --always \
						--dirty=" (with uncommitted changes)" --long --tags)
endif

#-------------------------------------------------------------------------------
#						Build target options

BUILD_MODE ?=			debug

PLATFORM ?=				target

ifeq ($(PLATFORM),target)
  TARGET_CPU ?=			cortex-m0
  TARGET_FPU ?=			
  TARGET_FLOAT_ABI ?=		
  TARGET_NAME = 		$(TARGET_CPU)
else
  ifeq ($(PLATFORM),host)
    TARGET_NAME = 		$(shell uname --machine)
  else
    $(error "PLATFORM" variable can not be "$(PLATFORM)")
  endif
endif

################################################################################
################		Toolchain		########################################
################################################################################

#-------------------------------------------------------------------------------
#						ARM-Cortex-M

MCU =					-mcpu=$(TARGET_CPU)\
						-mthumb $(TARGET_FPU)\
						$(TARGET_FLOAT_ABI)

ifeq ($(PLATFORM),host)
  TARGET_TC_PATH ?=	
  TARGET_TC_PREFIX ?=
else
  TARGET_TC_PATH ?=	
  TARGET_TC_PREFIX ?=	arm-none-eabi-
endif

TARGET_CC =				$(TARGET_TC_PATH)$(TARGET_TC_PREFIX)gcc
TARGET_CXX =			$(TARGET_TC_PATH)$(TARGET_TC_PREFIX)g++
TARGET_AS =				$(TARGET_TC_PATH)$(TARGET_TC_PREFIX)gcc\
														-x assembler-with-cpp
TARGET_CP =				$(TARGET_TC_PATH)$(TARGET_TC_PREFIX)objcopy
TARGET_AR =				$(TARGET_TC_PATH)$(TARGET_TC_PREFIX)ar
TARGET_SZ =				$(TARGET_TC_PATH)$(TARGET_TC_PREFIX)size
TARGET_HEX =			$(CP) -O ihex
TARGET_BIN =			$(CP) -O binary -S

#-------------------------------------------------------------------------------
#						Host

HOST_CC =				gcc
HOST_CXX =				g++
HOST_AS =				gcc -x assembler-with-cpp
HOST_CP =				objcopy
HOST_AR =				ar
HOST_SZ =				size
HOST_HEX =				$(CP) -O ihex
HOST_BIN =				$(CP) -O binary -S

#-------------------------------------------------------------------------------
#						Host

ifeq ($(PLATFORM),target)

  CC =					$(TARGET_CC)
  CXX =					$(TARGET_CXX)
  AS =					$(TARGET_AS)
  CP =					$(TARGET_CP)
  AR =					$(TARGET_AR)
  SZ =					$(TARGET_SZ)
  HEX =					$(TARGET_HEX)
  BIN =					$(TARGET_BIN)
else
  CC =					$(HOST_CC)
  CXX =					$(HOST_CXX)
  AS =					$(HOST_AS)
  CP =					$(HOST_CP)
  AR =					$(HOST_AR)
  SZ =					$(HOST_SZ)
  HEX =					$(HOST_HEX)
  BIN =					$(HOST_BIN)
endif

################################################################################
################		Test driven development		############################
################################################################################

CPPUTEST_DIR ?=			

CPPUTEST_CXXFLAGS =		-I"$(CPPUTEST_DIR)include/"\
						-I"$(CPPUTEST_DIR)include/CppUTest/\
											MemoryLeakDetectorNewMacros.h"

CPPUTEST_CFLAGS =		-I"$(CPPUTEST_DIR)include/"\
						-I"$(CPPUTEST_DIR)include/CppUTest/\
											MemoryLeakDetectorMallocMacros.h"

CPPUTEST_LDFLAGS =		-L"$(CPPUTEST_DIR)cpputest_build/lib/"\
						-lCppUTest\
						-lCppUTestExt

################################################################################
################		Project directories		################################
################################################################################

BIN_DIR :=				bin/
OBJ_DIR :=				obj/
INC_DIR :=				inc/
SRC_DIR :=				src/
DOC_DIR :=				doc/
TMP_DIR :=				tmp/
LIB_DIR :=					
TESTS_DIR := 			tests/
PORT_DIR :=				port/

TARGET_DIR = 			$(TARGET_NAME)/
BUILD_MODE_DIR = 		$(BUILD_MODE)/

TARGET_BIN_DIR := 		$(BIN_DIR)$(TARGET_DIR)$(BUILD_MODE_DIR)
TARGET_OBJ_DIR := 		$(OBJ_DIR)$(TARGET_DIR)$(BUILD_MODE_DIR)
TESTS_BIN_DIR := 		$(BIN_DIR)$(TESTS_DIR)
TESTS_OBJ_DIR := 		$(OBJ_DIR)$(TESTS_DIR)

#-------------------------------------------------------------------------------
#	 _    _ _   _ _ _ _   _           
#	| |  | | | (_) (_) | (_)          
#	| |  | | |_ _| |_| |_ _  ___  ___ 
#	| |  | | __| | | | __| |/ _ \/ __|
#	| |__| | |_| | | | |_| |  __/\__ \
#	 \____/ \__|_|_|_|\__|_|\___||___/
#
#-------------------------------------------------------------------------------

################################################################################
################		Output color messages		############################
################################################################################

# tput colors for MSG function
MSG_RED :=				1
MSG_GREEN :=			2
MSG_YELLOW :=			3
MSG_BLUE :=				4
MSG_CYAN :=				6
MSG_WHITE :=			7


ifeq ($(COLORS),NO)

  # Show a msg with color
  # use $(call MSG,"msg",colorNum)
  define MSG
    @echo -n $1
  endef

  # TPUT COLORS
  TPUT_RED :=			
  TPUT_GREEN :=			
  TPUT_WHITE :=			
  TPUT_YELLOW :=		
  TPUT_RESET :=			

  PASS:=		@echo "OK"
  BUILD_OK:=	@echo "Build successfully!"

  COMP_MSG:=	@echo -n "Compiling "
  CREATED:=		@echo -n "Created   "

else

  # Show a msg with color
  # use $(call MSG,"msg",colorNum)
  define MSG
    @tput bold
    @tput -Txterm setaf $2
    @echo -n $1
    @tput -Txterm sgr0
  endef

  # TPUT COLORS
  TPUT_RED :=			$(shell tput -Txterm setaf 1)
  TPUT_GREEN :=			$(shell tput -Txterm setaf 2)
  TPUT_WHITE :=			$(shell tput -Txterm setaf 7)
  TPUT_YELLOW :=		$(shell tput -Txterm setaf 3)
  TPUT_RESET :=			$(shell tput -Txterm sgr0)

  PASS:=		@tput bold && tput -Txterm setaf 2 && echo "OK" \
  						&& tput -Txterm sgr0
  BUILD_OK:=	@tput bold && tput -Txterm setaf 2 \
					   && echo "Build successfully!" && tput -Txterm sgr0

  COMP_MSG:=	@tput bold && tput -Txterm setaf 3 \
					   && echo -n "Compiling " && tput -Txterm sgr0
  CREATED:=		@tput bold && tput -Txterm setaf 6 \
					   && echo -n "Created   " && tput -Txterm sgr0
endif

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
# Credits to: https://gist.github.com/prwhite/8168133
HELP_FUNC := \
	%help; \
	while(<>) { \
		if(/^([a-z0-9_-]+):.*\#\#(?:@(\w+))?\s(.*)$$/) { \
			push(@{$$help{$$2}}, [$$1, $$3]); \
		} \
	}; \
	print "Usage: make ${TPUT_YELLOW}[target]${TPUT_RESET}\n\n"; \
	for ( sort keys %help ) { \
		print "${TPUT_WHITE}$$_:${TPUT_RESET}\n"; \
		printf("  ${TPUT_YELLOW}%-20s${TPUT_RESET} \
						${TPUT_GREEN}%s${TPUT_RESET}\n", $$_->[0], \
						$$_->[1]) for @{$$help{$$_}}; \
		print "\n"; \
	}

#-------------------------------------------------------------------------------
#	 _____                            _                 _           
#	|  __ \                          | |               (_)          
#	| |  | | ___ _ __   ___ _ __   __| | ___ _ __   ___ _  ___  ___ 
#	| |  | |/ _ \ '_ \ / _ \ '_ \ / _` |/ _ \ '_ \ / __| |/ _ \/ __|
#	| |__| |  __/ |_) |  __/ | | | (_| |  __/ | | | (__| |  __/\__ \
#	|_____/ \___| .__/ \___|_| |_|\__,_|\___|_| |_|\___|_|\___||___/
#	            | |                                                 
#	            |_|                                                 
#
#-------------------------------------------------------------------------------

################################################################################
################		Assembled dependencies		############################
################################################################################

#-------------------------------------------------------------------------------
#						Host

ifeq ($(PLATFORM),host)
  #	Linux
  ASM_INCs =			$(USER_ASM_INCs)

  ASM_SRCs =			$(USER_ASM_SRCs)

  C_INCs =				$(USER_C_INCs)

  C_SRCs =				$(USER_C_SRCs)

endif

#-------------------------------------------------------------------------------
#						Target

ifeq ($(PLATFORM),target)
  # ARM
  ASM_INCs =			$(USER_ASM_INCs)

  ASM_SRCs =			$(USER_ASM_SRCs)

  C_INCs =				$(USER_C_INCs)

  C_SRCs =				$(USER_C_SRCs)	
					
endif

#-------------------------------------------------------------------------------
#						Tests

TEST_CXX_INCs = 		$(USER_TEST_CXX_INCs)

TEST_CXX_SRCs =			$(USER_TEST_CXX_SRCs)

TEST_C_INCs =			$(USER_TEST_C_INCs)

TEST_C_SRCs =			$(USER_TEST_C_SRCs)

################################################################################
################		User dependencies		################################
################################################################################

#Include custom configurations if they exist
-include dependencies.mk

#-------------------------------------------------------------------------------
#	  ______ _                 
#	 |  ____| |                
#	 | |__  | | __ _  __ _ ___ 
#	 |  __| | |/ _` |/ _` / __|
#	 | |    | | (_| | (_| \__ \
#	 |_|    |_|\__,_|\__, |___/
#	                  __/ |    
#	                 |___/     
#
#-------------------------------------------------------------------------------

################################################################################
################		Production code		####################################
################################################################################

#-------------------------------------------------------------------------------
#						Common Compiler

FLAGS +=				-w\
						-Wall\
						-Werror\
						-Wchar-subscripts\
						-fdata-sections\
						-ffunction-sections

# Generate dependency information
FLAGS +=				-MMD\
						-MP\
						-MF"$(@:%.o=%.d)"\
						-MT"$(@:%.o=%.d)"

ifeq ($(BUILD_MODE),release)
  # Optimization
  FLAGS +=				-O3
else
  # Debug flags
  FLAGS +=				-g -gdwarf-2
  FLAGS +=				-DDEBUG

  # Optimization
  FLAGS +=				-Og
endif

#-------------------------------------------------------------------------------
#						Assemply compiler

# GCC AS flags
ASFLAGS +=				$(FLAGS)\
						$(ASM_INCs)

ASFFLAGS +=				$(USER_ASFLAGS)

ifeq ($(PLATFORM),target)

  CFLAGS +=				$(MCU)

endif

#-------------------------------------------------------------------------------
#						C Compiler

# GCC C flags
CFLAGS +=				$(FLAGS)\
						$(C_INCs)

CFLAGS +=				$(USER_CFLAGS)

#-------------------------------------------------------------------------------
#						Linker

LDFLAGS +=				$(LIB_DIR)\
						-lc\
						-lm

ifeq ($(PLATFORM),target)

  ifeq ($(TARGET_LDSCRIPT),)
    $(error "A linker script is required!")
  endif

  # Linker flags
  LDFLAGS += 			$(MCU)\
						-specs=nano.specs\
						-T$(TARGET_LDSCRIPT)\
						-lnosys\
						-Wl,-Map=$(BIN_DIR)$(TARGET_DIR)$(EXEC).map,--cref\
						-Wl,--gc-sections\
						-lrdimon -u _printf_float
endif

LDFLAGS +=				$(USER_LDFLAGS)

################################################################################
################		Tests		############################################
################################################################################

TEST_CFLAGS =			$(CPPUTEST_CFLAGS)\
						$(C_INCs)

TEST_CXXFLAGS =			$(CPPUTEST_CXXFLAGS)\
						$(C_INCs)

TEST_LDFLAGS =			$(CPPUTEST_LDFLAGS)

#-------------------------------------------------------------------------------
#	 _____  _                                    _           
#	|  __ \| |                                  | |          
#	| |__) | |__   ___  _ __  _   _   _ __ _   _| | ___  ___ 
#	|  ___/| '_ \ / _ \| '_ \| | | | | '__| | | | |/ _ \/ __|
#	| |    | | | | (_) | | | | |_| | | |  | |_| | |  __/\__ \
#	|_|    |_| |_|\___/|_| |_|\__, | |_|   \__,_|_|\___||___/
#	                           __/ |                         
#	                          |___/                          
#
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#	Basic

.PHONY: default
default: ##@build Default rule (same as build).
default: build

.PHONY: all
all: ##@build Builds project and its documentation.
all: build doc 

.PHONY: rebuild
rebuild: ##@build Rebuilds project without documentation.
rebuild: clean build

.PHONY: build
build: ##@build Builds project without documentation.
build: version $(BIN_DIR)$(TARGET_DIR)$(EXEC).elf \
				$(BIN_DIR)$(TARGET_DIR)$(EXEC).hex \
				$(BIN_DIR)$(TARGET_DIR)$(EXEC).bin runalltests size
	@echo		
	$(BUILD_OK)
	@echo

.PHONY: version
version: ##@options Runs a script to generate inc/version.h
	$(call 			MSG,"\nBuilding: $(EXEC) ",$(MSG_GREEN))
	$(call 			MSG,"$(BUILD_MODE)",$(MSG_YELLOW))
	@echo			-n " @ "
	$(call 			MSG,"$(TARGET_NAME)\n\n",$(MSG_RED))
	$(call 			MSG,"Version   \t",$(MSG_WHITE))
	@scripts/get_version.sh 1>/dev/null
	$(PASS)

.PHONY: size
size: ##@options Measures program.
size: $(BIN_DIR)$(TARGET_DIR)$(EXEC).elf
	@echo
	@$(SZ)			$(BIN_DIR)$(TARGET_DIR)$(EXEC).elf

.PHONY: clean
clean: ##@options Cleans the project.
	@echo			-n "Cleaning $(EXEC) project\t"
	@rm				-fR $(OBJ_DIR)
	@rm				-fR $(BIN_DIR)
	@rm				-fR $(DOC_DIR)
	@rm				-fR $(INC_DIR)version.h
	$(PASS)
	@echo

.PHONY: help
help: ##@options Shows a list of all available make options.
	@perl 			-e '$(HELP_FUNC)' $(MAKEFILE_LIST)

.PHONY: tools
tools: ##@options Checks if tools used in this Makefile are installed.
	@echo		-n "Checking tools\t"
ifndef GCC_EXISTS
	$(warning "Please install 'gcc' compiler!")
endif
ifndef GPP_EXISTS
	$(warning "Please install 'g++' compiler!")
endif
ifndef GDB_EXISTS
	$(warning "Please install 'gdb' debugger!")
endif
ifndef WINE_EXISTS
	$(warning "Please install 'wine' windows emulation!")
endif
ifndef VALGRIND_EXISTS
	$(warning "Please install 'valgrind' dynamical analyser!")
endif
ifndef PERL_EXISTS
	$(warning "Please install 'perl' scripting language!")
endif
ifndef GIT_EXISTS
	$(warning "Please install 'git' version control!")
endif
ifndef DOXYGEN_EXISTS
	$(warning "Please install 'doxygen' documentation generator!")
endif
ifndef DOT_EXISTS
	$(warning "Please install 'dot' graphing tool!")
endif
ifndef JLINK_EXISTS
	$(warning "Please install Segger J-Link drivers!")
endif
ifndef SALEAE_EXISTS
	$(warning "Please install Saleae logic analyser!")
endif
ifndef PICOCOM_EXISTS
	$(warning "Please install 'picocom' terminal emulation!")
endif
ifndef CHROMIUM_EXISTS
	$(warning "Please install 'chromium-browser'!")
endif
	$(PASS)
	@echo

#-------------------------------------------------------------------------------
#	Test driven development

.PHONY: runalltests
runalltests: ##@tests Run all tests.
runalltests: version $(BIN_DIR)$(TESTS_DIR)$(TESTS_EXEC)
	$(call MSG,"\nCppUTest",$(MSG_YELLOW))
	@./$(BIN_DIR)$(TESTS_DIR)$(TESTS_EXEC) -c

#-------------------------------------------------------------------------------
#	Documentation

# Get version number from git
# https://christianhujer.github.io/Git-Version-in-Doxygen/
.PHONY: doc
doc: ##@doc Generates documentation.
doc: export PROJECT_NUMBER ?=	Beta
doc: export PROJECT_NAME ?=		Untitled
doc: export PROJECT_BRIEF ?=	
doc: | $(OBJ_DIR)
	@echo
	@echo			"Building documentation"
	@mkdir			-p $(DOC_DIR)html
	@(cd conf/doxygen/ && doxygen)
	$(PASS)
	@echo

.PHONY: show
show: ##@doc Shows documentation.
show: doc
ifdef CHROMIUM_EXISTS
	@chromium-browser $(DOC_DIR)html/index.html >>/dev/null
else
	$(warning "Please install 'chromium-browser'!")
endif

#-------------------------------------------------------------------------------
#	Analysis

.PHONY: lint
lint: ##@analysis Lint static analysis (pc-lint).
lint: version $(TMP_DIR)gcc-include-path.lnt $(TMP_DIR)temp.lnt \
								$(TMP_DIR)lint_cmac.h $(TMP_DIR)lint_cppmac.h
ifndef WINE_EXISTS
	$(error "Please install 'wine and pc-lint'!")
endif
	@echo
	@wine ~/opt/Pc-lint/lint-nt.exe -i$(TMP_DIR) \
									-iconf/pc-lint/ \
									-iconf/pc-lint/gcc_x86_64 \
									options.lnt \
									temp.lnt \
									au-ds.lnt \
									-i$(INC_DIR) \
									$(C_SRCs) | tr '\\\r' '/ '
	@echo
	$(PASS)

.PHONY: barr10
barr10: ##@analysis Lint static analysis for barr10 coding standard (pc-lint).
barr10: version $(TMP_DIR)gcc-include-path.lnt $(TMP_DIR)temp.lnt \
								$(TMP_DIR)lint_cmac.h $(TMP_DIR)lint_cppmac.h
ifndef WINE_EXISTS
	$(error "Please install 'wine and pc-lint'!")
endif
	@echo
	@wine ~/opt/Pc-lint/lint-nt.exe -i$(TMP_DIR) \
									-iconf/pc-lint/ \
									-iconf/pc-lint/gcc_x86_64 \
									options.lnt \
									au-barr10.lnt \
									temp.lnt \
									-i$(INC_DIR) \
									$(C_SRCs) | tr '\\\r' '/ '
	@echo
	$(PASS)

.PHONY: netrino
netrino: ##@analysis Lint static analysis for netrino coding standard (pc-lint).
netrino: version $(TMP_DIR)gcc-include-path.lnt $(TMP_DIR)temp.lnt \
								$(TMP_DIR)lint_cmac.h $(TMP_DIR)lint_cppmac.h
ifndef WINE_EXISTS
	$(error "Please install 'wine and pc-lint'!")
endif
	@echo
	@wine ~/opt/Pc-lint/lint-nt.exe -i$(TMP_DIR) \
									-iconf/pc-lint/ \
									-iconf/pc-lint/gcc_x86_64 \
									options.lnt \
									au-netrino.lnt \
									temp.lnt \
									-i$(INC_DIR) \
									$(C_SRCs) | tr '\\\r' '/ '
	@echo
	$(PASS)

.PHONY: misrac98
misrac98: ##@analysis Lint static analysis for MISRA-C 1998 (pc-lint).
misrac98: version $(TMP_DIR)gcc-include-path.lnt $(TMP_DIR)temp.lnt \
								$(TMP_DIR)lint_cmac.h $(TMP_DIR)lint_cppmac.h
ifndef WINE_EXISTS
	$(error "Please install 'wine and pc-lint'!")
endif
	@echo
	@wine ~/opt/Pc-lint/lint-nt.exe -i$(TMP_DIR) \
									-iconf/pc-lint/ \
									-iconf/pc-lint/gcc_x86_64 \
									options.lnt \
									au-misra1.lnt \
									temp.lnt \
									-i$(INC_DIR) \
									$(C_SRCs) | tr '\\\r' '/ '
	@echo
	$(PASS)

.PHONY: misrac04
misrac04: ##@analysis Lint static analysis for MISRA-C 2004 (pc-lint).
misrac04: version $(TMP_DIR)gcc-include-path.lnt $(TMP_DIR)temp.lnt \
								$(TMP_DIR)lint_cmac.h $(TMP_DIR)lint_cppmac.h
ifndef WINE_EXISTS
	$(error "Please install 'wine and pc-lint'!")
endif
	@echo
	@wine ~/opt/Pc-lint/lint-nt.exe -i$(TMP_DIR) \
									-iconf/pc-lint/ \
									-iconf/pc-lint/gcc_x86_64 \
									options.lnt \
									au-misra2.lnt \
									temp.lnt \
									-i$(INC_DIR) \
									$(C_SRCs) | tr '\\\r' '/ '
	@echo
	$(PASS)

.PHONY: misrac12
misrac12: ##@analysis Lint static analysis for MISRA-C 2012 (pc-lint).
misrac12: version $(TMP_DIR)gcc-include-path.lnt $(TMP_DIR)temp.lnt \
								$(TMP_DIR)lint_cmac.h $(TMP_DIR)lint_cppmac.h
ifndef WINE_EXISTS
	$(error "Please install 'wine and pc-lint'!")
endif
	@echo
	@wine ~/opt/Pc-lint/lint-nt.exe -i$(TMP_DIR) \
									-iconf/pc-lint/ \
									-iconf/pc-lint/gcc_x86_64 \
									options.lnt \
									au-misra3.lnt \
									temp.lnt \
									-i$(INC_DIR) \
									$(C_SRCs) | tr '\\\r' '/ '
	@echo
	$(PASS)

$(TMP_DIR)lint_cmac.h: | $(TMP_DIR)
	$(CREATED)
	@echo			-n "$@ \t"
	@rm				-fR $(TMP_DIR)empty.c
	@touch			$(TMP_DIR)empty.c
	@$(CC)			-E -dM $(TMP_DIR)empty.c >$@
	@rm				-fR $(TMP_DIR)empty.c
	$(PASS)

$(TMP_DIR)lint_cppmac.h: | $(TMP_DIR)
	$(CREATED)
	@echo			-n "$@ \t"
	@rm				-fR $(TMP_DIR)empty.cpp
	@touch			$(TMP_DIR)empty.cpp
	@$(CXX)			-E -dM $(TMP_DIR)empty.cpp >$@
	@rm				-fR $(TMP_DIR)empty.cpp
	$(PASS)

$(TMP_DIR)gcc-include-path.lnt: | $(TMP_DIR)
	$(CREATED)
	@echo			-n "$@ \t"
	@./scripts/pclint_settings
	$(PASS)

$(TMP_DIR)temp.lnt: | $(TMP_DIR)
	$(CREATED)
	@echo			-n "$@ \t"
	@touch			$@
	$(PASS)

# Create bin directory
$(TMP_DIR):
	$(CREATED)
	@echo			-n "$@ \t"
	@mkdir			-p $@
	$(PASS)

.PHONY: valgrind
valgrind: ##@analysis Valgrind dynamic analysis.
valgrind: build
ifndef VALGRIND_EXISTS
	$(error "Please install 'valgrind' dynamical analyser!")
endif
ifeq ($(PLATFORM),host)
	@valgrind		$(BIN_DIR)$(TARGET_DIR)$(EXEC).elf
else
	$(error "Not implemented for target!")
endif

.PHONY: todo
todo: ##@analysis Check for programmer notes in code.
	@egrep			-nr -Rw --color 'bug|BUG|Bug' $(SRC_DIR) $(INC_DIR)
	@egrep			-nr -Rw --color 'todo|TODO|Todo' $(SRC_DIR) $(INC_DIR)
	@egrep			-nr -Rw --color 'test|TEST|Test' $(SRC_DIR) $(INC_DIR)

#-------------------------------------------------------------------------------
#	Run, flash, erase, debug

.PHONY: run
run: ##@live Runs the program.
run: build
ifeq ($(PLATFORM),host)
	@./$(BIN_DIR)$(TARGET_DIR)$(EXEC).elf
endif
ifeq ($(PLATFORM),target)
	@sudo			-v
	@sudo chmod		777 /dev/ttyACM0
	@sleep			.5
	clear
	@picocom		-b 115200 --flow=none --echo --imap lfcrlf \
												 --omap crlf /dev/ttyACM0
endif

.PHONY: flash
flash: ##@live Flashes the mcu.
flash: build
ifeq ($(PLATFORM),target)
	@echo			"Flashing MCU"
	@JLinkExe		-commanderscript conf/jlink/download.jlink
	$(PASS)
	@echo
else
	$(error "Can not flash target in host mode!")
endif

.PHONY: erase
erase: ##@live Erases the mcu.
	@echo			"Erasing MCU"
	@JLinkExe		-commanderscript conf/jlink/erase.jlink
	$(PASS)
	@echo

.PHONY: debug
debug: ##@live Debug the program.
debug: build
ifeq ($(PLATFORM),host)
	@gdb			$(BIN_DIR)$(TARGET_DIR)$(EXEC).elf
else
	$(error "Not implemented for target!")
endif

#-------------------------------------------------------------------------------
#	 _____      _   _                               _           
#	|  __ \    | | | |                             | |          
#	| |__) |_ _| |_| |_ ___ _ __ _ __    _ __ _   _| | ___  ___ 
#	|  ___/ _` | __| __/ _ \ '__| '_ \  | '__| | | | |/ _ \/ __|
#	| |  | (_| | |_| ||  __/ |  | | | | | |  | |_| | |  __/\__ \
#	|_|   \__,_|\__|\__\___|_|  |_| |_| |_|   \__,_|_|\___||___/
#
#-------------------------------------------------------------------------------

################################################################################
################		Target/Host Patterns		############################
################################################################################

# List of C objects
ifneq ($(C_SRCs),)
  OBJECTS += $(addprefix $(OBJ_DIR)$(TARGET_DIR),$(notdir $(C_SRCs:.c=.o)))
  vpath %.c $(sort $(dir $(C_SRCs)))
endif
# List of assembly objects
ifneq ($(ASM_SRCs),)
  OBJECTS += $(addprefix $(OBJ_DIR)$(TARGET_DIR),$(notdir $(ASM_SRCs:.s=.o)))
  vpath %.s $(sort $(dir $(ASM_SRCs)))
endif

# Build elf program
$(BIN_DIR)$(TARGET_DIR)$(EXEC).elf: $(OBJECTS) | $(BIN_DIR)$(TARGET_DIR)
	$(COMP_MSG)
	@echo			-n "$@ \t"
	@$(CC)			$(OBJECTS) $(LDFLAGS) -o $@
	$(PASS)

# Create build environment directory
$(BIN_DIR)$(TARGET_DIR): | $(BIN_DIR)
	$(CREATED)
	@echo			-n "$@ \t"
	@mkdir			-p $@
	$(PASS)

# Create bin directory
$(BIN_DIR):
	$(CREATED)
	@echo			-n "$@ \t"
	@mkdir			-p $@
	$(PASS)

# Create object from C source code
$(OBJ_DIR)$(TARGET_DIR)%.o: %.c | $(OBJ_DIR)$(TARGET_DIR)
	$(COMP_MSG)
	@echo			-n "$@ \t"
	@$(CC)			-c $(CFLAGS) -Wa,-a,-ad,-alms=$(OBJ_DIR)$(TARGET_DIR)$(notdir $(<:.c=.lst)) $< -o $@
	$(PASS)

# Create object from Assembly source code
$(OBJ_DIR)$(TARGET_DIR)%.o: %.s | $(OBJ_DIR)$(TARGET_DIR)
	$(COMP_MSG)
	@echo			-n "$@ \t"
	@$(AS)			-c $(ASFLAGS) $< -o $@
	$(PASS)

# Create obj build environment directory
$(OBJ_DIR)$(TARGET_DIR): | $(OBJ_DIR)
	$(CREATED)
	@echo			-n "$@ \t"
	@mkdir			-p $@
	$(PASS)

# Create obj directory
$(OBJ_DIR):
	$(CREATED)
	@echo			-n "$@ \t"
	@mkdir			-p $@
	$(PASS)

# Create hex program
$(BIN_DIR)$(TARGET_DIR)%.hex: $(BIN_DIR)$(TARGET_DIR)%.elf | $(BIN_DIR)$(TARGET_DIR)
	$(COMP_MSG)
	@echo			-n "$@ \t"
	@$(HEX)			$< $@
	$(PASS)

# Create bin program
$(BIN_DIR)$(TARGET_DIR)%.bin: $(BIN_DIR)$(TARGET_DIR)%.elf | $(BIN_DIR)$(TARGET_DIR)
	$(COMP_MSG)
	@echo			-n "$@ \t"
	@$(BIN)			$< $@
	$(PASS)

################################################################################
################		Test Patterns		####################################
################################################################################

# List of C++ objects
ifneq ($(TEST_CXX_SRCs),)
  TEST_OBJECTS += \
  		$(addprefix $(OBJ_DIR)$(TESTS_DIR),$(notdir $(TEST_CXX_SRCs:.cpp=.o)))
  vpath %.cpp $(sort $(dir $(TEST_CXX_SRCs)))
endif

# List of C objects
ifneq ($(TEST_C_SRCs),)
  TEST_OBJECTS += \
  		$(addprefix $(OBJ_DIR)$(TESTS_DIR),$(notdir $(TEST_C_SRCs:.c=.o)))
  vpath %.c $(sort $(dir $(TEST_C_SRCs)))
endif

# Build test program
$(BIN_DIR)$(TESTS_DIR)$(TESTS_EXEC): $(TEST_OBJECTS) | $(BIN_DIR)$(TESTS_DIR)
	$(COMP_MSG)
	@echo			-n "$@ \t"
	@$(HOST_CXX)	$(TEST_OBJECTS) $(TEST_LDFLAGS) -o $@
	$(PASS)
	@echo
	@$(HOST_SZ)		$(BIN_DIR)$(TESTS_DIR)$(TESTS_EXEC)

# Create bin/test directory
$(BIN_DIR)$(TESTS_DIR): | $(BIN_DIR)
	$(CREATED)
	@echo			-n "$@ \t"
	@mkdir			-p $@
	$(PASS)

# Create object from C++ source code
$(OBJ_DIR)$(TESTS_DIR)%.o: %.cpp | $(OBJ_DIR)$(TESTS_DIR)
	$(COMP_MSG)
	@echo			-n "$@ \t"
	@$(HOST_CXX)	-c $(TEST_CXXFLAGS) -Wa,-a,-ad,-alms=$(OBJ_DIR)$(TESTS_DIR)$(notdir $(<:.cpp=.lst)) $< -o $@
	$(PASS)

# Create object from C source code
$(OBJ_DIR)$(TESTS_DIR)%.o: %.c | $(OBJ_DIR)$(TESTS_DIR)
	$(COMP_MSG)
	@echo			-n "$@ \t"
	@$(HOST_CXX)	-c $(TEST_CFLAGS) -Wa,-a,-ad,-alms=$(OBJ_DIR)$(TESTS_DIR)$(notdir $(<:.c=.lst)) $< -o $@
	$(PASS)

# Create obj/test directory
$(OBJ_DIR)$(TESTS_DIR): | $(OBJ_DIR)
	$(CREATED)
	@echo			-n "$@ \t"
	@mkdir			-p $@
	$(PASS)

################################################################################
################		TODO		############################################
################################################################################
# DEP_DIR =					.dep/
# -include $(shell mkdir $(DEP_DIR) 2>/dev/null) $(wildcard $(DEP_DIR)*)

# *** EOF ***
