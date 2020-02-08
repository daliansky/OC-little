# OpenCore 0.5+ 部件补丁

## 说明

依据 OpenCore 0.5+ 的要求和建议，制作本部件补丁。

## 主要内容

- 总述 
    - `ACPI` 二进制更名
    - 预置变量法
    - 仿冒设备
    - `AOAC` 补丁方法
    - `SSDT` 补丁加载顺序
- 操作系统补丁
- 添加缺失的部件(非必要)
- 禁用`PCI`设备
- `SBUS(SMBU)` 补丁
- 仿冒 `EC`
- 注入`X86`变频
- `USB`相关补丁
    - `ACPI`定制`USB`端口
    - 禁用 `EHCx`
- 睡眠唤醒相关补丁
    - `PTSWAK` 综合补丁和扩展补丁
    - `PNP0C0E` 睡眠修正方法
    - `0D/6D` 补丁
    - 惠普特殊的`06/0D`补丁
- 核显屏幕亮度调节补丁
    - OC `PNLF` 注入方法
    - OC 亮度快捷键补丁
- OC 笔记本电池补丁
- `PS2`设备相关
    - `PS2` 键盘映射 @OC-xlivans
    - 键盘无法输入的应急解决方案 `PS2N`
- `i2C`设备相关
    - OC `I2C-TPXX` 补丁方法
    - OC `I2C-GPIO` 补丁
- `HPET_RTC_TIMR`三合一声卡修复补丁
- 仿冒以太网和重置以太网 `BSD` 名称
- `CMOS`重置补丁
- `CMOS`内存和 ***RTCMemoryFixup***
- `AOAC`方法禁用独显
- 特殊更名和补丁
    - `Dell`特殊补丁
    - 小新 PRO13 特殊更名和补丁
- ACPIDebug
- 为了方便使用，整理了部分驱动列表，仅供参考：
  - config-1-Lilu-SMC-WEG-ALC驱动列表
  - config-2-PS2键盘驱动列表
  - config-3-BCM无线和蓝牙驱动列表
  - config-4-I2C驱动列表

### Credits

- 特别感谢：
  - @宪武 制作的适用于 **[OpenCore](https://github.com/acidanthera/OpenCorePkg)** 的 ACPI 部件补丁
  - @Bat.bat, @黑果小兵, @套陆 审核完善

- 感谢：
  - @冬瓜-X1C5th
  - @OC-xlivans
  - @Air 13 IWL-GZ-Big Orange (OC perfect)
  - @子骏oc IWL
  - @大勇-小新air13-OC-划水小白
  - ......

- Thanks:
  - [Acidanthera](https://github.com/acidanthera) Maintaining: 
    - [AppleSupportPkg](https://github.com/acidanthera/AppleSupportPkg)
    - ~~[AptioFixPkg](https://github.com/acidanthera/AptioFixPkg)~~(Achieved)
    - [MacInfoPkg](https://github.com/acidanthera/MacInfoPkg)
    - [OCSupportPkg](https://github.com/acidanthera/OCSupportPkg)
    - [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg)
