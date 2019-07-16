## OC-PNLF 注入方法

1. 亮度(PNLF)控制部分的组成——亮度驱动和亮度补丁

   - 亮度驱动：

     - WhateverGreen.kext内置亮度驱动

       使用内置驱动需设置引导参数applbkl=1（默认）。如果使用其他亮度驱动应当设置 applbkl=0 禁止其内置驱动。

     - AppleBacklightFixup.kext

     - IntelBacklight.kext

     - ACPIBacklight.kext

       亮度驱动下载地址：

     - WhateverGreen.kext(需Lilu.kext)
    https://github.com/acidanthera/WhateverGreen/releases
   
     - AppleBacklightFixup.kext
    https://bitbucket.org/RehabMan/applebacklightfixup/downloads/
   
     - IntelBacklight.kext
    https://bitbucket.org/RehabMan/os-x-acpi-backlight/downloads/
   
     - ACPIBacklight.kext
    https://bitbucket.org/RehabMan/os-x-intel-backlight/downloads/
   
   - 亮度补丁

     - 定制亮度补丁

       - SSDT-PNLF-SNB_IVY——2、3 代 CPU 亮度补丁。

       - SSDT-PNLF-Haswell_Broadwell——4、5 代 CPU 亮度补丁。

       -  SSDT-PNLF-SKL_KBL——6、7 代 CPU 亮度补丁。

       - SSDT-PNLF-CFL——8 代+CPU 亮度补丁。

         以上补丁插入于_SB。

     - RehabMan 亮度补丁

       - https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-PNLF.dsl

       - https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-PNLFCFL.dsl

       - https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/hotpatch/SSDT-RMCF.dsl

         RehabMan 亮度补丁插入于 _SB.PCI0.IGPU。要求显卡名称是 IGPU。

2. 常用的几种注入方法

   - 使用定制亮度补丁
     - 驱动: 无(applbkl =0)
     - 补丁: 定制亮度补丁
   - WhateverGreen +定制亮度补丁
     - 驱动: WhateverGreen (applbkl =1)
     - 补丁: 定制亮度补丁
   - AppleBacklightFixup.kext+定制亮度补丁
     - 驱动: AppleBacklightFixup.kext ( applbkl =0)
     - 补丁: 定制亮度补丁

3. 注入方法选用原则

   - 当注入的显卡AAPL,ig-platform-id 和 CPU 的 ID 匹配时，推荐使用方法 1 或者方法 2。
   - 当注入的显卡AAPL,ig-platform-id 仿冒某一 CPU 的 ID 时，推荐使用方法 3。

4. 注意事项

   选用某一注入方法时，应清除其他方法有关的驱动、补丁、设置等。