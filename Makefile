# Makefile for the FBLabs SD Mapper v1 driver for Nextor 3.
#
# Builds one ROM (the Nextor kernel base file pointed at by NEXTOR_BASE combined with this
# driver), placed in `bin/`:
#
#   bin/Nextor-<ver>.SDMapper.ROM
#
# <ver> is read from the SDK's nextor-kernel-version.txt. Any variant suffix of the kernel
# base file (e.g. ".NO_UNDOC") is taken from the NEXTOR_BASE filename, which is expected to
# follow either the repository convention Nextor-<ver>.base[<suffix>].dat or the Docker image
# convention kernel_base[<suffix>].dat. When the suffix contains NO_UNDOC (kernel without
# undocumented Z80 opcodes, for Z180-based machines), the driver is assembled the same way
# (NO_UNDOC_CPU_INSTRUCTIONS) so that it always matches the kernel it is combined with.
#
# The ASCII16 mapper is used, so the bank switching routine (mknexrom /m:) is not needed.
#
# Intermediate files go to `tmp/` (removed by `make clean`); the ROMs in `bin/` survive
# `make clean` and are removed by `make clean-bin` (or `make distclean` for both).

### Configurable variables ###################################################

# NEXTOR_BASE: path to the Nextor kernel base .dat file (mandatory except for `setup` and
# the clean targets).
ifeq ($(strip $(NEXTOR_BASE)),)
ifeq ($(filter setup clean clean-bin distclean,$(MAKECMDGOALS)),)
$(error NEXTOR_BASE is not set. Point it at a Nextor kernel base .dat file)
endif
else
ifeq ($(wildcard $(NEXTOR_BASE)),)
$(error NEXTOR_BASE points at '$(NEXTOR_BASE)' which does not exist)
endif
endif

# NEXTOR_SDK: path to the Nextor SDK directory (the one containing 'asm/').
# Defaults to the bundled git submodule (see `make setup`).
NEXTOR_SDK ?= external/Nextor/sdk

# Tool overrides. Default to the executables found in PATH.
N80      ?= N80
MKNEXROM ?= mknexrom

### Output directories #######################################################

BIN := bin
TMP := tmp

### Filename derivation ######################################################

_VERSION_FILE := $(NEXTOR_SDK)/nextor-kernel-version.txt
NEXTOR_KERNEL_VERSION := $(strip $(shell cat $(_VERSION_FILE) 2>/dev/null))
ifeq ($(NEXTOR_KERNEL_VERSION),)
ifeq ($(filter setup clean clean-bin distclean,$(MAKECMDGOALS)),)
$(error Could not read $(_VERSION_FILE). Is the Nextor SDK submodule initialized? Run 'make setup')
endif
endif

# A variant suffix is present only when 'base' is followed by a '.' in the base file name.
_BASE_NAME := $(notdir $(NEXTOR_BASE))
_BASE_STEM := $(_BASE_NAME:.dat=)
ifeq ($(findstring base.,$(_BASE_STEM)),base.)
_VARIANT := .$(lastword $(subst base., ,$(_BASE_STEM)))
else
_VARIANT :=
endif

ROM := $(BIN)/Nextor-$(NEXTOR_KERNEL_VERSION).SDMapper.V1$(_VARIANT).ROM

### Build flag inference #####################################################

# NO_UNDOC_CPU_INSTRUCTIONS: when non-empty (e.g. =1) the driver is assembled with the
# undocumented Z80 opcodes (the ones operating on ixh/ixl) replaced by documented
# equivalents, via the macros in the SDK's undoc.inc. Unless given explicitly (environment
# or command line, even an empty value), it is inferred from the NEXTOR_BASE file name.
ifeq ($(origin NO_UNDOC_CPU_INSTRUCTIONS),undefined)
NO_UNDOC_CPU_INSTRUCTIONS := $(if $(findstring NO_UNDOC,$(_VARIANT)),1,)
endif

### Assembly flags ###########################################################

N80_FLAGS := --no-string-escapes --no-show-banner --verbosity 0 \
             --build-type abs --output-file-extension bin \
             --output-file-case lower \
             --include-directory $(NEXTOR_SDK)

_DEFINES_NO_UNDOC := $(if $(NO_UNDOC_CPU_INSTRUCTIONS),--define-symbols NO_UNDOC_CPU_INSTRUCTIONS)

# The NO_UNDOC setting changes how the driver is assembled but appears in no source file,
# so make can't see it change between runs. It is recorded in a stamp file that the driver
# binary depends on: switching it forces a reassembly instead of silently combining a
# mismatched driver with the kernel base.
_BUILD_ID := undoc=$(if $(NO_UNDOC_CPU_INSTRUCTIONS),1,0)
_BUILD_STAMP := $(TMP)/.build-id

$(_BUILD_STAMP): FORCE | $(TMP)
	@printf '%s\n' '$(_BUILD_ID)' | cmp -s - $@ || printf '%s\n' '$(_BUILD_ID)' > $@

### Targets ##################################################################

.DEFAULT_GOAL := all
.PHONY: all clean clean-bin distclean setup FORCE

FORCE:

all: $(ROM)

$(BIN) $(TMP):
	@mkdir -p $@

# N80 writes tmp/driver.bin: when the output path is a directory, it uses the default
# base name (driver) with the extension given by --output-file-extension.
$(TMP)/driver.bin: driver.asm $(_BUILD_STAMP) | $(TMP)
	$(N80) driver.asm $(TMP)/ $(N80_FLAGS) $(_DEFINES_NO_UNDOC)

$(ROM): $(TMP)/driver.bin | $(BIN)
	$(MKNEXROM) $(NEXTOR_BASE) $@ /d:$(TMP)/driver.bin

clean:
	rm -rf $(TMP)

clean-bin:
	rm -rf $(BIN)

distclean: clean clean-bin

### One-time setup ###########################################################

# Initializes the Nextor SDK submodule as a blobless partial clone with sparse-checkout
# for the `sdk/` directory only, so the full Nextor repository is never fetched.
setup:
	@echo "Setting up the Nextor SDK submodule (blobless + sparse-checkout for sdk/ only)..."
	git submodule init external/Nextor
	git submodule update --init --filter=blob:none external/Nextor
	git -C external/Nextor sparse-checkout init --cone
	git -C external/Nextor sparse-checkout set sdk
	git -C external/Nextor checkout
	@echo "Done. Set NEXTOR_BASE and run 'make' to build."
