# Updating SDMapper to Nextor 3.0

This guide describes the process of updating the **SDMapper** interface firmware/driver to **Nextor 3.0**, while also allowing you to maintain compatibility of the SD card with Nextor 2 (dual-boot).

---

## ⚠️ Important Warnings Before Starting

1. **Secondary Device:** You must use **another storage device** (such as a floppy disk drive, Carnivore2, IDE, Pico, PicoVerse, etc.) to boot the MSX and run the update program (`SDMUPD`).
2. **Backup or Test Card:** Make a **full backup** of your current SD card or use a **"disposable"** card for testing until you are sure that both the new SDMapper driver and the new Nextor 3 kernel are stable for your daily use.

---

## 1. Updating the SDMapper Firmware

1. Copy the updater program (`SDMUPD.COM`) and the new ROM file (containing the Nextor 3.0 kernel + SDMapper driver) to your secondary storage device. The files are available on the [**Releases**](https://github.com/polileco/SDMapperV1-Nextor-driver/releases) page.
2. Insert the SDMapper and the secondary device into the MSX and turn on the computer.
   > *Tip:* If the MSX tries to boot from the SDMapper before the secondary device, hold down the **Q/W/E/R** keys for slots 1(-0) to 1-3, **A/S/D/F** for slots 2(-0) to 2-3 or **Z/X/C/V** for slots 3(-0) to 3-3 respectively (depending on your current setup - see the [Nextor 2 User Manual](https://github.com/Konamiman/Nextor/blob/v2.1.4/docs/Nextor%202.1%20User%20Manual.md#29-boot-key)) right after the MSX logo appears during boot **or** leave the SDMapper without an SD card during boot.
3. At the MSX-DOS prompt of the secondary device, navigate to the folder containing the files and run the updater:
   ```text
   SDMUPD <rom_filename.rom>
   ```
   *(Wait for the flash writing process to complete and don't turn off the MSX).*
4. Once the process is complete, restart the MSX. The boot screen should now display **Nextor 3.0** and the new SDMapper driver version.

---

## 2. Preparing the SD Card (and keeping Dual-Boot with Nextor 2)

Now you need to prepare the SD card with the Nextor 3.0 system files and utilities. If you use this same card on other interfaces that still run Nextor 2, you can set up a **dual-boot** scheme:

1. Download the package with the new Nextor 3.0 programs and utilities (section *Tools disk image and ZIP file for Nextor 3.0*):
   * 🔗 [Nextor Releases on GitHub](https://github.com/Konamiman/Nextor/releases#release-tools-disk-image-and-zip-for-Nextor-3.0)
2. Extract the `.zip` file on your computer.
3. On the SD card, create a **new folder** (for example, `NEXTOR3` or `UTILS3`) and copy the contents of the `TOOLS` folder from the downloaded package into it. This prevents overwriting the old Nextor 2 commands. You can _merge/overwrite_ the files from the `HELP` folder, if present, into the **root** of the SD card.
4. Copy the `NEXTOR.SYS` and `COMMAND3.COM` files to the **root** of the SD card.
   * **Dual-Boot Note:** The Nextor 3 kernel looks for `NEXTOR3.SYS` first before loading `NEXTOR.SYS`. Therefore, if you want to keep the original `NEXTOR.SYS` (version 2) working on other cartridges, **rename the new file to `NEXTOR3.SYS`** before copying it to the root of the card.
   * *(Optional)* Nextor 3 now uses the `AUTOEXEC.BTM` file for automatic system startup (leaving `AUTOEXEC.BAT` free for Nextor 2 / MSX-DOS). You can create a dedicated one for the new version or copy `AUTOEXEC.BAT` to `AUTOEXEC.BTM`
   ```text
   A:\>COPY AUTOEXEC.BAT AUTOEXEC.BTM
   ```

---

## 3. Finishing Up

Insert the SD card into the SDMapper and restart the MSX. The system should load `NEXTOR3.SYS` and `COMMAND3.COM` automatically.

> **Note:** It is recommended to read the official Nextor 3.0 documentation ([What's New](https://github.com/Konamiman/Nextor/blob/master/docs/Nextor_3.0_Whats_New.md), [Getting Started Guide](https://github.com/Konamiman/Nextor/blob/master/docs/Nextor_3.0_Getting_Started_Guide.md) and [User Manual](https://github.com/Konamiman/Nextor/blob/master/docs/Nextor_3.0_User_Manual.md)) in Konamiman's repository, as there are new commands, changes in partition management, and important new features in the system.

