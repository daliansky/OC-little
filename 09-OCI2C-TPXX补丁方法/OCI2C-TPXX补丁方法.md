# OCI2C-TPXX补丁方法

## 说明

本方法提供一种对 I2C 设备实施 Hotpatch 补丁的解决方案。本方法不涉及 I2C 补丁具体过程和细节。有关更多的 I2C 方面内容详见：

- @penghubingzhou：[https://www.penghubingzhou.cn](https://www.penghubingzhou.cn)

- @Bat.bat：[https://github.com/williambj1/VoodooI2C-PreRelease/blob/master/触摸板补充.md#iv-查看-ioregisteryexplorer-里-voodooi2c-是否正常加载](https://github.com/williambj1/VoodooI2C-PreRelease/blob/master/触摸板补充.md#iv-查看-ioregisteryexplorer-里-voodooi2c-是否正常加载)

- VoodooI2C 官方文档：[https://voodooi2c.github.io/#GPIO%20Pinning/GPIO%20Pinning](https://voodooi2c.github.io/#GPIO%20Pinning/GPIO%20Pinning)

- VoodooI2C 官方支持帖 [https://www.tonymacx86.com/threads/voodooi2c-help-and-support.243378/](https://www.tonymacx86.com/threads/voodooi2c-help-and-support.243378/)

- Q群：`837538729` (1 群已满)，`921143329` (2 群)

## 补丁原理和过程

- 禁止原 I2C 设备。详见《预置变量法》。

- 新建一个 I2C 设备 `TPXX`，将原设备所有内容移植到 `TPXX` 中。

- 修正 `TPXX` 有关内容：

  - 原 I2C 设备`名称`全部替换为 `TPXX`。

  - **修正** `_STA` 部分为：

    ```Swift
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
    ```

  - **修正**禁止原 I2C 设备时用到的变量的`有关内容`，使其符合逻辑关系。

  - **修正**涉及到系统变量 OSYS 的`有关内容`，使其符合逻辑关系。

- 排除错误。

- I2C 补丁。

### 示例 (Dell Latitude 5480，设备路径：`\_SB.PCI0.I2C1.TPD1`)

- 使用《预置变量法》禁止 `TPD1`。

  ```Swift
    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            SDS1 = 0
        }
    }
  ```

- 新建设备 `TPXX`，将原 `TPD1` 所有内容移植到 `TPXX` 中。

  ```Swift
    External(_SB.PCI0.I2C1, DeviceObj)
    Scope (_SB.PCI0.I2C1)
    {
        Device (TPXX)
        {
           原TPD1内容
        }
    }
  ```

- 修正 `TPXX` 内容

  - 所有 `TPD1` 替换为 `TPXX`。
  
  - 补丁中 `_STA` 部分替换为：
  
    ```Swift
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
    ```
  
  - 查找 `SDS1` (禁止 `TPD1` 时用到的变量)，将原 `If (SDS1...)` 修改为 `If (one)`。
  
  - 查找 `OSYS`，删除（注释掉）以下内容：
  
    ```Swift
        //If (LLess (OSYS, 0x07DC))
        //{
        //    SRXO (GPDI, One)
        //}
    ```
  
    注：`OSYS` 小于 `0x07DC` 时，I2C 设备不工作（`0x07DC`代表 Windows8）。
  
- 添加外部引用 `External...` 修补所有错误。

- I2C 补丁（略）
