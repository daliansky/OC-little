# OC-PNLF 注入方法

## 亮度 (`PNLF`) 控制部分的组成

- 驱动：

  - WhateverGreen.kext 内置亮度驱动(需 Lilu.kext)

    默认情况下，WhateverGreen.kext 会加载亮度驱动。如果使用其他亮度驱动应当禁用其内置的亮度驱动。

    - 禁用方法：

      - 添加引导参数 `applbkl=0`
      - 修改驱动的 `Info.plist\IOKitPersonalities\AppleIntelPanelA\IOProbeScore=5500`。

    - 下载地址：<https://github.com/acidanthera/WhateverGreen/releases>

  - IntelBacklight.kext
  
    - 下载地址：<https://bitbucket.org/RehabMan/os-x-intel-backlight/src/master/>
  
  - ACPIBacklight.kext
  
    - 下载地址：<https://bitbucket.org/RehabMan/os-x-acpi-backlight/src/master/>
  
- 补丁

  - 定制亮度补丁

    - ***SSDT-PNLF-SNB_IVY***：2, 3 代亮度补丁。
    - ***SSDT-PNLF-Haswell_Broadwell***： 4, 5 代亮度补丁。
    - ***SSDT-PNLF-SKL_KBL***：6, 7 代亮度补丁。
    - ***SSDT-PNLF-CFL***：8 代+ 亮度补丁。

      以上补丁插入于`_SB`。

  - RehabMan 亮度补丁
  
    - [https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-PNLF.dsl](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-PNLF.dsl)
  
    - [https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-PNLFCFL.dsl](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-PNLFCFL.dsl)
  
    - [https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-RMCF.dsl](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-RMCF.dsl)
  
      RehabMan 亮度补丁插入于 `_SB.PCI0.IGPU`，使用时将补丁文件的 `IGPU` 重命名为 ACPI 中的原始名称（如：`GFX0`）。

## 常用注入方法

- 驱动: WhateverGreen
- 补丁: 定制亮度补丁或 RehabMan 亮度补丁

## ACPI注入方法

- 驱动: ACPIBacklight.kext（需禁用 WhateverGreen.kext 内置亮度驱动，见上文的禁用方法）
- 补丁: 见《ACPI 亮度补丁》方法

## 其他注入方法

按照驱动 + 补丁的原则自行尝试。

## 注意事项

选用某一注入方法时，应清除其他方法有关的驱动、补丁、设置等。
