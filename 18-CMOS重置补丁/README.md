# CMOS重置补丁

## 描述

- 某些机器在关机或者重启时会出现 **“开机自检错误”**，这是由于 CMOS 被重置所导致的。
- 当使用 Clover 时，勾选 `ACPI\FixRTC` 可以解决上述问题。
- 当使用 OpenCore 时，官方提供了以下解决方法，见 ***Sample.plist*** ：
  - 安装 **RTCMemoryFixup.kext**
  - `Kernel\Patch` 补丁：**__ZN11BCM5701Enet14getAdapterInfoEv**
- 本章提供一种 SSDT 补丁方法来解决上述问题。这个 SSDT 补丁本质是仿冒 RTC，见《预置变量法》和《仿冒设备》。

## 解决方案

- 删除 **RTC `PNP0B00`** 部件 `_CRS` 的 **中断号**。

  ```Swift
  Device (RTC)
  {
      Name (_HID, EisaId ("PNP0B00"))
      Name (_CRS, ResourceTemplate ()
      {
          IO (Decode16,
              0x0070,
              0x0070,
              0x01,
              0x08,     /* 或者0x02,试验确定 */
              )
          IRQNoFlags () /* 删除此行 */
              {8}       /* 删除此行 */
      })
  }
  ```

## 补丁：SSDT-RTC0-NoFlags

- 禁用原始部件：**RTC**
  - 如果 **RTC** 不存在 `_STA` ，使用下列方法禁用 **RTC**：
  
    ```Swift
    External(_SB.PCI0.LPCB.RTC, DeviceObj)
    Scope (_SB.PCI0.LPCB.RTC)
    {
        Method (_STA, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                Return (Zero)
            }
            Else
            {
                Return (0x0F)
            }
        }
    }
    ```
  
  - 如果 **RTC** 存在 `_STA` ，使用预置变量法禁用 **RTC**。示例中的变量是 `STAS` ，使用时应注意 `STAS` 对其他设备、部件的影响。
  
    ```Swift
    External (STAS, FieldUnitObj)
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            STAS = 2
        }
    }
    ```

- 仿冒 **RTC0** ，参见样本。

## 注意

- 补丁里的设备名称、路径应和原始 ACPI 一致。

- 如果机器本身因某种原因禁用了 RTC，需仿冒 RTC 才能正常工作。在这种情况下出现了 **“开机自检错误”**，删除仿冒补丁的中断号即可：

  ```Swift
    IRQNoFlags () /* 删除此行 */
        {8}       /* 删除此行 */
  ```

**感谢** @Chic Cheung、@Noctis 辛苦付出！
