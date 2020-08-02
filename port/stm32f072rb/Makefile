################################################################################
#    Toolchain
#

AS  = $(CCACHE) arm-none-eabi-gcc -x assembler-with-cpp
CC  = $(CCACHE) arm-none-eabi-gcc
CXX = $(CCACHE) arm-none-eabi-g++
LD  = arm-none-eabi-gcc
SZ  = arm-none-eabi-size
OC  = arm-none-eabi-objcopy
NM  = arm-none-eabi-nm

################################################################################
#    Flags
#

#.................................................
#    Linker script

LDFLAGS  += -Tport/$(PORT_NAME)/STM32F072RBTx_FLASH.ld

#.................................................
#    C standard library

LDFLAGS  += -lc
LDFLAGS  += -lm

#.................................................
#    ARCH

CPPFLAGS+=-mcpu=cortex-m0\
          -mthumb

#.................................................
#    TODO

CPPFLAGS += -fdata-sections\
            -ffunction-sections

LDFLAGS  += -u --gc-sections
LDFLAGS  += -Wl,--gc-sections

#LDFLAGS += -Wl,-u
#LDFLAGS += -Wl,_printf_float
LDFLAGS  += -u _printf_float
LDFLAGS  += -u _scanf_float

#LDFLAGS += -ffreestanding
#LDFLAGS +=-nostdlib

LDFLAGS+=-specs=nosys.specs
#LDFLAGS+=-specs=nano.specs

#LDFLAGS+=-lnosys
#LDFLAGS+=-lrdimon

################################################################################
#    Thirdparty
#

#.................................................
#    CMSIS

CPPFLAGS+=-DSTM32F072xB
CPPFLAGS+=-Ithirdparty/CMSIS/Device/ST/STM32F0xx/Include/\
          -Ithirdparty/CMSIS/Include/

################################################################################
#    Toolchain
#

.PHONY: remoteDebug
remoteDebug:
	@JLinkGDBServer -select USB -device STM32F072RB -endian little -if SWD -speed 4000 -noir -noLocalhostOnly


.PHONY: run
run: flash
	@uart -d /dev/ttyACM0 -s 115200


.PHONY: flash
flash: $(BIN_OUTDIR)flash.jlink
	@JLinkExe -CommanderScript $<


.PHONY: $(BIN_OUTDIR)flash.jlink
$(BIN_OUTDIR)flash.jlink:  $(BIN_OUTDIR)$(PROJ_NAME).bin
	@$(ECHO) "si 1" > $@
	@$(ECHO) "device STM32F072RB" >> $@
	@$(ECHO) "speed 4000" >> $@
	@$(ECHO) "erase" >> $@
	@$(ECHO) "loadbin $<, 0x00" >> $@
	@$(ECHO) "r" >> $@
	@$(ECHO) "g" >> $@
	@$(ECHO) "exit" >> $@
