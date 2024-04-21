################################################################################
#    Toolchain
#

AS  = $(CCACHE) arm-none-eabi-gcc -x assembler-with-cpp
CC  = $(CCACHE) arm-none-eabi-gcc
CXX = $(CCACHE) arm-none-eabi-g++
LD  = arm-none-eabi-gcc
AR  = arm-none-eabi-ar
SZ  = arm-none-eabi-size
OC  = arm-none-eabi-objcopy
NM  = arm-none-eabi-nm

################################################################################
#    Flags
#

#.................................................
#    Linker script

AUX += port/$(PORT_NAME)/sys/TM4C123GH6PM.ld

LDFLAGS  += -Tport/$(PORT_NAME)/sys/TM4C123GH6PM.ld

#.................................................
#    C standard library

LDFLAGS  += -lc
LDFLAGS  += -lm

#.................................................
#    ARCH

CPPFLAGS += -mcpu=cortex-m4 \
            -mthumb
# LDFLAGS += -mcpu=cortex-m4 \
#            -mthumb

# FPU
CPPFLAGS += -mfpu=fpv4-sp-d16
CPPFLAGS += -mfloat-abi=hard
#CPPFLAGS += -mfloat-abi=softfp


#.................................................
#    TODO

#LDFLAGS += -Wl,-u
#LDFLAGS += -Wl,_printf_float
LDFLAGS  += -u _printf_float
LDFLAGS  += -u _scanf_float

#LDFLAGS += -ffreestanding
#LDFLAGS +=-nostdlib

#LDFLAGS +=-specs=nosys.specs
#LDFLAGS +=-specs=nano.specs
#LDFLAGS +=-lnosys
#LDFLAGS +=-lrdimon

# TODO: This reduces code quality. Need to refactor code and solve warnings.
# Ignores all warnings
CPPFLAGS += -w

################################################################################
#    Thirdparty
#

#.................................................
#    CMSIS

CPPFLAGS  += -DTM4C123GH6PM
CPPFLAGS  += -Ithirdparty/CMSIS/Device/TI/TM4C/Include/ \
             -Ithirdparty/CMSIS/Include/

#.................................................
#    Tiva Libraries

#CPPFLAGS  += -Ithirdparty/Tiva/driverlib \
#             -Ithirdparty/Tiva/driverlib/gcc

#LDFLAGS   += -L thirdparty/Tiva/driverlib/gcc \
#             -ldriver


################################################################################
#    Functions
#

# Function to run the program
override define runApp
  uart -d "/dev/ttyACM0" -s "115200"
endef

# Function to calculate the size of the elf
override define sizeElf
  @./scripts/get_fw_size "$(1)" 0x40000 0x8000 > "$(2)"
endef


################################################################################
#    Toolchain
#

.PHONY: flash
flash: $(BIN_OUTDIR)$(DEFAULT_APP_NAME).bin
	@lm4flash -v -E $<
