# PNP0C0E 强制睡眠

## `PNP0C0E` 睡眠方式

- ACPI 规范

  `PNP0C0E` — Sleep Button Device。有关 `PNP0C0E` 详细内容请查阅 ACPI 规范。

- `PNP0C0E` 睡眠条件

  执行 `Notify(***. SLPB, 0x80)`。`SLPB` 是 `PNP0C0E` 设备名称。

## 问题描述

部分机器提供了睡眠按键（小月亮按键），如：部分 ThinkPad 的 FN+F4，Dell 的 FN+Insert 等。当按下这个按键后，系统执行了 `PNP0C0E` 睡眠。可是，ACPI 错误地向系统传递了关机参数而非睡眠参数，造成睡眠失败、系统崩溃。即使能够睡眠也能正常唤醒，系统工作状态也被破坏。要使用这个睡眠按键需截取这个参数并纠正它。

## 解决方案

增设变量 `FNOK=0`，当按下睡眠按键时，令 `FNOK=1`。在睡眠和唤醒方法里 (`_PTS` 和 `_WAK`) 检查 `FNOK` 是否为 `1`，如果为 `1`，强制 `Arg0=3`（如果不干预的话`Arg0=5`）。待正常唤醒后恢复 `FNOK=0`。一次完整的睡眠和唤醒过程结束了。

### 更名和补丁组合（示例：Dell Latitude 5480 和 ThinkPad X1C5th）

- Dell Latitude 5480

  按键更名：`BTNV` to `XTNV` (Dell-FnInsert)

  补丁组合：

  - ***SSDT-PTSWAK***：综合补丁。内设变量 `FNOK=0`，并根据 `FNOK` 的变化做相应的修正。见《PTSWAK综合补丁和扩展补丁》。
  - ***SSDT-FnInsert_BTNV-dell***：睡眠按键补丁。执行 `PNP0C0E` 睡眠前令 `FNOK=1`。

- ThinkPad X1C5th

  按键更名：`_Q13 to XQ13` (TP-FnF4)

  补丁组合：

  - ***SSDT-PTSWAK***：同上。
  
  - ***SSDT-FnF4_Q13-X1C5th***：同上。
  
  **注意1**：X1C5th 的睡眠按键是 FN+4，有的TP的睡眠按键是 FN+F4。
  
  **注意2**：TP 机器 `LPC` 控制器名称可能是`LPC`、也可能是`LPCB`。

### 其他机器实现 `PNP0C0E` 睡眠

- 使用 ***SSDT-PTSWAK***。

- 查找睡眠按键位置。

  一般情况下，睡眠按键是 `EC` 的 `_Qxx`，这个 `_Qxx` 里包涵 `Notify(***.SLPB,0x80)` 指令。如果查找不到或者无法确认，DSDT 全文搜索 `Notify(***.SLPB,0x80)` ，找到其所在位置，逐步向上查找最终位置。

  注：SLPB是 `PNP0C0E` 设备名称。

- 参考示例制作睡眠按键补丁以及必要的更名。

### `PNP0C0E` 睡眠特点

- 睡眠过程稍快。
- 睡眠过程无法被终止。
