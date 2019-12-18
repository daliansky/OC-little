# HPET_RTC_TIMR三合一补丁

## 描述

- 早期机器的声卡要求部件 **HPET** **`PNP0103`** 提供中断号 `0` & `8`，否则声卡不能正常工作。实际情况几乎所有机器的 **HPET** 未提供任何中断号。通常情况下，中断号 `0` & `8` 分别被 **RTC** **`PNP0B00`**、 **TIMR** **`PNP0100`** 占用。
- 解决上述问题需同步修复 **HPET**、**RTC**、**TIMR**。

## 补丁原理

- 禁用 **HPET**、**RTC**、**TIMR** 三部件。
- 仿冒三部件，即：**HPE0**、**RTC0**、**TIM0**。
- 将 **RTC0** 的 `IRQNoFlags (){8}` 和 **TIM0** 的 `IRQNoFlags (){0}` 移除并添加到 **HPE0**。

## 补丁方法

- 禁用 **HPET**、**RTC**、**TIMR**
  - **HPET**
  
    通常HPET存在 `_STA` ，因此，禁用HPET需使用《预置变量法》。如：
  
    ```Swift
    External (HPAE, IntObj) /* 或者 External (HPTE, IntObj) */
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            HPAE =0 /* 或者 HPTE =0 */
        }
    }
    ```
  
    注意： `_STA` 内 `HPAE` 变量随机器不同可能不同。
  
  - **RTC**  
  
    早期机器的 RTC 无 `_STA`，按 `Method (_STA,` 方法禁用 RTC。如：
  
    ```Swift
    Method (_STA, 0, NotSerialized)
    {
        If (_OSI ("Darwin"))
        {
            Return (0)
        }
        Else
        {
            Return (0x0F)
        }
    }
    ```
  
  - **TIMR**
  
    同 **RTC**
  
- 补丁文件：***SSDT-HPET_RTC_TIMR-fix***

  见上述 **补丁原理** ，参考示例。

## 注意事项

- 本补丁不可以和下列补丁同时使用：
  - 《预置变量法》的 ***SSDT-RTC_Y-AWAC_N***
  - OC 官方的 ***SSDT-AWAC***
  - 《仿冒设备》或者 OC 官方的 ***SSDT-RTC0***
  - 《CMOS重置补丁》的 ***SSDT-RTC0-NoFlags***
- `LPCB` 名称、 **三部件** 名称应和原始ACPI部件名称一致。
