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

```
Device (RTC)
{
		......
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
		......
}
Device (AWAC)
{
		......
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
		......
}
```

从原文可以看出，只要STAS=1，就可以启用 RTC并同时禁用AWAC。采用 **预置变量法** 如下：

- 官方补丁 ***SSDT-AWAC*** 

  ```
      External (STAS, IntObj)
      Scope (_SB)
      {
          Method (_INI, 0, NotSerialized)  // _INI: Initialize
          {
              If (_OSI ("Darwin"))
              {
                  STAS = One
              }
          }
      }
  ```

  注：官方补丁引入了路径 `_SB._INI` ，使用时应确认 DSDT 以及其他补丁不存在 `_SB._INI` 。

- 改进后补丁  ***SSDT-RTC_Y-AWAC_N*** 

  ```
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

 I2C 补丁时，可能需要启用 GPIO。参见《OCI2C-GPIO补丁》的 ***SSDT-OCGPI0-GPEN*** 。

某原文：

```
		Method (_STA, 0, NotSerialized)
		{
				If ((GPEN == Zero))
				{
						Return (Zero)
				}
				Return (0x0F)
		}
```

从原文可以看出，只要GPEN不等于0即可启用GPIO。采用 **预置变量法** 如下：

```
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

```
  OperationRegion (PNVA, SystemMemory, PNVB, PNVL)
  Field (PNVA, AnyAcc, Lock, Preserve)
  {
			......
			IM01,   8,           
			......
  }
  ......
	If ((IM01 == 0x02))
	{
			......
	}
```

实际情况 `IM01` 不等于0x02，{...} 的内容无法被执行。为了更正错误采用 **二进制更名** 和 **SSDT补丁** ：

**更名**： `IM01` rename `XM01` 

```
	Find:		49 4D 30 31 08
	Replace:58 4D 30 31 08
```

**补丁**：

```
	Name (IM01, 0x02)
	If (_OSI ("Darwin"))
	{
	}
	Else
	{
      IM01 = XM01 //同原始ACPI变量的路径
	}
```

**风险**：OC引导其他系统时可能无法恢复 `XM01` 。

