#..............................................................................#

EXEC =			TDD_Project

#..............................................................................#
#	Documentation

PROJECT_NAME =		First embedded TDD project

PROJECT_BRIEF =		This is a clean 'hello world' and 'blink' C project for \
			Test driven development in embedded systems

#..............................................................................#
#	TTD

CPPUTEST_DIR =		${HOME}/opt/cpputest/

#..............................................................................#
#	CPU

TARGET_NAME =		stm32f072rb
TARGET_TC_PREFIX =	arm-none-eabi-
TARGET_TC_PATH =	${HOME}/opt/gcc-arm-none-eabi-7-2018-q2-update/bin/

CPU =			cortex-m0
TARGET_LDSCRIPT =	port/stm32f072rb/STM32F072RBTx_FLASH.ld

#..............................................................................#
#	STM32 CMSIS drivers

USER_TARGET_CPPFLAGS =\
			-DSTM32F072xB

USER_TARGET_INCLUDES =\
			-Ithirdparty/CMSIS/Device/ST/STM32F0xx/Include/\
			-Ithirdparty/CMSIS/Include/

#..............................................................................#
#	Actual Makefile
include common.mk
