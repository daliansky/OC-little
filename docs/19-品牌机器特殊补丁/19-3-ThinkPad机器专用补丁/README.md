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
