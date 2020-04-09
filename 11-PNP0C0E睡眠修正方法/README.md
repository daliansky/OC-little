# PNP0C0E 睡眠修正方法

## `PNP0C0E` 和 `PNP0C0D` 睡眠方式

- ACPI 规范

  `PNP0C0E` — Sleep Button Device

  `PNP0C0D` — Lid Device

  有关 `PNP0C0E` 和 `PNP0C0D` 详细内容请查阅 ACPI 规范。

- `PNP0C0E` 睡眠条件

  - 执行 `Notify(***.SLPB, 0x80)`。 `SLPB` 是 `PNP0C0E` 设备名称。
  
- `PNP0C0D` 睡眠条件

  - `_LID`  返回 `Zero` 。 `_LID` 是 `PNP0C0D` 设备当前状态。
  - 执行 `Notify(***.LID0, 0x80)`。 `LID0` 是 `PNP0C0D` 设备名称。

## 问题描述

部分机器提供了睡眠按键（小月亮按键），如：部分 ThinkPad 的 Fn+F4，Dell 的 Fn+Insert 等。当按下这个按键后，系统执行了 `PNP0C0E` 睡眠。可是，ACPI 错误地向系统传递了关机参数而非睡眠参数，从而导致系统崩溃。即使能够睡眠也能正常唤醒，系统工作状态也被破坏。

下列方法之一可以修复这个问题：

- 截取ACPI 传递的参数并纠正它。
- 将`PNP0C0E` 睡眠转换为`PNP0C0D` 睡眠。

## 解决方案

### 关联的3个补丁

- ***SSDT-PTSWAK*** ：定义变量 `FNOK` 和 `MODE` ，捕捉 `FNOK` 的变化。见《PTSWAK综合扩展补丁》。

  - `FNOK` 表示按键状态
    - `FNOK` =1：按下睡眠按键
    - `FNOK` =0：再次按下睡眠按键或者机器被唤醒后
  - `MODE` 设定睡眠模式
    - `MODE` =1：`PNP0C0E` 睡眠
    - `MODE` =0：`PNP0C0D` 睡眠

  注意：根据自己的需要设置 `MODE` ，但不可以更改 `FNOK` 。

- ***SSDT-LIDpatch*** ：捕捉 `FNOK` 变化

  - 如果 `FNOK` =1，盖子设备当前状态返回 `Zero`
  - 如果 `FNOK` =0，盖子设备当前状态返回原始值

  注意： `PNP0C0D` 设备名称、路径要和ACPI一致。

- ***睡眠按键补丁*** ：按键按下后，令 `FNOK` = `1` ，并根据不同的睡眠模式执行相应的操作

  注意：`PNP0C0D` 设备名称、路径要和ACPI一致。

#### 两种睡眠方式描述

- `MODE` =1模式：当按下睡眠按键时， ***睡眠按键补丁*** 令 `FNOK=1`。 ***SSDT-PTSWAK*** 捕捉到 `FNOK` 为 `1`，强制令`Arg0=3`（否则`Arg0=5`）。待唤醒后恢复 `FNOK=0`。一次完整的 `PNP0C0E` 睡眠和唤醒过程结束。
- `MODE` =0模式：当按下睡眠按键时，除了完成上述过程外， ***SSDT-LIDpatch*** 同时扑捉到 `FNOK=1` ，使 `_LID`  返回 `Zero` 并执行 `PNP0C0D` 睡眠。待唤醒后恢复 `FNOK=0`。一次完整的 `PNP0C0D` 睡眠和唤醒过程结束。

以下是 ***SSDT-LIDpatch*** 主要内容：

```Swift
Method (_LID, 0, NotSerialized)
{
    if(\_SB.PCI9.FNOK==1)
    {
        Return (0) /* 返回 Zero, 满足 PNP0C0D 睡眠条件之一 */
    }
    Else
    {
        Return (\_SB.LID0.XLID()) /* 返回原始值 */
    }
}
```

以下是 ***睡眠按键补丁*** 主要内容：

```Swift
If (\_SB.PCI9.MODE == 1) /* PNP0C0E 睡眠 */
{
    \_SB.PCI9.FNOK =1 /* 按下睡眠按键 */
    \_SB.PCI0.LPCB.EC.XQ13() /* 原始睡眠按键位置，示例是 TP 机器 */
}
Else /* PNP0C0D 睡眠 */
{
    If (\_SB.PCI9.FNOK!=1)
    {
            \_SB.PCI9.FNOK =1 /* 按下睡眠按键 */
    }
    Else
    {
            \_SB.PCI9.FNOK =0 /* 再次按下睡眠按键 */
    }
    Notify (\_SB.LID, 0x80) /* 执行 PNP0C0D 睡眠 */
}
```

### 更名和补丁组合示例:（Dell Latitude 5480 和 ThinkPad X1C5th）

- **Dell Latitude 5480**

  PTSWAK更名：`_PTS` to `ZPTS`、`_WAK` to `ZWAK`。

  盖子状态更名：`_LID` to `XLID`

  按键更名：`BTNV` to `XTNV` (Dell-Fn+Insert)

  补丁组合：

  - ***SSDT-PTSWAK***：综合补丁。根据自己的需要设置 `MODE`。
  - ***SSDT-LIDpatch***：盖子状态补丁。
  - ***SSDT-FnInsert_BTNV-dell***：睡眠按键补丁。

- **ThinkPad X1C5th**

  PTSWAK更名：`_PTS` to `ZPTS`、`_WAK` to `ZWAK`。

  盖子状态更名： `_LID` to `XLID`

  按键更名：`_Q13 to XQ13` (TP-Fn+F4)
  
  补丁组合：
  
  - ***SSDT-PTSWAK***：综合补丁。根据自己的需要设置 `MODE`。
  - ***SSDT-LIDpatch***：盖子状态补丁。修改补丁内 `LID0` 为 `LID`。
  - ***SSDT-FnF4_Q13-X1C5th***：睡眠按键补丁。
  
  **注意1**：X1C5th 的睡眠按键是 Fn+4，有的TP的睡眠按键是 Fn+F4。
  
  **注意2**：TP 机器 `LPC` 控制器名称可能是`LPC`、也可能是`LPCB`。

### 其他机器修复 `PNP0C0E` 睡眠

- 使用补丁： ***SSDT-PTSWAK*** ；更名：`_PTS` to `ZPTS`、`_WAK` to `ZWAK`。见《PTSWAK综合扩展补丁》。

  根据自己的需要修改 `MODE`。

- 使用补丁： ***SSDT-LIDpatch*** ；更名： `_LID` to `XLID` 。

  注意： `PNP0C0D` 设备名称、路径要和ACPI一致。

- 查找睡眠按键位置、制作 ***睡眠按键补丁***

  - 一般情况下，睡眠按键是 `EC` 下的 `_Qxx`，这个 `_Qxx` 里包涵 `Notify(***.SLPB,0x80)` 指令。如果查找不到，DSDT 全文搜索 `Notify(***.SLPB,0x80)` ，找到其所在位置，逐步向上查找最初位置。
  - 参考示例制作睡眠按键补丁以及必要的更名。

  注意1：SLPB是 `PNP0C0E` 设备名称。如果确认没有 `PNP0C0E` 设备，添加补丁：SSDT-SLPB（位于《添加缺失的部件》）。

  注意2： `PNP0C0D` 设备名称、路径要和ACPI一致。

### `PNP0C0E` 睡眠特点

- 睡眠过程稍快。
- 睡眠过程无法被终止。

### `PNP0C0D` 睡眠特点

- 睡眠过程中，再次按下睡眠按键立即终止睡眠。

- 接入外显时，按下睡眠按键后，工作屏幕为外显（内屏灭）；再次按下睡眠按键，内屏、外显正常。

## 注意事项

- `PNP0C0E` 和 `PNP0C0D` 设备名称、路径要和ACPI一致。
