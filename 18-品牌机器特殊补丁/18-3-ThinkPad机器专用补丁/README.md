# ThinkPad 机器专用补丁

## 特殊更名

和联想部分机器一样，ThinkPad 机器的 DSDT 也可能包含 `PNLF` 字段。在 DSDT 中搜索 `PNLF`，如果存在 `PNLF` 则需要添加如下重命名：

```text
Find:     504E4C46
Replace:  584E4C46
```

## 特殊补丁

### ThinkPad 触控板属性注入和小红点防漂移补丁

ThinkPad 的触摸板和小红点属于 ELAN 类型、使用 `Synaptics` 协议通过 SMBus 连接。由于目前没有可以在 macOS 下稳定使用的 SMBus 驱动，只能使用 VoodooPS2。在使用 VoodooPS2 时，为了启用 VoodooPS2 中内置的 ThinkPad 优化，需要通过 SSDT 注入触控板属性。

**SSDT-ThinkPad_ClickPad**

如果你的触控板是下图所示的两种之一，那么请使用这个补丁。

![](https://i.loli.net/2020/04/26/ceEyQfgikqzjapL.png)

**SSDT-ThinkPad_TouchPad**

如果你的触控板是下图所示的两种之一，那么请使用这个补丁。

![](https://i.loli.net/2020/04/26/FUxIp4nmAb2PSws.png)

----

大多数 ThinkPad 机器的键盘路径是 `\_SB.PCI0.LPC.KBD` 或者 `\_SB.PCI0.LPCB.KBD`。提供的两个补丁默认使用 `_SB.PCI0.LPC.KBD`，请自行对照 DSDT 查看原始 LPC 总线名称和键盘名称，对照替换 ACPI 路径。

两个补丁都涉及到对键盘设备 RMCF 变量的修改。如果同时使用了「PS2 键盘映射」章节中的 PS2 映射补丁，需要手动合并 RMCF 变量内容，合并样例请看 **SSDT-ThinkPad_ClickPad+PS2Map-AtoZ**，这个补丁中同时包括了注入 ThinkPad ClickPad 属性和 A -> Z 的 PS2 Map 映射。

另，Rebhabman 的 VoodooPS2Controller 已经过时，推荐使用 acidanthera 的 [VoodooPS2](https://github.com/acidanthera/VoodooPS2)，搭配 [VoodooInput](https://github.com/acidanthera/VoodooInput) 可为 ThinkPad 启用全部触控板手势。

----

以下是对 SSDT 中各项配置的说明，由 [@SukkaW](https://github.com/SukkaW) 基于 VoodooPS2 原始维护者 Rehabman 的 [README](https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller/blob/master/README.md) 以及 VoodooPS2 中的代码注释整理得到。

- DragLockTempMask：临时拖动锁定快捷键。`0x40004` 对应的是 Control、`0x80008` 对应的是 Command、`0x100010` 对应的是 Option。需要注意的是这些是映射在实体键盘上的原始关系、不受「系统偏好设置」中设置的功能键顺序的影响。
- DynamicEWMode：动态 EW 模式。EW 模式下双指手势（如双指滑动）会平分触控板带宽。而启用动态 EW 模式后，触控板将不会一直处于 EW 模式下，因此能够改善 ThinkPad ClickPad 触摸板的双指滚动的响应速度（译者注：双指滚动时只需要两根手指同时处于触控板上、然后触控板只反馈其中一根手指滑动的方向和距离，节省另一根手指的带宽）。而在拖动文件时（译者注，一根手指按住触控板、另一根手指滑动）ClickPad 将会被按下，此时 EW 模式仍会被启用。这一选项导致少数触控板出现问题，因此默认被禁用了。
- FakeMiddleButton：用三根手指同时点击触控板时模拟中键点击。
- HWResetOnStart：一些触控板设备（尤其是 ThinkPad 的触控板和小红点）需要启用这一选项才可以正常工作。
- ForcePassThrough 和 SkipPassThrough：PS2 输入设备可以发送一种特殊的类型为 "Pass Through" 的 6 字节数据包，可以实现触控板和指点杆（如 ThinkPad 小红点）的信号交错传输。VoodooPS2 已经实现了对 PS2 设备类型 "Pass Through" 数据包的自动识别，这两个选项仅供调试用途。
- PalmNoAction When Typing：打字时手掌可能不小心会接触到触控板，启用这一选项后将能够避免误触。
- SmoothInput：启用该选项后，驱动将通过对每三个取样点取平均以获得平滑的移动轨迹。
- UnsmoothInput：启用该选项后，当停止对触控板进行输入时，将会撤销取样平均、而以停止输入时的位置作为轨迹结束位置。这是由于在轨迹末端，取样平均可能会导致较大的误差甚至轨迹反向。默认这一选项和 SmoothInput 是同时启用的。
- DivisorX 和 DivisorY：设置触控板边缘宽度。边缘区域将不会提供任何响应。
- MomentumScrollThreshY：使用触控板双指滚动、手指离开触控板后继续滚动，如同存在惯性。这一选项默认启用，以尽可能模仿 Mac 设备的触控板体验。
- MultiFingerHorizontalDivisor 和 MultiFingerVerticalDivisor：部分触控板在最右侧 和/或 最底部预留了专门的「滑动条」区域。这部分区域默认不响应多指滑动，这两个选项提供了对不响应区域宽度的设置。默认值为 1，即整个触控板都能够响应多指滑动。
- Resolution：触控板「分辨率」，单位为 像素点数目每英寸，即手指在触摸板上滑动一英寸将会在屏幕上划过多少像素。
- ScrollDeltaThresh：容错值，用于避免在 macOS 10.9 Maverick 上双指滑动时出现的抖动问题。默认值为 10。
