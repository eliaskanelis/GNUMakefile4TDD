################################################################################
#    Toolchain
#

AS  = $(CCACHE) gcc -x assembler-with-cpp
CC  = $(CCACHE) gcc
CXX = $(CCACHE) g++
LD  = gcc
SZ  = size
OC  = objcopy
NM  = nm

################################################################################
#    Rules
#

.PHONY: run
run: $(BIN_OUTDIR)$(PROJ_NAME).elf
	@./$< || true;
