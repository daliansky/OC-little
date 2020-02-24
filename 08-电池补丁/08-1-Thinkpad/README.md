# ThinkPad电池补丁

## 说明

- 请阅读`附件`《ThinkPad 电池系统》。
- 确认主电池路径是 `\_SB.PCI0.`**`LPC`**`.EC.BAT0` 或者 `\_SB.PCI0.`**`LPCB`**`.EC.BAT0`，非两者，本章内容仅供参考。
- 可能用到的更名
  - TP 电池基本更名
  - TP 电池 `Mutex` 置 `0` 更名
  - TP 禁止 `BAT1` 更名
  - TP 双物理电池 `Notify` 更名- `LPC` 
  - TP 双物理电池 `Notify` 更名- `LPCB` 
- 可能用到的补丁
  - ***SSDT-OCBAT0-TP***
  - ***SSDT-OCBATC-TP-`LPC`***
  - ***SSDT-OCBATC-TP-`LPCB`***

## 更名和补丁

- 单电池系统

  - 更名：
    - TP 电池基本更名
    - TP 电池 `Mutex` 置 `0` 更名
  - 补丁
    - ***SSDT-OCBAT0-TP***

- 双电池系统一块物理电池

  - 更名
    - TP 电池基本更名
    - TP 电池 `Mutex` 置 `0` 更名
    - TP 禁止 `BAT1` 更名
  - 补丁
    - ***SSDT-OCBAT0-TP***

- 双电池系统二块物理电池

  - 更名
    - TP 电池基本更名
    - TP 电池 `Mutex` 置 `0` 更名
    - TP 双物理电池 `Notify` 更名-`LPC` 或者 TP 双物理电池 `Notify` 更名-`LPCB`
  - 补丁
    - ***SSDT-OCBAT0-TP***
    - ***SSDT-OCBATC-TP-`LPC`*** 或者 ***SSDT-OCBATC-TP-`LPCB`***
    - ***SSDT-NTFY***
  - 加载顺序
    - 主电池补丁 -- ***SSDT-OCBAT0-TP***
    - `BATC`补丁 -- ***SSDT-OCBATC-TP-`LPC`*** 或者 ***SSDT-OCBATC-TP-`LPCB`***
    - `Notify`补丁 -- ***SSDT-NTFY***

## 注意事项

- ***SSDT-OCBAT0-TP*** 是主电池补丁。选用时根据机器型号选择对应的补丁。

- 选用更名和补丁时，应注意 `LPC` 和 `LPCB` 的区别。

- `TP 禁止 BAT1 更名` 样本未验证所有 Thinkpad 机器，请尝试。

- 是否需要 `TP 电池 Mutex 置 0 更名`，自行尝试。

- 双物理电池需要更名`Notify (...BAT0, ...)`为`Notify (...BATC, ...)`，更名`Notify (...BAT1, ...)`为`Notify (...BATC, ...)`，如果直接使用更名的话会造成在其它操作系统无法恢复，从而影响其它操作系统(如`Windows`)。因此需要重写涉及`Notify (...BAT0, ...)`和`Notify (...BAT1, ...)`的方法，示例如下：

  > T580 原文

  ```swift
  Method (_Q22, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
  {
      CLPM ()
      If (HB0A)
      {
          Notify (BAT0, 0x80) // Status Change
      }
  
      If (HB1A)
      {
          Notify (BAT1, 0x80) // Status Change
      }
  }
  ```

  > 重写

  ```swift
  //
  // For ACPI Patch:
  // _Q22 to XQ22:
  // Find:    5f51 3232
  // Replace: 5851 3232
  //
  Method (_Q22, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
  {
      If (_OSI ("Darwin"))
      {
          CLPM ()
          If (HB0A)
          {
              Notify (BATC, 0x80) // Status Change
          }
  
          If (HB1A)
          {
              Notify (BATC, 0x80) // Status Change
          }
      }
      Else
      {
          \_SB.PCI0.LPCB.EC.XQ22 ()
      }
  }
  ```

  ***详见`Notify`补丁--`SSDT-NTFY.dsl`***

  > 已验证机器为`ThinkPad T580`，补丁和更名如下：

  ```
  SSDT-OCBAT0-TP_tx80_x1c6th
  SSDT-OCBATC-TP-LPCB
  SSDT-NTFY
  TP电池基本更名
  TP双物理电池Notify更名-LPCB
  ```

### 附件：ThinkPad电池系统

#### 概述

Thinkpad 电池系统分为单电池系统和双电池系统。

- 双电池系统就是机器配备了二块电池。或者，虽然机器只装备了一块电池，但提供了第二块电池的物理接口以及对应的ACPI。第二块电池作为可选件，可以后期安装。双电池系统的机器可能有一块电池，也可能有二块电池。
- 单电池系统是机器配备了一块电池，且只有一块电池的 ACPI。

- 比如，T470, T470s 的电池结构属于双电池系统，T470P 的电池结构属于单电池系统。再比如，T430 系列属于双电池系统，机器本身只有一块 电池，但可以通过光驱位安装第二块电池。

#### 单，双电池系统判定

- 双电池系统：ACPI 中同时存在 `BAT0` 和 `BAT1`。
- 单电池系统：ACPI 中只有 `BAT0`，无 `BAT1`。
