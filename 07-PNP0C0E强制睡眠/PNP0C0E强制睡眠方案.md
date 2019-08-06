# PNP0C0E 强制睡眠

1. `PNP0C0E` 睡眠方式

   - ACPI 规范

     `PNP0C0E` — Sleep Button Device。关于 `PNP0C0E` 详细内容请查阅ACPI 规范。

   - `PNP0C0E` 睡眠条件

     执行 `Notify(***. SLPB, 0x80)`。`SLPB` 是 `PNP0C0E` 设备名称。

2. 问题描述

   部分机器提供了睡眠按键（小月亮按键），如：部分 ThinkPad 的 *FN+F4*，Dell 的 *FN+Insert* 等。当按下这个按键后，系统执行了 `PNP0C0E`睡眠。可是，ACPI 错误地向系统传递了关机参数而非睡眠参数，造成睡眠失败、系统崩溃。即使能够睡眠也能正常唤醒，系统工作状态也被破坏。要使用这个睡眠按键需截取这个参数并纠正它。

3. 解决方案

   增设变量 `FNOK=0`，当按下睡眠按键时，令 `FNOK=1`。在睡眠和唤醒方法里 (`_PTS` 和 `_WAK`) 检查 `FNOK` 是否为 `1`，如果为 `1`，强制纠正睡眠参数 `Arg0=3`。待正常唤醒后恢复 `FNOK=0`。一次完整的睡眠和唤醒过程结束了。

4. 更名和补丁组合

   以 Dell Latitude 5480 和 ThinkPad 430 为例来说明补丁方法。

   - dell Latitude5480

     按键更名：`BTNV` to `XTNV` (Dell-Insert)

     补丁组合：

     - ***SSDT-PTSWAK***：综合补丁。内设变量 `FNOK=0`，并根据 `FNOK` 的变化做相应的修正。见《PTSWAK综合补丁和扩展补丁》。
     - ***SSDT-SleepInsert-dell***：睡眠按键补丁。执行 `PNP0C0E` 睡眠前令 `FNOK=1`。

   - ThinkPad 430

     按键更名：`_Q13 to XQ13` (TP-FnF4)

     补丁组合：

     - ***SSDT-PTSWAK***：同上。

     - ***SSDT-SleepFnF4-TP-LPC***：同上。

     `注意`：其他TP机器可能需要***SSDT-SleepFnF4-TP-LPCB***，请核对你的`LPC`、`EC`名称。

5. 其他机器实现 `PNP0C0E` 睡眠

   - 使用SSDT-PTSWAK。
   - 查找睡眠按键位置，制作睡眠按键补丁以及必要的更名。

6. 如何查找睡眠按键的位置

   一般情况下，睡眠按键是 `EC` 的 `_Qxx`，这个 `_Qxx` 里包涵 `Notify(***. SLPB, 0x80)` 指令。如果查找不到或者无法确认，DSDT 全文搜索，找到 `Notify(***. SLPB, 0x80)` 所在位置，逐步向上查找确定最终位置。

   **注：SLPB是 `PNP0C0E` 设备名称**。

7. `PNP0C0E` 睡眠特点

   - 睡眠过程稍快。
   - 睡眠过程无法被终止。
