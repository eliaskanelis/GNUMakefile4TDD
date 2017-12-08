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
#          |   |    Github:    TediCreations/GNUMakefile4TDD |    |
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
#	USER_CXX_INCs		C++ include directories.		(TODO)
#	USER_CXX_SRCs		C++ source directories.			(TODO)
#	USER_C_INCs			C include directories.			
#	USER_C_SRCs			C source directories.			
#	USER_ASM_INCs		Assembry include directories.	
#	USER_ASM_SRCs		Assembry source directories.	
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

################################################################################
#	  _______          _             _     _       
#	 |__   __|        | |           (_)   | |      
#	    | | ___   ___ | |   _____  ___ ___| |_ ___ 
#	    | |/ _ \ / _ \| |  / _ \ \/ / / __| __/ __|
#	    | | (_) | (_) | | |  __/>  <| \__ \ |_\__ \
#	    |_|\___/ \___/|_|  \___/_/\_\_|___/\__|___/
#
#

GCC_EXISTS :=		$(shell command -v gcc 2> /dev/null)
GPP_EXISTS :=		$(shell command -v g++ 2> /dev/null)
GDB_EXISTS :=		$(shell command -v gdb 2> /dev/null)
WINE_EXISTS :=		$(shell command -v wine 2> /dev/null)
VALGRIND_EXISTS :=	$(shell command -v valgrind 2> /dev/null)
PERL_EXISTS :=		$(shell command -v perl 2> /dev/null)
GIT_EXISTS :=		$(shell command -v git 2> /dev/null)
DOXYGEN_EXISTS :=	$(shell command -v doxygen 2> /dev/null)
DOT_EXISTS :=		$(shell command -v dot 2> /dev/null)
JLINK_EXISTS :=		$(shell command -v JLinkExe 2> /dev/null)
SALEAE_EXISTS :=	$(shell command -v Saleae 2> /dev/null)
PICOCOM_EXISTS :=	$(shell command -v picocom 2> /dev/null)
CHROMIUM_EXISTS :=	$(shell command -v chromium-browser 2> /dev/null)

################################################################################
#	  _____           _           _   
#	 |  __ \         (_)         | |  
#	 | |__) | __ ___  _  ___  ___| |_ 
#	 |  ___/ '__/ _ \| |/ _ \/ __| __|
#	 | |   | | | (_) | |  __/ (__| |_ 
#	 |_|   |_|  \___/| |\___|\___|\__|
#	                _/ |              
#	               |__/               
#
#

# Name of the build output
EXEC ?=				demo

# Name of the test build output
TESTS_EXEC ?=		runAlltests

# Project version
ifdef GIT_EXISTS
  PROJECT_NUMBER ?=	$(shell git describe --always \
						--dirty=" (with uncommitted changes)" --long --tags)
endif

#-------------------------------------------------------------------------------
#						Build target options

# Build mode options
BUILD_MODE ?=		debug
ifneq ($(BUILD_MODE),debug)
  ifneq ($(PLATFORM),release)
    $(error "BUILD_MODE" variable can not be "$(BUILD_MODE)")
  endif
endif

#...............................................#

# Platform options
PLATFORM ?=			host
ifneq ($(PLATFORM),target)
  ifneq ($(PLATFORM),host)
    $(error "PLATFORM" variable can not be "$(PLATFORM)")
  endif
endif

#...............................................#
# Target name

#For target
ifeq ($(PLATFORM),target)
  TARGET_NAME =		$(TARGET_CPU)
endif

# For host
ifeq ($(PLATFORM),host)
    TARGET_NAME = 	$(shell uname --machine)
endif

#...............................................#
# Folder structure

BIN_DIR :=			bin/
OBJ_DIR :=			obj/
INC_DIR :=			inc/
SRC_DIR :=			src/
DOC_DIR :=			doc/
TMP_DIR :=			tmp/
LIB_DIR :=			lib/
TESTS_DIR := 		tests/
PORT_DIR :=			port/

TARGET_DIR = 		$(TARGET_NAME)/

#TODO: Implement on pattern rules
#BUILD_MODE_DIR = 	$(BUILD_MODE)/

#TARGET_BIN_DIR := 	$(BIN_DIR)$(TARGET_DIR)$(BUILD_MODE_DIR)
#TARGET_OBJ_DIR := 	$(OBJ_DIR)$(TARGET_DIR)$(BUILD_MODE_DIR)
#TESTS_BIN_DIR := 	$(BIN_DIR)$(TESTS_DIR)
#TESTS_OBJ_DIR := 	$(OBJ_DIR)$(TESTS_DIR)

################################################################################
#	 _____           _     
#	|_   _|__   ___ | |___ 
#	  | |/ _ \ / _ \| / __|
#	  | | (_) | (_) | \__ \
#	  |_|\___/ \___/|_|___/
#	                       
#

# Host
CC.host =			gcc
CXX.host =			g++
AS.host =			gcc -x assembler-with-cpp
CP.host =			objcopy
AR.host =			ar
SZ.host =			size
HEX.host =			$(CP.host) -O ihex
BIN.host =			$(CP.host) -O binary -S

# Target
ifeq ($(PLATFORM),target)
  TARGET_TC_PATH ?=	
  TARGET_TC_PREFIX ?=	arm-none-eabi-
endif
CC.target =			$(TARGET_TC_PATH)$(TARGET_TC_PREFIX)gcc
CXX.target =		$(TARGET_TC_PATH)$(TARGET_TC_PREFIX)g++
AS.target =			$(TARGET_TC_PATH)$(TARGET_TC_PREFIX)gcc\
													-x assembler-with-cpp
CP.target =			$(TARGET_TC_PATH)$(TARGET_TC_PREFIX)objcopy
AR.target =			$(TARGET_TC_PATH)$(TARGET_TC_PREFIX)ar
SZ.target =			$(TARGET_TC_PATH)$(TARGET_TC_PREFIX)size
HEX.target =		$(CP.target) -O ihex
BIN.target =		$(CP.target) -O binary -S

# Toolchain
#TODO: Compile paraller host/target
ifeq ($(PLATFORM),host)
  CC =				$(CC.host)
  CXX =				$(CXX.host)
  AS =				$(AS.host)
  CP =				$(CP.host)
  AR =				$(AR.host)
  SZ =				$(SZ.host)
  HEX =				$(HEX.host)
  BIN =				$(BIN.host)
else
  CC =				$(CC.target)
  CXX =				$(CXX.target)
  AS =				$(AS.target)
  CP =				$(CP.target)
  AR =				$(AR.target)
  SZ =				$(SZ.target)
  HEX =				$(HEX.target)
  BIN =				$(BIN.target)
endif

# Tools
ECHO =				echo
ECHO_N =			echo -n
MKDIR_P =			mkdir -p
MV_F =				mv -f
RM_FR =				rm -fR
TOUCH =				touch

################################################################################
#	 _    _ _   _ _ _ _   _           
#	| |  | | | (_) (_) | (_)          
#	| |  | | |_ _| |_| |_ _  ___  ___ 
#	| |  | | __| | | | __| |/ _ \/ __|
#	| |__| | |_| | | | |_| |  __/\__ \
#	 \____/ \__|_|_|_|\__|_|\___||___/
#
#

# tput colors for MSG function
MSG_RED :=			1
MSG_GREEN :=		2
MSG_YELLOW :=		3
MSG_BLUE :=			4
MSG_CYAN :=			6
MSG_WHITE :=		7

COLORS ?= YES
ifneq ($(COLORS),YES)
  ifneq ($(COLORS),NO)
    $(error "COLORS" variable can not be "$(COLORS)")
  endif
endif

ifeq ($(COLORS),NO)

  # Show a msg with color
  # use $(call MSG,"msg",colorNum)
  define MSG
    @$(ECHO_N)		$1
  endef

  # TPUT COLORS
  TPUT_RED :=		
  TPUT_GREEN :=		
  TPUT_WHITE :=		
  TPUT_YELLOW :=	
  TPUT_RESET :=		

  # Messages
  PASS:=			@$(ECHO) "OK"
  BUILD_OK:=		@$(ECHO) "Build successfully!"

  COMPILING:=		@$(ECHO_N) "Compiling "
  BUILDING:=		@$(ECHO_N) "Building  "

else

  # Show a msg with color
  # use $(call MSG,"msg",colorNum)
  define MSG
    @tput bold
    @tput -Txterm setaf $2
    @$(ECHO_N)		$1
    @tput -Txterm sgr0
  endef

  # TPUT COLORS
  TPUT_RED :=		$(shell tput -Txterm setaf 1)
  TPUT_GREEN :=		$(shell tput -Txterm setaf 2)
  TPUT_WHITE :=		$(shell tput -Txterm setaf 7)
  TPUT_YELLOW :=	$(shell tput -Txterm setaf 3)
  TPUT_RESET :=		$(shell tput -Txterm sgr0)

  # Messages
  PASS:=			@tput bold && tput -Txterm setaf 2 \
							   && $(ECHO) "OK" \
							   && tput -Txterm sgr0
  BUILD_OK:=		@tput bold && tput -Txterm setaf 2 \
							   && $(ECHO) "Build successfully!" \
							   && tput -Txterm sgr0

  COMPILING:=		@tput bold && tput -Txterm setaf 3 \
							   && $(ECHO_N) "Compiling " \
							   && tput -Txterm sgr0
  BUILDING:=		@tput bold && tput -Txterm setaf 6 \
							   && $(ECHO_N) "Building  " \
							   && tput -Txterm sgr0
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
	print "Usage: make $(TPUT_YELLOW)[target]$(TPUT_RESET)\n\n"; \
	for ( sort keys %help ) { \
		print "$(TPUT_WHITE)$$_:$(TPUT_RESET)\n"; \
		printf("  $(TPUT_YELLOW)%-20s$(TPUT_RESET) \
						$(TPUT_GREEN)%s$(TPUT_RESET)\n", $$_->[0], \
						$$_->[1]) for @{$$help{$$_}}; \
		print "\n"; \
	}

################################################################################
#	 _____                            _                 _           
#	|  __ \                          | |               (_)          
#	| |  | | ___ _ __   ___ _ __   __| | ___ _ __   ___ _  ___  ___ 
#	| |  | |/ _ \ '_ \ / _ \ '_ \ / _` |/ _ \ '_ \ / __| |/ _ \/ __|
#	| |__| |  __/ |_) |  __/ | | | (_| |  __/ | | | (__| |  __/\__ \
#	|_____/ \___| .__/ \___|_| |_|\__,_|\___|_| |_|\___|_|\___||___/
#	            | |                                                 
#	            |_|                                                 
#
#

# Auxiliary files that build depends on
AUX = 				Makefile

# Include directories
INCLUDES =			-I$(SRC_DIR) -I$(PORT_DIR) -I$(TARGET_DIR) -I$(INC_DIR)
INCLUDES +=			$(USER_INCLUDES)

#...............................................#

# C++ source files
CXX_SRCs :=			$(shell find $(SRC_DIR) -name "*.cpp")
CXX_SRCs +=			$(shell find $(PORT_DIR)$(TARGET_DIR) -name "*.cpp")
CXX_SRCs +=			$(USER_CXX_SRCs)

# C source files
C_SRCs :=			$(shell find $(SRC_DIR) -name "*.c")
C_SRCs +=			$(shell find $(PORT_DIR)$(TARGET_DIR) -name "*.c")
C_SRCs +=			$(USER_C_SRCs)

# Assembly source files
AS_SRCs :=			$(shell find $(SRC_DIR) -name "*.s")
AS_SRCs +=			$(shell find $(PORT_DIR)$(TARGET_DIR) -name "*.s")
AS_SRCs +=			$(USER_AS_SRCs)

# Object files
OBJECTS =			$(addprefix $(OBJ_DIR)$(TARGET_DIR),$(CXX_SRCs:%.cpp=%.o))
OBJECTS +=			$(addprefix $(OBJ_DIR)$(TARGET_DIR),$(C_SRCs:%.c=%.o))
OBJECTS +=			$(addprefix $(OBJ_DIR)$(TARGET_DIR),$(AS_SRCs:%.s=%.o))	

#...............................................#

# Tests C++ source files
TEST_CXX_SRCs :=	$(shell find $(SRC_DIR) ! -name "*main.cpp" -name "*.cpp")
TEST_CXX_SRCs +=	$(shell find $(TESTS_DIR) -name "*.cpp")
TEST_CXX_SRCs +=	$(shell find $(PORT_DIR)x86_64/ -name "*.cpp")
TEST_CXX_SRCs +=	$(USER_TEST_CXX_SRCs)

# Tests C source files
TEST_C_SRCs :=		$(shell find $(SRC_DIR) ! -name "*main.c" -name "*.c")
TEST_C_SRCs +=		$(shell find $(TESTS_DIR) -name "*.c")
TEST_C_SRCs +=		$(shell find $(PORT_DIR)x86_64/ -name "*.c")
TEST_C_SRCs +=		$(USER_TEST_C_SRCs)

# Tests Object files
TEST_OBJECTS =		$(addprefix $(OBJ_DIR)$(TESTS_DIR),$(TEST_CXX_SRCs:%.cpp=%.o))
TEST_OBJECTS +=		$(addprefix $(OBJ_DIR)$(TESTS_DIR),$(TEST_C_SRCs:%.c=%.o))

################################################################################
#	  ____              _____ _                 
#	 / ___| _     _    |  ___| | __ _  __ _ ___ 
#	| |   _| |_ _| |_  | |_  | |/ _` |/ _` / __|
#	| |__|_   _|_   _| |  _| | | (_| | (_| \__ \
#	 \____||_|   |_|   |_|   |_|\__,_|\__, |___/
#	                                  |___/ 
#

# Default compiler C++ flags
CXXFLAGS =			

# User spesified compiler C++ flags
CXXFLAGS +=			$(USER_CXXFLAGS)

################################################################################
#	  ____   _____ _                 
#	 / ___| |  ___| | __ _  __ _ ___ 
#	| |     | |_  | |/ _` |/ _` / __|
#	| |___  |  _| | | (_| | (_| \__ \
#	 \____| |_|   |_|\__,_|\__, |___/
#	                       |___/ 
#

# Default compiler C flags
CFLAGS =			

# User spesified compiler C flags
CFLAGS +=			$(USER_CFLAGS)

################################################################################
#	    _                           _     _             _____ _                 
#	   / \   ___ ___  ___ _ __ ___ | |__ | | ___ _ __  |  ___| | __ _  __ _ ___ 
#	  / _ \ / __/ __|/ _ \ '_ ` _ \| '_ \| |/ _ \ '__| | |_  | |/ _` |/ _` / __|
#	 / ___ \\__ \__ \  __/ | | | | | |_) | |  __/ |    |  _| | | (_| | (_| \__ \
#	/_/   \_\___/___/\___|_| |_| |_|_.__/|_|\___|_|    |_|   |_|\__,_|\__, |___/
#	                                                                  |___/    
#

# Default assembler flags
ASFLAGS =			

# User spesified assembler flags
ASFLAGS +=			$(USER_ASFLAGS)

################################################################################
#	 ____                   __                _____ _                 
#	|  _ \ _ __ ___ _ __   / /__  ___  _ __  |  ___| | __ _  __ _ ___ 
#	| |_) | '__/ _ \ '_ \ / / __|/ _ \| '__| | |_  | |/ _` |/ _` / __|
#	|  __/| | |  __/ |_) / /\__ \ (_) | |    |  _| | | (_| | (_| \__ \
#	|_|   |_|  \___| .__/_/ |___/\___/|_|    |_|   |_|\__,_|\__, |___/
#	               |_|                                      |___/   
#	

# Warnings and error notification
CPPFLAGS =			-w\
					-Wall\
					-Werror

# Debug flags
ifeq ($(BUILD_MODE),release)
  # Optimization
  CPPFLAGS +=		-O3
  CPPFLAGS +=		-DNDEBUG
else
  # Debug flags
  CPPFLAGS +=		-g -gdwarf-2
  CPPFLAGS +=		-DDEBUG

  # Optimization
  CPPFLAGS +=		-Og
endif

# Compilation options
CPPFLAGS +=			-fdata-sections\
					-ffunction-sections

  # CPU architecture
ifeq ($(PLATFORM),target)
  ifeq ($(TARGET_CPU),)
    $(error "TARGET_CPU" is not set)
  endif
  TARGET_FPU ?=		
  TARGET_FLOAT_ABI ?=
  CPPFLAGS +=		-mcpu=$(TARGET_CPU)\
					-mthumb $(TARGET_FPU)\
					$(TARGET_FLOAT_ABI)
endif

# Dependency flags
CPPFLAGS +=			-MT $@ -MMD -MP -MF $(OBJ_DIR)$(TARGET_DIR)$*.Td
#CPPFLAGS +=			-MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)"

# Include directories
CPPFLAGS +=			$(INCLUDES)

# User spesified compiler preprossesor flags
CPPFLAGS +=			$(USER_CPPFLAGS)

################################################################################
#	 _     _       _               _____ _                 
#	| |   (_)_ __ | | _____ _ __  |  ___| | __ _  __ _ ___ 
#	| |   | | '_ \| |/ / _ \ '__| | |_  | |/ _` |/ _` / __|
#	| |___| | | | |   <  __/ |    |  _| | | (_| | (_| \__ \
#	|_____|_|_| |_|_|\_\___|_|    |_|   |_|\__,_|\__, |___/
#	                                             |___/   
# 

# Linker flags
LDFLAGS =			-L$(LIB_DIR)\
					-lc\
					-lm

# Target linker flags
ifeq ($(PLATFORM),target)

  # CPU architecture
  ifeq ($(TARGET_CPU),)
    $(error "TARGET_CPU" is not set)
  endif
  TARGET_FPU ?=		
  TARGET_FLOAT_ABI ?=
  LDFLAGS +=		-mcpu=$(TARGET_CPU)\
					-mthumb $(TARGET_FPU)\
					$(TARGET_FLOAT_ABI)

  # Linker script
  ifeq ($(TARGET_LDSCRIPT),)
    $(error "A linker script is required!")
  endif
  LDFLAGS +=		-T$(TARGET_LDSCRIPT)

  # Linker flags
  LDFLAGS += 		-specs=nano.specs\
					-lnosys\
					-lrdimon -u _printf_float\
					-Wl,-Map=$(BIN_DIR)$(TARGET_DIR)$(EXEC).map,--cref\
					-Wl,--gc-sections
endif

LDFLAGS +=			$(USER_LDFLAGS)

################################################################################
#	 _____ _____ ____    _____ _                 
#	|_   _|_   _|  _ \  |  ___| | __ _  __ _ ___ 
#	  | |   | | | | | | | |_  | |/ _` |/ _` / __|
#	  | |   | | | |_| | |  _| | | (_| | (_| \__ \
#	  |_|   |_| |____/  |_|   |_|\__,_|\__, |___/
#	                                   |___/  
#

CPPUTEST_DIR ?=			

TEST_CXXFLAGS =		-I"$(CPPUTEST_DIR)include/"\
					-I"$(CPPUTEST_DIR)include/CppUTest/\
									MemoryLeakDetectorNewMacros.h"

TEST_CFLAGS =		-I"$(CPPUTEST_DIR)include/"\
					-I"$(CPPUTEST_DIR)include/CppUTest/\
									MemoryLeakDetectorMallocMacros.h"

TEST_CPPFLAGS +=	$(INCLUDES)

TEST_LDFLAGS =		-L"$(CPPUTEST_DIR)cpputest_build/lib/"\
					-lCppUTest\
					-lCppUTestExt

################################################################################
#	 _____  _                                    _           
#	|  __ \| |                                  | |          
#	| |__) | |__   ___  _ __  _   _   _ __ _   _| | ___  ___ 
#	|  ___/| '_ \ / _ \| '_ \| | | | | '__| | | | |/ _ \/ __|
#	| |    | | | | (_) | | | | |_| | | |  | |_| | |  __/\__ \
#	|_|    |_| |_|\___/|_| |_|\__, | |_|   \__,_|_|\___||___/
#	                           __/ |                         
#	                          |___/                          
#
#

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
				$(BIN_DIR)$(TARGET_DIR)$(EXEC).bin \
				runalltests \
				size
	@$(ECHO)
	$(BUILD_OK)
	@$(ECHO)

.PHONY: version
version: ##@options Runs a script to generate inc/version.h
	$(call 			MSG,"\nBuilding: $(EXEC) ",$(MSG_GREEN))
	$(call 			MSG,"$(BUILD_MODE)",$(MSG_YELLOW))
	@$(ECHO_N)		" @ "
	$(call 			MSG,"$(TARGET_NAME)\n\n",$(MSG_RED))
	$(call 			MSG,"Version   \t",$(MSG_WHITE))
	@scripts/get_version.sh 1>/dev/null
	$(PASS)

.PHONY: size
size: ##@options Measures program.
size: $(BIN_DIR)$(TARGET_DIR)$(EXEC).elf
	@$(ECHO)
	@$(SZ)			$<

.PHONY: clean
clean: ##@options Cleans the project.
	@$(ECHO_N)		"Cleaning $(EXEC) project\t"
	@$(RM_FR)		$(OBJ_DIR)
	@$(RM_FR)		$(BIN_DIR)
	@$(RM_FR)		$(DOC_DIR)
	@$(RM_FR)		$(INC_DIR)version.h
	$(PASS)
	@$(ECHO)

.PHONY: help
help: ##@options Shows a list of all available make options.
ifndef PERL_EXISTS
	$(warning "Please set variable 'COLOR' to NO!")
endif
	@perl 			-e '$(HELP_FUNC)' $(MAKEFILE_LIST)

.PHONY: tools
tools: ##@options Checks if tools used in this Makefile are installed.
	@$(ECHO_N) 		"Checking tools\t"
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
	@$(ECHO)

#...............................................#
#	Test driven development

.PHONY: runalltests
runalltests: ##@tests Run all tests.
runalltests: version $(BIN_DIR)$(TESTS_DIR)$(TESTS_EXEC)
	$(call MSG,"\nCppUTest",$(MSG_YELLOW))
	@./$(BIN_DIR)$(TESTS_DIR)$(TESTS_EXEC) -c
	@$(ECHO)

#...............................................#
#	Documentation

# Get version number from git
# https://christianhujer.github.io/Git-Version-in-Doxygen/
# TODO: Add port/ and build for TARGET_DIR
.PHONY: doc
doc: ##@doc Generates documentation.
doc: export PROJECT_NUMBER ?=	Beta
doc: export PROJECT_NAME ?=		Untitled
doc: export PROJECT_BRIEF ?=	
doc:
	@$(ECHO)
	@$(ECHO)		"Building documentation"
	@$(MKDIR_P)		$(DOC_DIR)html
	@(cd conf/doxygen/ && doxygen)
	$(PASS)
	@$(ECHO)

.PHONY: show
show: ##@doc Shows documentation.
show: doc
ifdef CHROMIUM_EXISTS
	@chromium-browser $(DOC_DIR)html/index.html >>/dev/null
else
	$(warning "Please install 'chromium-browser'!")
endif

#...............................................#
#	Analysis

.PHONY: lint
lint: ##@analysis Lint static analysis (pc-lint).
lint: version $(TMP_DIR)gcc-include-path.lnt $(TMP_DIR)temp.lnt \
								$(TMP_DIR)lint_cmac.h $(TMP_DIR)lint_cppmac.h
ifndef WINE_EXISTS
	$(error "Please install 'wine and pc-lint'!")
endif
	@$(ECHO)
	@wine ~/opt/Pc-lint/lint-nt.exe -i$(TMP_DIR) \
									-iconf/pc-lint/ \
									-iconf/pc-lint/gcc_x86_64 \
									au-ds.lnt \
									au-barr10.lnt \
									au-netrino.lnt \
									au-misra1.lnt \
									au-misra2.lnt \
									au-misra3.lnt \
									options.lnt \
									temp.lnt \
									$(INCLUDES) \
									$(C_SRCs) | tr '\\\r' '/ '
	@$(ECHO)
	$(PASS)

.PHONY: barr10
barr10: ##@analysis Lint static analysis for barr10 coding standard (pc-lint).
barr10: version $(TMP_DIR)gcc-include-path.lnt $(TMP_DIR)temp.lnt \
								$(TMP_DIR)lint_cmac.h $(TMP_DIR)lint_cppmac.h
ifndef WINE_EXISTS
	$(error "Please install 'wine and pc-lint'!")
endif
	@$(ECHO)
	@wine ~/opt/Pc-lint/lint-nt.exe -i$(TMP_DIR) \
									-iconf/pc-lint/ \
									-iconf/pc-lint/gcc_x86_64 \
									au-barr10.lnt \
									options.lnt \
									temp.lnt \
									$(INCLUDES) \
									$(C_SRCs) | tr '\\\r' '/ '
	@$(ECHO)
	$(PASS)

.PHONY: netrino
netrino: ##@analysis Lint static analysis for netrino coding standard (pc-lint).
netrino: version $(TMP_DIR)gcc-include-path.lnt $(TMP_DIR)temp.lnt \
								$(TMP_DIR)lint_cmac.h $(TMP_DIR)lint_cppmac.h
ifndef WINE_EXISTS
	$(error "Please install 'wine and pc-lint'!")
endif
	@$(ECHO)
	@wine ~/opt/Pc-lint/lint-nt.exe -i$(TMP_DIR) \
									-iconf/pc-lint/ \
									-iconf/pc-lint/gcc_x86_64 \
									au-netrino.lnt \
									options.lnt \
									temp.lnt \
									$(INCLUDES) \
									$(C_SRCs) | tr '\\\r' '/ '
	@$(ECHO)
	$(PASS)

.PHONY: misrac98
misrac98: ##@analysis Lint static analysis for MISRA-C 1998 (pc-lint).
misrac98: version $(TMP_DIR)gcc-include-path.lnt $(TMP_DIR)temp.lnt \
								$(TMP_DIR)lint_cmac.h $(TMP_DIR)lint_cppmac.h
ifndef WINE_EXISTS
	$(error "Please install 'wine and pc-lint'!")
endif
	@$(ECHO)
	@wine ~/opt/Pc-lint/lint-nt.exe -i$(TMP_DIR) \
									-iconf/pc-lint/ \
									-iconf/pc-lint/gcc_x86_64 \
									au-misra1.lnt \
									options.lnt \
									temp.lnt \
									$(INCLUDES) \
									$(C_SRCs) | tr '\\\r' '/ '
	@$(ECHO)
	$(PASS)

.PHONY: misrac04
misrac04: ##@analysis Lint static analysis for MISRA-C 2004 (pc-lint).
misrac04: version $(TMP_DIR)gcc-include-path.lnt $(TMP_DIR)temp.lnt \
								$(TMP_DIR)lint_cmac.h $(TMP_DIR)lint_cppmac.h
ifndef WINE_EXISTS
	$(error "Please install 'wine and pc-lint'!")
endif
	@$(ECHO)
	@wine ~/opt/Pc-lint/lint-nt.exe -i$(TMP_DIR) \
									-iconf/pc-lint/ \
									-iconf/pc-lint/gcc_x86_64 \
									au-misra2.lnt \
									options.lnt \
									temp.lnt \
									$(INCLUDES) \
									$(C_SRCs) | tr '\\\r' '/ '
	@$(ECHO)
	$(PASS)

.PHONY: misrac12
misrac12: ##@analysis Lint static analysis for MISRA-C 2012 (pc-lint).
misrac12: version $(TMP_DIR)gcc-include-path.lnt $(TMP_DIR)temp.lnt \
								$(TMP_DIR)lint_cmac.h $(TMP_DIR)lint_cppmac.h
ifndef WINE_EXISTS
	$(error "Please install 'wine and pc-lint'!")
endif
	@$(ECHO)
	@wine ~/opt/Pc-lint/lint-nt.exe -i$(TMP_DIR) \
									-iconf/pc-lint/ \
									-iconf/pc-lint/gcc_x86_64 \
									au-misra3.lnt \
									options.lnt \
									temp.lnt \
									$(INCLUDES) \
									$(C_SRCs) | tr '\\\r' '/ '
	@$(ECHO)
	$(PASS)

$(TMP_DIR)lint_cmac.h: | $(TMP_DIR)
	$(BUILDING)
	@$(ECHO_N)		"$@ \t"
	@$(RM_FR)		$(TMP_DIR)empty.c
	@$(TOUCH)		$(TMP_DIR)empty.c
	@$(CC)			-E -dM $(TMP_DIR)empty.c >$@
	@$(RM_FR)		$(TMP_DIR)empty.c
	$(PASS)

$(TMP_DIR)lint_cppmac.h: | $(TMP_DIR)
	$(BUILDING)
	@$(ECHO_N)		"$@ \t"
	@$(RM_FR)		$(TMP_DIR)empty.cpp
	@$(TOUCH)		$(TMP_DIR)empty.cpp
	@$(CXX)			-E -dM $(TMP_DIR)empty.cpp >$@
	@$(RM_FR)		$(TMP_DIR)empty.cpp
	$(PASS)

$(TMP_DIR)gcc-include-path.lnt: | $(TMP_DIR)
	$(BUILDING)
	@$(ECHO_N)		"$@ \t"
	@./scripts/pclint_settings
	$(PASS)

$(TMP_DIR)temp.lnt: | $(TMP_DIR)
	$(BUILDING)
	@$(ECHO_N)		"$@ \t"
	@$(TOUCH)		$@
	$(PASS)

# Create bin directory
$(TMP_DIR):
	$(BUILDING)
	@$(ECHO_N)		"$@ \t"
	@$(MKDIR_P)		$@
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
  ifndef PICOCOM_EXISTS
	$(error "Please install 'picocom' terminal emulation!")
  endif
	@sudo			-v
	@sudo chmod		777 /dev/ttyACM0
	clear
	@picocom		-b 115200 --flow=none --echo --imap lfcrlf \
												 --omap crlf /dev/ttyACM0
endif

.PHONY: flash
flash: ##@live Flashes the mcu.
flash: build
ifeq ($(PLATFORM),target)
  ifndef JLINK_EXISTS
	  $(error "Please install Segger J-Link drivers!")
  endif
	@$(ECHO)		"Flashing MCU"
	@JLinkExe		-commanderscript conf/jlink/download.jlink
	$(PASS)
	@$(ECHO)
else
	$(error "Not implemented for host!")	
endif

.PHONY: erase
erase: ##@live Erases the mcu.
ifeq ($(PLATFORM),target)
  ifndef JLINK_EXISTS
	  $(error "Please install Segger J-Link drivers!")
  endif
	@$(ECHO)		"Erasing MCU"
	@JLinkExe		-commanderscript conf/jlink/erase.jlink
	$(PASS)
	@$(ECHO)
else
	$(error "Not implemented for host!")	
endif

.PHONY: debug
debug: ##@live Debug the program.
debug: build
ifeq ($(PLATFORM),host)
  ifndef GDB_EXISTS
	$(error "Please install 'gdb' debugger!")
  endif
	@gdb			$(BIN_DIR)$(TARGET_DIR)$(EXEC).elf
else
	$(error "Not implemented for target!")
endif

################################################################################
#	 _____      _   _                               _           
#	|  __ \    | | | |                             | |          
#	| |__) |_ _| |_| |_ ___ _ __ _ __    _ __ _   _| | ___  ___ 
#	|  ___/ _` | __| __/ _ \ '__| '_ \  | '__| | | | |/ _ \/ __|
#	| |  | (_| | |_| ||  __/ |  | | | | | |  | |_| | |  __/\__ \
#	|_|   \__,_|\__|\__\___|_|  |_| |_| |_|   \__,_|_|\___||___/
#
#

#...............		Target/Host Patterns		...........................#

# # List of C objects
# ifneq ($(C_SRCs),)
#   OBJECTS += $(addprefix $(OBJ_DIR)$(TARGET_DIR),$(notdir $(C_SRCs:.c=.o)))
#   vpath %.c $(sort $(dir $(C_SRCs)))
# endif
# # List of assembly objects
# ifneq ($(ASM_SRCs),)
#   OBJECTS += $(addprefix $(OBJ_DIR)$(TARGET_DIR),$(notdir $(ASM_SRCs:.s=.o)))
#   vpath %.s $(sort $(dir $(ASM_SRCs)))
# endif

# Build elf program
$(BIN_DIR)$(TARGET_DIR)$(EXEC).elf: $(OBJECTS)
	$(BUILDING)
	@$(ECHO_N)		"$@\t"
	@$(MKDIR_P)		$(dir $@)
	@$(CC)			$^ $(LDFLAGS) -o $@
	$(PASS)

# Create hex program
$(BIN_DIR)$(TARGET_DIR)%.hex: $(BIN_DIR)$(TARGET_DIR)%.elf
	$(BUILDING)
	@$(ECHO_N)		"$@\t"
	@$(MKDIR_P)		$(dir $@)
	@$(HEX)			$< $@
	$(PASS)

# Create bin program
$(BIN_DIR)$(TARGET_DIR)%.bin: $(BIN_DIR)$(TARGET_DIR)%.elf
	$(BUILDING)
	@$(ECHO_N)		"$@\t"
	@$(MKDIR_P)		$(dir $@)
	@$(BIN)			$< $@
	$(PASS)

# Create object from C++ source code
$(OBJ_DIR)$(TARGET_DIR)%.o: %.cpp $(OBJ_DIR)$(TARGET_DIR)%.d $(AUX)
	$(COMPILING)
	@$(ECHO_N)		"$<\t"
	@$(MKDIR_P)		$(dir $@)
	@$(CXX)			$< -c $(CXXFLAGS) $(CPPFLAGS) -Wa,-a,-ad,-alms=$(dir $(OBJ_DIR)$(TARGET_DIR)$<)$(notdir $(<:.cpp=.lst)) -o $@
	@$(MV_F)		$(OBJ_DIR)$(TARGET_DIR)$*.Td $(OBJ_DIR)$(TARGET_DIR)$*.d && touch $@
	$(PASS)

# Create object from C source code
$(OBJ_DIR)$(TARGET_DIR)%.o: %.c $(OBJ_DIR)$(TARGET_DIR)%.d $(AUX)
	$(COMPILING)
	@$(ECHO_N)		"$<\t"
	@$(MKDIR_P)		$(dir $@)
	@$(CC)			$< -c $(CFLAGS) $(CPPFLAGS) -Wa,-a,-ad,-alms=$(dir $(OBJ_DIR)$(TARGET_DIR)$<)$(notdir $(<:.c=.lst)) -o $@
	@$(MV_F)		$(OBJ_DIR)$(TARGET_DIR)$*.Td $(OBJ_DIR)$(TARGET_DIR)$*.d && touch $@
	$(PASS)

# Create object from Assembly source code
$(OBJ_DIR)$(TARGET_DIR)%.o: %.s $(OBJ_DIR)$(TARGET_DIR)%.d $(AUX)
	$(COMPILING)
	@$(ECHO_N)		"$<\t"
	@$(MKDIR_P)		$(dir $@)
	@$(AS)			$< -c $(ASFLAGS) $(CPPFLAGS) -o $@
	@$(MV_F)		$(OBJ_DIR)$(TARGET_DIR)$*.Td $(OBJ_DIR)$(TARGET_DIR)$*.d && touch $@
	$(PASS)

# Manage auto-depedencies
.PRECIOUS: $(OBJ_DIR)$(TARGET_DIR)%.d
$(OBJ_DIR)$(TARGET_DIR)%.d: ;
	

#...............		Test Patterns		...................................#

# # List of C++ objects
# ifneq ($(TEST_CXX_SRCs),)
#   TEST_OBJECTS += \
#   		$(addprefix $(OBJ_DIR)$(TESTS_DIR),$(notdir $(TEST_CXX_SRCs:.cpp=.o)))
#   vpath %.cpp $(sort $(dir $(TEST_CXX_SRCs)))
# endif

# # List of C objects
# ifneq ($(TEST_C_SRCs),)
#   TEST_OBJECTS += \
#   		$(addprefix $(OBJ_DIR)$(TESTS_DIR),$(notdir $(TEST_C_SRCs:.c=.o)))
#   vpath %.c $(sort $(dir $(TEST_C_SRCs)))
# endif

# Build test program
$(BIN_DIR)$(TESTS_DIR)$(TESTS_EXEC): $(TEST_OBJECTS)
	$(BUILDING)
	@$(ECHO_N)		"$<\t"
	@$(MKDIR_P)		$(dir $@)
	@$(CXX.host)	$^ $(TEST_LDFLAGS) -o $@
	$(PASS)
	@$(ECHO)
	@$(SZ.host)		$@

# Create object from C++ source code
$(OBJ_DIR)$(TESTS_DIR)%.o: %.cpp
	$(COMPILING)
	@$(ECHO_N)		"$<\t"
	@$(MKDIR_P)		$(dir $@)
	@$(CXX.host)	$< -c $(TEST_CPPFLAGS) $(TEST_CXXFLAGS) -Wa,-a,-ad,-alms=$(OBJ_DIR)$(TESTS_DIR)$(notdir $(<:.cpp=.lst)) -o $@
	$(PASS)

# Create object from C source code
$(OBJ_DIR)$(TESTS_DIR)%.o: %.c
	$(COMPILING)
	@$(ECHO_N)		"$<\t"
	@$(MKDIR_P)		$(dir $@)
	@$(CXX.host)	$< -c $(TEST_CPPFLAGS) $(TEST_CFLAGS) -Wa,-a,-ad,-alms=$(OBJ_DIR)$(TESTS_DIR)$(notdir $(<:.c=.lst)) -o $@
	$(PASS)

################################################################################
# Tests

.PHONY: config
config:
	@$(ECHO)		"PLATFORM:     $(PLATFORM)\n"
	@$(ECHO)		"BUILD_MODE:   $(BUILD_MODE)\n"
	@$(ECHO)		"TARGET_DIR:   $(TARGET_DIR)\n"
	@$(ECHO)		"CFLAGS:       $(CFLAGS)\n"
	@$(ECHO)		"CXXFLAGS:     $(CXXFLAGS)\n"
	@$(ECHO)		"CPPFLAGS:     $(CPPFLAGS)\n"
	@$(ECHO)		"LDFLAGS:      $(LDFLAGS)\n"
	@$(ECHO)		"ASFLAGS:      $(ASFLAGS)\n"
	@$(ECHO)		"CXX_SRCs:     $(CXX_SRCs)\n"
	@$(ECHO)		"AS_SRCs:      $(AS_SRCs)\n"
	@$(ECHO)		"C_SRCs:       $(C_SRCs)\n"
	@$(ECHO)		"CXX_SRCs:     $(CXX_SRCs)\n"
	@$(ECHO)		"INCLUDES:     $(INCLUDES)\n"
	@$(ECHO)		"OBJECTS:      $(OBJECTS)\n"
	@$(ECHO)		"TEST_OBJECTS: $(TEST_OBJECTS)\n"
	@$(ECHO)		"TEST:         $(wildcard $(patsubst %,$(OBJ_DIR)$(TARGET_DIR)%.d,$(basename $(C_SRCs))))\n"

################################################################################
# WARNING!!! This must be at the end for auto-dependency to work

-include $(wildcard $(patsubst %,$(OBJ_DIR)%.d,$(basename $(CΧΧ_SRCs))))
-include $(wildcard $(patsubst %,$(OBJ_DIR)%.d,$(basename $(C_SRCs))))
-include $(wildcard $(patsubst %,$(OBJ_DIR)%.d,$(basename $(AS_SRCs))))