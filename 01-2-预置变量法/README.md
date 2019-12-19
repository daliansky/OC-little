# 预置变量法

## 描述

所谓`预置变量法`就是对ACPI的一些变量（`Name`类型和`FieldUnitObj`类型）预先赋值，达到初始化的目的。【虽然这些变量在定义时已经赋值，但在`Method`调用它们之前没有改变。】

通过第三方补丁文件在`Scope (\)`内对这些变量进行修正可以达到我们预期的补丁效果。

### 示例1

假如要禁止某设备。通常的方法是使设备的 `_STA` 返回 `Zero`。

某原文：

```Swift
    Method (_STA, 0, NotSerialized)
    {
        ECTP (Zero)
        If ((SDS1 == 0x07))
        {
            Return (0x0F)
        }
        Return (Zero)
    }
```

可以看出，只要让 `SDS1` 不等于 `0x07` 就能 让 `_STA` 返回 `Zero`。采用 **预置变量法** 如下：

```Swift
    Scope (\)
    {
        External (SDS1, FieldUnitObj)
        If (_OSI ("Darwin"))
        {
            SDS1 = 0
        }
    }
```

### 示例2

一些 Dell 机器，睡眠期间呼吸灯“`灭`”，希望改变为`呼吸状态`。研究发现：Dell 机器有个工作状态管控，当工作在Win8 时，呼吸灯“`灭`”；当工作在 Win7时，呼吸灯呈`呼吸状态`。另外，在没有操作系统补丁的情况下，这个工作状态管控呈失控状态，同时造成亮度快捷键补丁失效。

**注**：工作状态不同于操作系统。

原文：

```Swift
    Name (ACOS, Zero)
    Name (ACSE, Zero)
    ...
    If ((ACOS == Zero))
    {
        ACOS = One
        ACSE = Zero
        ......
            If (_OSI (WIN7))
            {
                ACOS = 0x80
            }
            If (_OSI (WIN8))
            {
                ACOS = 0x80
                ACSE = One
            }
        ...
    }
```

按照 ***预置变量法***，设置 Dell 工作状态为 Win7。补丁文件：***SSDT-OCWork-dell***

```Swift
    External (_SB.ACOS, IntObj)
    External (_SB.ACSE, IntObj)
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            \_SB.ACOS = 0x80
            \_SB.ACSE = Zero /*ACSE=0:win7;;ACSE=1:win8*/
        }
    }
```

### 示例3

官方补丁 ***SSDT-AWAC***，作用是强制启用 RTC，适用于部分 300 系机器。使用时请确认`\_SB`下无 `_INI`，且 RTC 设备下的 `_STA` 方法存在 `STAS`。

```Swift
    External (STAS, IntObj)
    Scope (_SB)
    {
        Method (_INI, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                STAS = One
            }
        }
    }
```

### 示例4

在 I2C 补丁时，可能需要启用 GPIO，`OCI2C-TPXX补丁方法` 的 `GPIO 补丁集合` 采用了`预置变量法`。如：***SSDT-OCGPI0-GPEN***, ***SSDT-OCGPI0-GPHD***, ***SSDT-OCGPI0-SBRG*** 等。
