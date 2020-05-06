# 操作系统补丁

## 描述

- **操作系统补丁** 用于解除系统对某些部件的限制。通常情况下，**「不建议」** 使用 **操作系统补丁** 。对于受系统限制而无法正常工作的部件，应根据 ACPI 的具体情况定制补丁。

- 有关 **操作系统补丁** 方面的简要叙述见附件《操作系统补丁由来》。

## 更名

- **OSID to XSID**

  ```text
  Find:     4F534944
  Replace:  58534944
  ```

- **OSIF to XSIF**

  ```text
  Find:     4F534946
  Replace:  58534946
  ```

- **_OSI to XOSI**

  ```text
  Find:     5F4F5349
  Replace:  584F5349
  ```

  在原始 DSDT 中搜索 `OSI`，如果除了 `_OSI` 函数以外、还有其它包含 `OSI` 的字段（如 Dell 笔记本的 `OSID`、部分 ThinkPad 和联想笔记本的 `OSIF`），必须先添加 对这些包含 `OSI` 字段的重命名（如 `OSID to XSID`、`OSIF to XSIF`）、然后再添加 `_OSI to XOSI`。  
  如果除 `_OSI` 函数以外无其它包含 `OSI` 的字段、直接添加 `_OSI to XOSI` 即可。

## 补丁： ***SSDT-OC-XOSI***

```Swift
Method(XOSI, 1)
{
    If (_OSI ("Darwin"))
    {
        If (Arg0 == //"Windows 2009"  //  = win7, Win Server 2008 R2
                    //"Windows 2012"  //  = Win8, Win Server 2012
                    //"Windows 2013"  //  = win8.1
                    "Windows 2015"  //  = Win10
                    //"Windows 2016"  //  = Win10 version 1607
                    //"Windows 2017"  //  = Win10 version 1703
                    //"Windows 2017.2"//  = Win10 version 1709
                    //"Windows 2018"  //  = Win10 version 1803
                    //"Windows 2018.2"//  = Win10 version 1809
                    //"Windows 2018"  //  = Win10 version 1903
            )
        {
            Return (0xFFFFFFFF)
        }
        Else
        {
            Return (Zero)
        }
    }
    Else
    {
        Return (_OSI (Arg0))
    }
}
```

### 使用

- **最大值**

  对于单系统，可以设定操作系统参数为 DSDT 所允许的最大值。如：DSDT 的最大值是 `Windows 2018`，则设定 `Arg0 == "Windows 2018"`。通常 `Arg0 == "Windows 2013"` 以上就能解除系统对部件的限制。

  **注**：单系统不建议使用 **操作系统补丁**。

- **匹配值**  

  对于双系统，设定的操作系统参数应和Windows系统版本一致。如：Windows系统是win7，设定Arg0 == "Windows 2009"。

## 注意事项

  - 某些机器的 `Method` 使用了和 `_OSI` 相似的名称(如 `dell` 的 `OSID`)，当它位于 `_SB`(不足4个字符)并出现全路径时，其二进制数据和 `_OSI` 相同，导致被操作系统更名(`_OSI to XOSI`)连带更名而产生错误。这种情况下需先于 `_OSI to XOSI` 之前对它更名为其他(如 `OSID to XSID`)以避免错误。

## 附件：操作系统补丁由来

- 当系统加载时，ACPI 的 `_OSI` 会接收到一个参数，不同的系统，接收的参数不同，ACPI 执行的指令就不同。比如，系统是 **Win7**，这个参数是 `Windows 2009`，系统是 **Win8**，这个参数就是 `Windows 2012`。如：

  ```Swift
  If ((_OSI ("Windows 2009") || _OSI ("Windows 2013")))
  {
      OperationRegion (PCF0, SystemMemory, 0xF0100000, 0x0200)
      Field (PCF0, ByteAcc, NoLock, Preserve)
      {
          HVD0,   32,
          Offset (0x160),
          TPR0,   8
      }
      ...
  }
  ...
  Method (_INI, 0, Serialized)  /* _INI: Initialize */
  {
      OSYS = 0x07D0
      If (CondRefOf (\_OSI))
      {
          If (_OSI ("Windows 2001"))
          {
              OSYS = 0x07D1
          }

          If (_OSI ("Windows 2001 SP1"))
          {
              OSYS = 0x07D1
          }
          ...
          If (_OSI ("Windows 2013"))
          {
              OSYS = 0x07DD
          }

          If (_OSI ("Windows 2015"))
          {
              OSYS = 0x07DF
          }
          ...
      }
  }
  ```

  ACPI 还定义了 `OSYS`，`OSYS` 和上述参数关系如下：

  - `OSYS = 0x07D9`: Win7 系统，即 `Windows 2009`
  - `OSYS = 0x07DC`: Win8 系统，即 `Windows 2012`
  - `OSYS = 0x07DD`: Win8.1 系统，即 `Windows 2013`
  - `OSYS = 0x07DF`: Win10 系统，即 `Windows 2015`
  - `OSYS = 0x07E0`: Win10 1607，即 `Windows 2016`
  - `OSYS = 0x07E1`: Win10 1703，即 `Windows 2017`
  - `OSYS = 0x07E1`: Win10 1709，即 `Windows 2017.2`
  - `OSYS = 0x07E2`: Win10 1803，即 `Windows 2018`
  - `OSYS = 0x07E2`: Win10 1809，即 `Windows 2018.2`
  - `OSYS = 0x????`: Win10 1903，即 `Windows 2019`
  - ...

- 当加载的系统不被 ACPI 识别时，`OSYS` 被赋予默认值，这个值随机器不同而不同，有的代表 `Linux`，有的代表 `Windows2003`，有的是其他值。

- 不同的操作系统支持不同的硬件，比如 `Win8` 以上才支持 I2C 设备。

- 当加载 macOS 时，`_OSI` 接受的参数不会被 ACPI 识别，`OSYS` 被赋予了默认值。这个默认值通常小于 Win8 要求的值，显然 I2C 无法工作。这就需要补丁来纠正这种错误，操作系统补丁源于此。

- 某些其他部件也可能和 `OSYS` 有关。
