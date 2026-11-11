# FBLabs SDMapper V1 driver for Nextor 3

Nextor 3 driver for the FBLabs SDMapper V1 (SD/SDHC cartridge interface with mapper and
MegaRAM for MSX computers). It produces a Nextor ROM image that combines a Nextor kernel
(v3.0 or newer) base file with this driver.

The driver is a migration of the Nextor 2 driver of the SDMapper
(https://github.com/fbelavenuto/msxsdmapper) following the *Nextor 3.0 Driver Migration
Guide*: the hardware access code is the original one, wrapped by the Nextor 3 query
based interface.

## A how-to guide to update the cartridge

- [Portuguese (PT-BR)](HOWTO_PT-BR.md)
- [English](HOWTO_EN.md)

## Repository contents

| File             | Purpose                                                                  |
|------------------|--------------------------------------------------------------------------|
| `driver.asm`     | The driver.                                                              |
| `Makefile`       | Build rules; see below.                                                  |
| `external/Nextor`| Git submodule pointing at the Nextor repo (only the `sdk/` directory is checked out). |

## Building

Requirements:

- [Nestor80](https://github.com/Konamiman/Nestor80) (`N80`) in `PATH` (or set the `N80` make variable).
- `mknexrom` in `PATH` (or set `MKNEXROM`). Its source is in the Nextor repository, under `buildtools/sources/mknexrom.c`.
- A POSIX `make`.
- A Nextor 3 kernel base file and the Nextor SDK (`make setup` initializes the `external/Nextor` submodule).

```
git clone https://github.com/<owner>/<this-repo>.git
cd <this-repo>
make setup
NEXTOR_BASE=/path/to/Nextor-3.0.0.base.dat make
```

The ROM is generated in `bin/`. The ASCII16 mapper is used, so no bank switching routine
(`mknexrom /m:`) is needed. Without `make`, the build is just two commands:

```
N80 driver.asm tmp/ --no-string-escapes --build-type abs --output-file-extension bin \
    --include-directory external/Nextor/sdk
mknexrom /path/to/Nextor-<ver>.base.dat Nextor-<ver>.SDMapper.ROM /d:tmp/driver.bin
```

| Variable     | Purpose                                                    | Default                 |
|--------------|------------------------------------------------------------|-------------------------|
| `NEXTOR_BASE`| Path to the Nextor kernel base `.dat` file (mandatory).    | *(unset; error)*        |
| `NEXTOR_SDK` | Path to the Nextor SDK directory (the one containing `asm/`). | `external/Nextor/sdk` |
| `NO_UNDOC_CPU_INSTRUCTIONS` | If non-empty, assemble without undocumented Z80 opcodes (Z180 machines). | inferred: `1` if the `NEXTOR_BASE` file name has a `NO_UNDOC` suffix |
| `N80`        | Path to the Nestor80 assembler.                            | `N80` (from `PATH`)     |
| `MKNEXROM`   | Path to the `mknexrom` tool.                               | `mknexrom` (from `PATH`)|

The driver uses the SDK's `undoc.inc` macros instead of the undocumented Z80 instructions
(`ixh`/`ixl`). With a `NO_UNDOC` kernel base file the Makefile assembles the driver with
`--define-symbols NO_UNDOC_CPU_INSTRUCTIONS` to match; when assembling by hand, add that
option to the `N80` call and use a `.NO_UNDOC` kernel base.

## Testing

Run `DRVTEST.COM` (driver queries, and device queries with `-d <device>`), `DRIVERS.COM` and
`DEVINFO.COM` from the Nextor 3 distribution. See the Nextor 3.0 Driver Development Guide,
section 5.

## Credits

Fabio Belavenuto and FRS for original SDMapper driver and Leandro Polimeno; hardware by Luciano Sturaro.
See the notices at the top of `driver.asm` for the license terms.
