# 仿冒RTC

## 综述

对于某些 300 系主板，`RTC` 设备默认被禁用的且无法通过和 `AWAC` 共用的 `STAS` 变量控制 `_STA` 的返回值来启用传统 RTC 设备，导致 ***`SSDT-AWAC`*** 无法生效，因此为了强制启用 `RTC` 设备，我们需要仿冒一个 `RTC0`。

## 使用方法

> 案例

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
          0x08,
         )
      IRQNoFlags ()
          {8}
  })
  Method (_STA, 0, NotSerialized)
  {
    Return (0);
  }
}
```

> 上面就是 `RTC` 设备被禁用的情况，仿冒方法如下：

```swift
DefinitionBlock ("", "SSDT", 2, "ACDT", "RTC0", 0)
{
    External (_SB_.PCI0.LPCB, DeviceObj)

    Scope (_SB.PCI0.LPCB)
    {
        Device (RTC0)
        {
            Name (_HID, EisaId ("PNP0B00"))
            Name (_CRS, ResourceTemplate ()
            {
                IO (Decode16,
                    0x0070,
                    0x0070,
                    0x01,
                    0x08,
                    )
                IRQNoFlags ()
                    {8}
            })
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (0);
                }
            }
        }
    }
}
```

## 注意

- 此部件只对 300 系主板有效。
- 此部件只在没有使用 ***`SSDT-AWAC`*** 且原始 `ACPI` 中 `RTC` 设备的 `_STA` 方法返回值是 `0` 时使用。
- 示例补丁的设备路径是 `LPCB`，请结合实际情况修改。
