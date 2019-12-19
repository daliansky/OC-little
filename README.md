# OpenCore 0.5+ 部件补丁

## 说明

依据 OpenCore 0.5+ 的要求和建议，制作本部件补丁。

## 主要内容

- **总述** 

- ACPI 二进制更名

- 预置变量法

- 仿冒设备

- `SSDT`补丁加载顺序

- 操作系统补丁

- 注入 X86

- 仿冒 `EC` 

- OC-`PNLF` 注入方法

- `SBUS(SMBU)` 补丁

- PS2 键盘映射 @OC-xlivans

- 键盘无法输入的应急解决方案 `PS2N`

- 添加丢失的部件 

- OC `I2C-TPXX` 补丁方法

- OC `GPIO` 补丁

- OC Thinkpad 电池补丁

- OC 其他电池补丁 

- 禁用 `EHCx`

- `PTSWAK` 综合补丁和扩展补丁 

- `PNP0C0E` 睡眠修正方法 

- `0D6D` 补丁

- 仿冒以太网和重置以太网 `BSD Name`

- 亮度快捷键补丁

- `CMOS` 重置补丁

- Dell 机器补丁列表

- ACPIDebug

- ACPI 定制 USB 端口

- 禁止 PCI 设备

- `HPET_RTC_TIMR` 三合一补丁

- `CMOS` 内存和 `RTCMemoryFixup`

- 禁止`S3`睡眠

- 为了方便使用，整理了部分驱动列表，仅供参考：

  - config-Lilu-SMC-WEG-ALC 驱动列表
  - config-PS2 键盘驱动列表
  - config-I2C 驱动列表
  - config-BCM 无线和蓝牙驱动列表
  - ~~config-I2C 禁止冲突原生驱动列表~~
    
    > VoodooI2C 2.3 及以后不再需要屏蔽 `AppleIntelLpssI2C`

### Credits

- 特别感谢：
  - @宪武 制作的适用于 **[OpenCore](https://github.com/acidanthera/OpenCorePkg)** 的 ACPI 部件补丁
  - [@Bat.bat](https://github.com/williambj1), [@黑果小兵](https://github.com/daliansky), [@套路](https://github.com/athlonreg) 审核更新完善
- 感谢：@冬瓜-X1C5th, @OC-xlivans, @Air 13 IWL-GZ-Big Orange (OC perfect), @子骏oc IWL, @大勇-小新air13-OC-划水小白@Canvas  等等
- [Acidanthera](https://github.com/acidanthera) 
  - [AppleSupportPkg](https://github.com/acidanthera/AppleSupportPkg)
  - ~~[AptioFixPkg](https://github.com/acidanthera/AptioFixPkg)~~(Achieved)
  - [MacInfoPkg](https://github.com/acidanthera/MacInfoPkg)
  - [OCSupportPkg](https://github.com/acidanthera/OCSupportPkg)
  - [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg)
  - [RTCMemoryFixup](https://github.com/acidanthera/RTCMemoryFixup)
