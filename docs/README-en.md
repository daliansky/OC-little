# OpenCore 0.5+ component patches

## Description
The series of patches are based on the requirements and suggestions of OpenCore 0.5+.


## The GitBook
This repository relies on GitBook and utilises Github Actions to build Page service and PDF manual.

- [https://ocbook.tlhub.cn](https://ocbook.tlhub.cn)
- [OpenCore component patches](https://cdn.jsdelivr.net/gh/daliansky/OC-little/docs/OpenCore部件库.pdf)

## Table of Contents

0. **Overview**

   1. Basic ACPI Source Language
   2. SSDT load sequence
   3. ACPI form
   4. ASL-AML comparison table

1. **About `AOAC`**

   1. Prevent `S3` sleep
   2. `AOAC` disable discrete graphics card
   3. Power management deep idle
   4. `AOAC` wake patch
   5. Auto power off bluetooth `WIFI` while sleep

2. **Preset Variable**

   1. OC `I2C-GPIO` patch
   2. Related patches

3. **Fake Devices**

   1. Fake `EC`
   2. RTC0
   3. Fake Ambient Light Sensor (ALS)

4. **OS Patch**

5. **Inject Devices**

   1. Inject X86
   2. `PNLF` inject method
   3. `SBUS(SMBU)` patch

6. **Add Missing Components**

7. **PS2 Keyboard Mapping & Brightness Function Key@OC-xlivans**

8. **Laptop Battery Driver**

9.  **Disable EHCx**

10. **`PTSWAK` extensional patch**

11. **`PNP0C0E` Sleep Adjust Method**

12. **`0D6D` Patch**

    1. General `060D` patch
    2. HP `060D` patch

13. **Fake Ethernet & Reset Ethernet `BSD Name`**

14. **About `CMOS`**

    1. `CMOS` memory & ***RTCMemoryFixup***

15. **`ACPI` Patch `USB` Ports**

16. **Disable `PCI` Devices and Set `ASPM` state**

    1. Disable `PCI` Devices
    2. Set `ASPM` state

17. **ACPIDebug**

18. **Patches for Specific Brands**

    1. `Dell` patches
    2. `XiaoXin PRO13` patches
    3. `ThinkPad` patches

19. **`I2C` Device**

20. **Disable Discrete Graphics Card Through `SSDT`**

21. **Audio card `IRQ` patch**

**Reserved Patches**

   1. Bettery Patch
      1. Thinkpad
      2. Other brands
      3. Battery status indicator patch
      4. Examples
   2. `CMOS` reset patch

**Common Drives Load Lists**

   1. config-1-Lilu-SMC-WEG-ALC load lists
   2. config-2-PS2 keyboard drives load lists
   3. config-3-BCM wireless and bluetooth drives load lists
   4. config-4-I2C+PS2 load lists
   5. config-5-PS2Smart keyboard drvices load lists
   6. config-6-Intel wireless and bluetooth drives load lists

### Credits

- Special credit to：
  - @XianWu write these ACPI componet patches that useable to **[OpenCore](https://github.com/acidanthera/OpenCorePkg)** 
  - @Bat.bat, @DalianSky, @athlonreg, @iStar丶Forever their proofreading and finalisation.

- Credit to：
  - @冬瓜-X1C5th
  - @OC-xlivans
  - @Air 13 IWL-GZ-Big Orange (OC perfect)
  - @子骏oc IWL
  - @大勇-小新air13-OC-划水小白
  - @xjn819
  - ......

- **Thanks for [Acidanthera](https://github.com/acidanthera) maintaining [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg)**
