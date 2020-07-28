# 仿冒环境光传感器

## 综述

从 `macOS Catalina` 开始，笔记本设备需要仿冒环境光传感器 `ALS0` 来实现亮度保存和自动亮度调节，需要说明的是只有真正拥有环境光传感器硬件的机器才能实现真正意义上的自动亮度调节。

## 使用方法

分为两种情况，原始 `ACPI` 存在环境光传感器设备接口和不存在环境光传感器设备接口。首先在原始 `ACPI` 里面查找 `ACPI0008`，如果可以查到相关设备，一般是 `ALSD`，则说明存在环境光传感器设备接口，否则即为不存在环境光传感器设备接口。

### 存在环境光传感器设备接口

> 案例

```swift
Device (ALSD)
{
  Name (_HID, "ACPI0008" /* Ambient Light Sensor Device */)  // _HID: Hardware ID
  Method (_STA, 0, NotSerialized)  // _STA: Status
  {
    If ((ALSE == 0x02))
    {
      Return (0x0B)
    }

    Return (Zero)
  }

  Method (_ALI, 0, NotSerialized)  // _ALI: Ambient Light Illuminance
  {
    Return (((LHIH << 0x08) | LLOW))
  }

  Name (_ALR, Package (0x05)  // _ALR: Ambient Light Response
  {
    Package (0x02)
    {
      0x46,
      Zero
    },

    Package (0x02)
    {
      0x49,
      0x0A
    },

    Package (0x02)
    {
      0x55,
      0x50
    },

    Package (0x02)
    {
      0x64,
      0x012C
    },

    Package (0x02)
    {
      0x96,
      0x03E8
    }
  })
}
```

这种情况可以利用预置变量另其 `_STA` 方法返回 `0x0B` 以启用原始 `ACPI` 存在的环境传感器设备，方法如下：

```swift
DefinitionBlock ("", "SSDT", 2, "OCLT", "ALSD", 0)
{
    External (ALSE, IntObj)

    Scope (_SB)
    {
        Method (_INI, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                ALSE = 2
            }
        }
    }
}
```

### 不存在环境光传感器设备接口

对于这种情况我们只需要仿冒一个 `ALS0` 设备即可，方法如下：

```swift
DefinitionBlock ("", "SSDT", 2, "ACDT", "ALS0", 0)
{
    Scope (_SB)
    {
        Device (ALS0)
        {
            Name (_HID, "ACPI0008")
            Name (_CID, "smc-als")
            Name (_ALI, 0x012C)
            Name (_ALR, Package (0x01)
            {
                Package (0x02)
                {
                    0x64,
                    0x012C
                }
            })
            Method (_STA, 0, NotSerialized)
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }
    }
}
```

## 注意

- 任何情况下仿冒设备都是安全且有效的，即使原始 `ACPI` 中存在环境光传感器设备接口，也可以直接仿冒 `ALS0`。
- 被修正的 `变量` 可能存在于多个地方，对它修正后，在达到我们预期效果的同时，有可能影响到到其他部件。
- 原始 `ACPI` 中存在环境光传感器设备时，其名称可能不是 `ALSD`，比如 `ALS0`，不过至今没发现有其它名称。
- 原始 `ACPI` 中存在环境光传感器设备时，如果要用预置变量方法强制启用时，需要注意原始 `ACPI` 中是否存在 `_SB.INI`，如果存在请使用仿冒 `ALS0` 方法。
