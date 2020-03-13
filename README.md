# OpenCore 0.5+ 部件补丁

## 说明

依据 OpenCore 0.5+ 的要求和建议，制作本部件补丁。

## 主要内容

- 总述

  1. `ASL`语法基础
  1. `SSDT` 补丁加载顺序

1. 关于`AOAC`

   1. 禁止`S3`睡眠
   1. `AOAC`禁用独显
   1. 电源空闲管理
   1. `AOAC`唤醒补丁

1. 仿冒设备

   1. 仿冒`EC`
   1. RTC0
   1. 键盘无法输入的应急解决方案 `PS2N`
   1. 仿冒环境光传感器
  
1. 二进制更名与预置变量

   1. OC `I2C-GPIO` 补丁
   1. ASL-AML 对照表

1. 操作系统补丁

1. 注入设备

   1. 注入 X86
   1. `PNLF` 注入方法
   1. `SBUS(SMBU)` 补丁

1. 添加缺失的部件

1. PS2 键盘映射 @OC-xlivans

1. 电池补丁

   1. Thinkpad
   1. 其它品牌

1. 禁用 EHCx

1. `PTSWAK` 综合扩展补丁

1. `PNP0C0E` 睡眠修正方法

1. `0D6D` 补丁

   1. 普通的 `060D` 补丁
   1. 惠普特殊的 `060D` 补丁

1. 仿冒以太网和重置以太网 `BSD Name`

1. 亮度快捷键

1. `CMOS` 相关

   1. `CMOS` 重置补丁
   1. `CMOS` 内存和 ***RTCMemoryFixup***

1. `ACPI` 定制 `USB` 端口

1. 禁止`PCI`设备

1. ACPIDebug

1. 品牌机器特殊补丁

   1. `Dell`机器特殊补丁
   1. 小新 PRO13 特殊补丁

1. `I2C` 专用部件

1. 声卡 `IRQ` 补丁

1. 常见驱动加载顺序：

   1. config-1-Lilu-SMC-WEG-ALC 驱动列表
   1. config-2-PS2 键盘驱动列表
   1. config-3-BCM 无线和蓝牙驱动列表
   1. config-4-I2C 驱动列表
   1. config-5-PS2Smart 键盘驱动列表

### Credits

- 特别感谢：
  - @宪武 制作的适用于 **[OpenCore](https://github.com/acidanthera/OpenCorePkg)** 的 ACPI 部件补丁
  - @Bat.bat, @黑果小兵, @套陆, @iStar丶Forever 审核完善

- 感谢：
  - @冬瓜-X1C5th
  - @OC-xlivans
  - @Air 13 IWL-GZ-Big Orange (OC perfect)
  - @子骏oc IWL
  - @大勇-小新air13-OC-划水小白
  - ......

- Thanks for:
  - [Acidanthera](https://github.com/acidanthera) Maintaining:
    - [AppleSupportPkg](https://github.com/acidanthera/AppleSupportPkg)
    - [MacInfoPkg](https://github.com/acidanthera/MacInfoPkg)
    - [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg)
