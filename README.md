## OC部件补丁说明

按照OpenCore要求和建议，制作本部件补丁。说明如下：

- 所有设备名称不更名。
- 除以下方法可能需要更名外，其他方法不更名。
  - 和亮度快捷键有关的。见《亮度快捷键》。
  - 因解决睡眠和唤醒问题要求的 _PTS和 _WAK更名。见《PTSWAK综合补丁和扩展补丁》。
  - 因解决睡眠按键问题要求的相关更名。见《PNP0C0E强制睡眠》。
- 因需要引入的名词：
  - 工作状态设定
  - 预置变量法
  - 覆盖变量法
- 暂时未涉及和电池有关的更名和补丁。

## Credits

- 特别感谢：@宪武 整理出来的 `OpenCore` 部件补丁
- Thanks to [Acidanthera](https://github.com/acidanthera) for providing [AppleALC](https://github.com/acidanthera/AppleALC), [HibernationFixup](https://github.com/acidanthera/HibernationFixup), [Lilu](https://github.com/acidanthera/Lilu), [OpenCorePkg](https://github.com/acidanthera/OpenCorePkg), [VirtualSMC](https://github.com/acidanthera/VirtualSMC), [VoodooPS2](https://github.com/acidanthera/VoodooPS2), and [WhateverGreen](https://github.com/acidanthera/WhateverGreen).

