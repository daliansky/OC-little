# OpenCore 部件补丁说明

按照 OpenCore 要求和建议，制作本部件补丁。说明如下：

- 所有设备名称不更名。
- 除以下方法可能需要更名外，其他方法不更名。
  - 和亮度快捷键有关的。见《亮度快捷键》。
  - 因解决睡眠和唤醒问题要求的 `_PTS` 和 `_WAK` 更名。见《PTS WAK 综合补丁和扩展补丁》。
  - 因解决睡眠按键问题要求的相关更名。见《PNP0C0E 强制睡眠》。
- 因需要引入的名词：
  - 工作状态设定
  - 预置变量法
  - 覆盖变量法
- 暂时未涉及和电池有关的更名和补丁。

## Credits

- 特别感谢：@宪武 制作的适用于 **[OpenCore](https://github.com/acidanthera/OpenCorePkg)** 的 ACPI 部件补丁
- Thanks to [Acidanthera](https://github.com/acidanthera) for providing [AppleSupportPkg](https://github.com/acidanthera/AppleSupportPkg), [AptioFixPkg](https://github.com/acidanthera/AptioFixPkg), [MacInfoPkg](https://github.com/acidanthera/MacInfoPkg), [OCSupportPkg](https://github.com/acidanthera/OCSupportPkg) and [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg).
