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

AUX += port/$(PORT_NAME)/sys/STM32F072RBTx_FLASH.ld

LDFLAGS  += -Tport/$(PORT_NAME)/sys/STM32F072RBTx_FLASH.ld

#.................................................
#    C standard library

LDFLAGS  += -lc
LDFLAGS  += -lm

#.................................................
#    ARCH

CPPFLAGS += -mcpu=cortex-m0 \
            -mthumb
# LDFLAGS += -mcpu=cortex-m0 \
#            -mthumb

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

################################################################################
#    Thirdparty
#

#.................................................
#    CMSIS

CPPFLAGS+=-DSTM32F072xB
CPPFLAGS+=-Ithirdparty/CMSIS/Device/ST/STM32F0xx/Include/ \
          -Ithirdparty/CMSIS/Include/

# TODO: Fix the following warning
# error: "__CORTEX_SC" is not defined, evaluates to 0 [-Werror=undef]
CPPFLAGS += -D__CORTEX_SC=0

################################################################################
#    Functions
#

# Function to run the program
override define runApp
  uart -d "/dev/ttyACM0" -s "115200"
endef

# Function to calculate the size of the elf
override define sizeElf
  @./scripts/get_fw_size "$(1)" 0x20000 0x4000 > "$(2)"
endef


################################################################################
#    Toolchain
#

.PHONY: remoteDebug
remoteDebug:
	@JLinkGDBServer -select USB -device STM32F072RB -endian little -if SWD -speed 4000 -noir -noLocalhostOnly

.PHONY: flash
flash: $(BIN_OUTDIR)flash.jlink
	@JLinkExe -CommanderScript $<

.PHONY: $(BIN_OUTDIR)flash.jlink
$(BIN_OUTDIR)flash.jlink:  $(BIN_OUTDIR)$(DEFAULT_APP_NAME).bin
	@$(ECHO) "si 1" > $@
	@$(ECHO) "device STM32F072RB" >> $@
	@$(ECHO) "speed 4000" >> $@
	@$(ECHO) "erase" >> $@
	@$(ECHO) "loadbin $<, 0x00" >> $@
	@$(ECHO) "r" >> $@
	@$(ECHO) "g" >> $@
	@$(ECHO) "exit" >> $@
