# ThinkPad电池补丁

## 说明

- 请阅读`附件`《ThinkPad 电池系统》。
- 确认 `主电池` 路径是 `\_SB.PCI0.`**`LPC`**`.EC.BAT0` 或者 `\_SB.PCI0.`**`LPCB`**`.EC.BAT0`，非两者，本章内容仅供参考。
- 以下分 **三种情况** 说明电池补丁的使用方法。

### 单电池系统更名和补丁

- 更名：
  - TP 电池基本更名
  - TP 电池 `Mutex` 置 `0` 更名
- 补丁
  - `主电池`补丁 -- ***SSDT-OCBAT0-TP******

### 双电池系统一块物理电池更名和补丁

- 更名
  - TP 电池基本更名
  - TP 电池 `Mutex` 置 `0` 更名
  - `BAT1` 禁用更名 `_STA to XSTA` 
  
    **注意**：请正确使用 `Count` ， `Skip` ， `TableSignature` ，并通过system-DSDT验证 `_STA to XSTA` 位置是否正确
- 补丁
  
  - `主电池`补丁 -- ***SSDT-OCBAT0-TP****** 
  - `BAT1`禁用补丁 -- ***SSDT-OCBAT1-disable-`LPC`*** 【或者 ***SSDT-OCBAT1-disable-`LPCB`*** 】

### 双电池系统二块物理电池更名和补丁

- 更名
  - TP 电池基本更名
  - TP 电池 `Mutex` 置 `0` 更名
  - `Notify` 更名
- 补丁
  - `主电池`补丁 --***SSDT-OCBAT0-TP******
  - `BATC`补丁 -- ***SSDT-OCBATC-TP-`LPC`*** 【或者 ***SSDT-OCBATC-TP-`LPCB`*** 、***SSDT-OCBATC-TP-`_BIX`*** 】
  - `Notify`补丁 -- ***SSDT-Notify-`LPC`*** 【或者 ***SSDT-Notify-`LPCB`*** 】
  
    **注意**：
  
    - 选用 `BATC`补丁时，7代+机器使用 ***SSDT-OCBATC-TP-`_BIX`*** 
    - 选用 `Notify`补丁时，应当 **仔细** 检查补丁里的 `_Q22`， `_Q24`， `_Q25`， `_Q4A`， `_Q4B`， `_Q4C`， `_Q4D`，`BATW`，`BFCC` 等内容是否与原始 `ACPI` 对应内容一致，如果不一致请修正补丁相应内容。比如：3代机器的 `_Q4C` 的内容和样本内容不同；4代、5代、6代、7代机器无 `_Q4C` ；7代+机器有 `BFCC` 。等等......。样本文件 ***SSDT-Notify-`LPCB`*** 仅适用于T580 。
- 加载顺序
  - `主电池`补丁
  - `BATC`补丁
  - `Notify`补丁

## 注意事项

- ***SSDT-OCBAT0-TP****** 是 `主电池` 补丁。选用时根据机器型号选择对应的补丁。
- 选用补丁时，应注意 `LPC` 和 `LPCB` 的区别。
- 是否需要 `TP 电池 Mutex 置 0 更名`，自行尝试。

## `Notify` 补丁示例【仅 `Method (_Q22` ...部分】

> T580 原文

```Swift
Method (_Q22, 0, NotSerialized)  /* _Qxx: EC Query, xx=0x00-0xFF */
{
    CLPM ()
    If (HB0A)
    {
        Notify (BAT0, 0x80) /* Status Change */
    }

    If (HB1A)
    {
        Notify (BAT1, 0x80) /* Status Change */
    }
}
```

> 重写

```swift
/*
 * For ACPI Patch:
 * _Q22 to XQ22:
 * Find:    5f51 3232
 * Replace: 5851 3232
 */
Method (_Q22, 0, NotSerialized)  /* _Qxx: EC Query, xx=0x00-0xFF */
{
    If (_OSI ("Darwin"))
    {
        CLPM ()
        If (HB0A)
        {
            Notify (BATC, 0x80) /* Status Change */
        }

        If (HB1A)
        {
            Notify (BATC, 0x80) /* Status Change */
        }
    }
    Else
    {
        \_SB.PCI0.LPCB.EC.XQ22 ()
    }
}
```

详见 `Notify` 补丁 --  ***SSDT-Notify-`BFCC`*** 

> 已验证机器为`ThinkPad T580`，补丁和更名如下：

- **SSDT-OCBAT0-TP_tx80_x1c6th** 
- **SSDT-OCBATC-TP-`LPCB`** 
- **SSDT-Notify-`LPCB`** 
- **TP电池基本更名** 
- **Notify更名** 

### 附件：ThinkPad电池系统

#### 概述

Thinkpad 电池系统分为单电池系统和双电池系统。

- 双电池系统就是机器配备了二块电池。或者，虽然机器只装备了一块电池，但提供了第二块电池的物理接口以及对应的 ACPI。第二块电池作为可选件，可以后期安装。双电池系统的机器可能有一块电池，也可能有二块电池。
- 单电池系统是机器配备了一块电池，且只有一块电池的 ACPI。

- 比如，T470, T470s 的电池结构属于双电池系统，T470P 的电池结构属于单电池系统。再比如，T430 系列属于双电池系统，机器本身只有一块电池，但可以通过光驱位安装第二块电池。

#### 单，双电池系统判定

- 双电池系统：ACPI 中同时存在 `BAT0` 和 `BAT1`
- 单电池系统：ACPI 中只有 `BAT0`，无 `BAT1`
