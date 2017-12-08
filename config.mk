#-------------------------------------------------------------------------------
#	  _____             __ _                       _   _                 
#	 / ____|           / _(_)                     | | (_)                
#	| |     ___  _ __ | |_ _  __ _ _   _ _ __ __ _| |_ _  ___  _ __  ___ 
#	| |    / _ \| '_ \|  _| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \/ __|
#	| |___| (_) | | | | | | | (_| | |_| | | | (_| | |_| | (_) | | | \__ \
#	 \_____\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|___/
#	                          __/ |                                      
#	                         |___/                                       
#
#-------------------------------------------------------------------------------
#
#	Custom project Makefile configurations.
#
#-------------------------------------------------------------------------------

EXEC =				TDD_Project

PLATFORM =			target

CPPUTEST_DIR =		~/opt/cpputest/

PROJECT_NAME =		First embedded TDD project

PROJECT_BRIEF =		This is a clean 'hello world' C project for \
					Test driven development in embedded systems


TARGET_CPU =		cortex-m0
TARGET_TC_PATH =	~/opt/gcc-arm-none-eabi-6-2017-q2-update/bin/

TARGET_LDSCRIPT =	port/cortex-m0/STM32F072RBTx_FLASH.ld

#...............................................#
#						STM32 CMSIS drivers
ifeq ($(PLATFORM),target)
  USER_CPPFLAGS =	-DSTM32F072xB

  USER_INCLUDES =	-Ithirdparty/CMSIS/Device/ST/STM32F0xx/Include/\
					-Ithirdparty/CMSIS/Include/
endif