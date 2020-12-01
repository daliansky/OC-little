# 二进制更名

## 描述

本文所描述的方法不是通常意义的对 `Device` 或者 `Method` 的更名，是通过二进制更名启用或者禁用某设备。

## 风险

当 OC 引导其他系统时，ACPI 二进制更名有可能对其他系统造成影响。

## 示例

以启用 `HPET` 为例。我们希望它的 `_STA` 返回 `0x0F`。

二进制更名：

Find：`00 A0 08 48 50`「注：`00` = `{`; `A0` = `If` ......」

Replace：`00 A4 0A 0F A3` 「注：`00` = `{`; `A4 0A 0F` =`Return(0x0F)`; `A3` = `Noop`，用于补齐字节数量」

- 原始代码

  ```Swift
    Method (_STA, 0, NotSerialized)
    {
        If (HPTE)
        {
            Return (0x0F)
        }
        Return (Zero)
    }
  ```

- 更名后代码

  ```Swift
    Method (_STA, 0, NotSerialized)
    {
          Return (0x0F)
          Noop
          TE** ()
          Return (Zero)
    }
  ```

  **解释**：更名后出现了明显错误，但是这种错误不会产生危害。首先，`Return (0x0F)` 后面内容不会被执行。其次，错误位于 `{}` 内不会对其他内容产生影响。

  实际情况，我们应尽可能保证更名后语法的完整性。下面是完整的 `Find`, `Replace` 数据。
  
  Find：`00 A0 08 48 50 54 45 A4 0A 0F A4 00`
  
  Replace：`00 A4 0A 0F A3 A3 A3 A3 A3 A3 A3 A3`
  
  完整 `Replace` 后代码
  
  ```Swift
    Method (_STA, 0, NotSerialized)
    {
        Return (0x0F)
        Noop
        Noop
        Noop
        Noop
        Noop
        Noop
        Noop
        Noop
    }
  ```

## 要求

- ***ACPI*** 原始文件

  `Find` 二进制文件必须是 ***ACPI*** 原始文件，不可以被任何软件修改、保存过，也就是说它必须是机器提供的原始二进制文件。

- `Find` 唯一性、正确性

   `Find` 数量只有一个，**除非** 我们本意就是对多处实施 `Find` 和 `Replace` 相同操作。

   **特别注意**：任何重写一段代码而从中查找确认的二进制数据，非常不可信！

- `Replace` 字节数量

  `Find`, `Replace` 字节数量要求相等。比如 `Find` 10个字节，那么 `Replace`  也是 10 个字节。如果`Replace` 少于 10 个字节就用 `A3`（空操作）补齐。

## `Find` 数据查找方法

通常，用二进制软件（如 `010 Editor` ）和 `MaciASL.app` 打开同一个 `ACPI` 文件，以二进制数据方式和文本方式 `Find` 相关内容，观察上下文，相信很快能够确定 `Find` 数据。

## `Replace` 内容

《要求》中说明 `Find` 时，【任何重写一段代码而从中查找确认的二进制数据，非常不可信！】，然而 `Replace` 可以这样操作。按照上面的示例，我们写一段代码：

```Swift
    DefinitionBlock ("", "SSDT", 2, "hack", "111", 0)
    {
        Method (_STA, 0, NotSerialized)
        {
            Return (0x0F)
        }
    }
```

编译后用二进制软件打开，发现：`XX ... 5F 53 54 41 00 A4 0A 0F` ，其中 `A4 0A 0F` 就是 `Return (0x0F)`。

注： `Replace`  内容要遵循 ACPI 规范和 ASL 语言要求。

## 注意事项

- 更新BIOS有可能造成更名失效。`Find` & `Replace` 字节数越多失效的可能性也越大。

### 附：TP-W530 禁止 BAT1

Find： `00 A0 4F 04 5C 48 38 44 52`

Replace： `00 A4 00 A3 A3 A3 A3 A3 A3`

- 原始代码

  ```Swift
    Method (_STA, 0, NotSerialized)
    {
          If (\H8DR)
          {
              If (HB1A)
              {
              ...
    }
  ```

- 更名后代码

  ```Swift
    Method (_STA, 0, NotSerialized)
    {
          Return (Zero)
          Noop
          Noop
          Noop
          Noop
          Noop
          Noop
          If (HB1A)
          ...
    }
  ```

# 预置变量法

## 描述

- 所谓 **预置变量法** 就是对ACPI的一些变量（`Name`类型和`FieldUnitObj`类型）预先赋值，达到初始化的目的。【虽然这些变量在定义时已经赋值，但在 `Method` 调用它们之前没有改变。】
- 通过第三方补丁文件在 `Scope (\)` 内对这些变量进行修正可以达到我们预期的补丁效果。

## 风险

- 被修正的 `变量` 可能存在于多个地方，对它修正后，在达到我们预期效果的同时，有可能影响到到其他部件。
- 被修正的 `变量` 可能来自硬件信息，只能读取不能写入。这种情况下需要 **二进制更名** 和 **SSDT补丁** 共同完成。应当注意，当OC引导其他系统时，有可能无法恢复被更名的 `变量` 。见 **示例4** 。

### 示例1

某设备 _STA 原文：

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

因某个原因我们需要禁用这个设备，为了达成目的 `_STA` 应返回 `Zero` 。从原文可以看出只要 `SDS1` 不等于 `0x07` 即可。采用 **预置变量法** 如下：

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

官方补丁 ***SSDT-AWAC*** 用于某些 300+ 系机器强制启用 RTC 并同时禁用 AWAC 。

注：启用 RTC 也可以使用 ***SSDT-RTC0*** ，见《仿冒设备》。

原文：

```Swift
Device (RTC)
{
    ...
    Method (_STA, 0, NotSerialized)
    {
            If ((STAS == One))
            {
                Return (0x0F)
            }
            Else
            {
                Return (Zero)
            }
    }
    ...
}
Device (AWAC)
{
    ...
    Method (_STA, 0, NotSerialized)
    {
            If ((STAS == Zero))
            {
                Return (0x0F)
            }
            Else
            {
                Return (Zero)
            }
    }
    ...
}
```

从原文可以看出，只要 `STAS`=`1`，就可以启用 RTC 并同时禁用 `AWAC`。采用 **预置变量法** 如下：

- 官方补丁 ***SSDT-AWAC***

  ```Swift
  External (STAS, IntObj)
  Scope (_SB)
  {
      Method (_INI, 0, NotSerialized)  /* _INI: Initialize */
      {
          If (_OSI ("Darwin"))
          {
              STAS = One
          }
      }
  }
  ```

  注：官方补丁引入了路径 `_SB._INI`，使用时应确认 DSDT 以及其他补丁不存在 `_SB._INI`。

- 改进后补丁  ***SSDT-RTC_Y-AWAC_N***

  ```Swift
  External (STAS, IntObj)
  Scope (\)
  {
      If (_OSI ("Darwin"))
      {
          STAS = One
      }
  }
  ```

### 示例3

使用 I2C 补丁时，可能需要启用 `GPIO`。参见《OCI2C-GPIO补丁》的 ***SSDT-OCGPI0-GPEN***。

某原文：

```Swift
Method (_STA, 0, NotSerialized)
{
    If ((GPEN == Zero))
    {
        Return (Zero)
    }
    Return (0x0F)
}
```

从原文可以看出，只要 `GPEN` 不等于 `0` 即可启用 `GPIO`。采用 **预置变量法** 如下：

```Swift
External(GPEN, FieldUnitObj)
Scope (\)
{
    If (_OSI ("Darwin"))
    {
        GPEN = 1
    }
}
```

### 示例4

当 `变量` 是只读类型时，解决方法如下：

- 对原始 `变量` 更名
- 补丁文件中重新定义一个同名 `变量`

如：某原文：

```Swift
OperationRegion (PNVA, SystemMemory, PNVB, PNVL)
Field (PNVA, AnyAcc, Lock, Preserve)
{
    ...
    IM01,   8,
    ...
}
...
If ((IM01 == 0x02))
{
    ...
}
```

实际情况 `IM01` 不等于0x02，{...} 的内容无法被执行。为了更正错误采用 **二进制更名** 和 **SSDT补丁** ：

**更名**： `IM01` rename `XM01`

```text
Find:    49 4D 30 31 08
Replace: 58 4D 30 31 08
```

**补丁**：

```Swift
Name (IM01, 0x02)
If (_OSI ("Darwin"))
{
    ...
}
Else
{
      IM01 = XM01 /* 同原始ACPI变量的路径 */
}
```
### 示例5

使用将设备原始 `_STA` 方法 (Method) 引用为 `IntObj` 对其赋值操作来更改设备状态的使能位。

某原文：可使用本方法操作的实例

```Swift
Method (_STA, 0, NotSerialized)
{
    If ((XXXX == Zero))
    {
        Return (Zero)
    }
    Return (0x0F)
}

Method (_STA, 0, NotSerialized)
{
    Return (0x0F)
}

Name (_STA, 0x0F)

```
可以看出以上例举的`_STA`方法中仅包含返回设备状态的使能位和根据条件判断返回的使能位，若要不使用重命名和更改条件的预置变量可在自定义SSDT中可直接将`_STA`方法引用为`IntObj`

操作例举禁用某设备：
```Swift

External (_SB_.PCI0.XXXX._STA, IntObj)

\_SB.PCI0.XXXX._STA = Zero 

```
`_STA`方法的使能位具体设置请参阅 **ASL 语言基础** 

之所以本方法在实际运用中能有效，主要是因为在ACPI规范中`_STA`方法的在操作系统OSPM模块对设备状态评估和初始化的优先级高于`_INI _ADR _HID`且`_STA`的返回值本身也是整数`Integer`

某原文：不可使用本方法的操作实例

```Swift
Method (_STA, 0, NotSerialized)
{
    ECTP (Zero)
    If (XXXX == One)
    {
        Return (0x0F)
    {
    
    Return (Zero)
}

Method (_STA, 0, NotSerialized)
{
    ^^^GFX0.CLKF = 0x03
    Return (Zero)
}
```
从综上例举可看出原 `_STA` 方法除了设置了条件设备状态使能位以外，还包含了其他操作 `方法调用 ECTP (Zero）` 和 `赋值操作 ^^^GFX0.CLKF = 0x03`，
使用本方法将会导致原`_STA`方法中的其他引用和操作失效而出现错误(非ACPI Error)


**风险**：OC引导其他系统时可能无法恢复 `XM01`。
