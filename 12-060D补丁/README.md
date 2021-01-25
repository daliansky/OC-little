# 0D/6D 补丁

## 概述

- `_PRW` 定义了一个部件的唤醒方法。其 `Return` 2 个或者 2 个以上字节组成的数据包。有关 `_PRW` 详细的内容参见 ACPI 规范。
- 有这么一些部件，由于他们的 `_PRW` 和 macOS 发生了冲突从而导致机器刚刚睡眠成功就被立即唤醒。为了解决问题，必须对这些部件实施补丁。这些部件 `_PRW` 数据包的第 1 个字节是 `0D` 或者 `6D`。因此，这种补丁被称为 `0D/6D补丁`，也叫`秒醒补丁`，也叫`睡了即醒补丁`。为了描述方便，以下统一称之为 `0D/6D补丁`。
- `_PRW` 数据包的第 2 个字节多为 `03` 或者 `04`，将这个字节修正为 `0` 即完成了 `0D/6D补丁`。
- 不同的机器对 `_PRW` 定义的方法可能不同，其数据包的内容、形式也可能多样化。实际的 `0D/6D补丁` 应视具体情况而定。见后文的描述。
- 我们期待 OpenCore 后续版本能够解决 `0D/6D` 问题。

### 可能需要 `0D/6D补丁` 的部件

- USB 类设备

  - `ADR` 地址：`0x001D0000`, 部件名称：`EHC1` 【6代之前】
  - `ADR` 地址：`0x001A0000`, 部件名称：`EHC2` 【6代之前】
  - `ADR` 地址：`0x00140000`, 部件名称：`XHC`, `XHCI`, `XHC1` 等
  - `ADR` 地址：`0x00140001`, 部件名称：`XDCI`
  - `ADR` 地址：`0x00140003`, 部件名称：`CNVW`

- 以太网

  - 6 代以前，`ADR` 地址：`0x00190000`, 部件名称：`GLAN`, `IGBE` 等。
  - 6 代及 6 代以后，`ADR` 地址：`0x001F0006`, 部件名称：`GLAN`, `IGBE` 等。

- 声卡

  - 6 代以前，`ADR` 地址：`0x001B0000`, 部件名称：`HDEF`, `AZAL` 等。
  - 6 代及 6 代以后，`ADR` 地址：`0x001F0003`, 部件名称：`HDAS`, `AZAL` 等。

  **注意1**：通过查找名称确认上述部件的方法并不可靠。可靠的方法是搜索 `ADR 地址`, `_PRW`。

  **注意2**：新发布的机器可能会有新的部件需要 `0D/6D补丁`。

## `_PRW` 的多样性和对应的补丁方法

- `Name 类型`

  ```Swift
    Name (_PRW, Package (0x02)
    {
        0x0D, /* 可能是0x6D */
        0x03，/* 可能是0x04 */
        ...
    })
  ```

  这种类型的 `0D/6D补丁` 适合用二进制更名方法修正 `0x03`（或 `0x04`）为 `0x00`。文件包提供了：

  - Name-0D 更名 .plist
    - `Name0D-03` to `00`
    - `Name0D-04` to `00`
  - Name-6D 更名 .plist
    - `Name6D-03` to `00`
    - `Name6D-04` to `00`

- `Method 类型` 之一：`GPRW(UPRW)`

  ```Swift
    Method (_PRW, 0, NotSerialized)
    {
      Return (GPRW (0x6D, 0x04)) /* 或者Return (UPRW (0x6D, 0x04)) */
    }
  ```

  较新的机器大多数属于这种情况。按常规方法（更名-补丁）即可。文件包提供了：

  - ***SSDT-GPRW***（补丁文件内有二进制更名数据）
  - ***SSDT-UPRW***（补丁文件内有二进制更名数据）

- `Method 类型`之二：`Scope`

  ```Swift
    Scope (_SB.PCI0.XHC)
    {
        Method (_PRW, 0, NotSerialized)
        {
            ...
            If ((Local0 == 0x03))
            {
                Return (Package (0x02)
                {
                    0x6D,
                    0x03
                })
            }
            If ((Local0 == One))
            {
                Return (Package (0x02)
                {
                    0x6D,
                    One
                })
            }
            Return (Package (0x02)
            {
                0x6D,
                Zero
            })
        }
    }
  ```

  这种情况并不常见。对于示例的情况，使用二进制更名 ***Name6D-03 to 00*** 即可。其他形式内容自行尝试。

- `Name 类型`, `Method 类型`混合方式

  对于多数 TP 机器，涉及 `0D/6D补丁` 的部件既有 `Name 类型`，也有 `Method 类型`。采用各自类型的补丁即可。**需要注意的是**二进制更名补丁不可滥用，有些不需要 `0D/6D补丁` 的部件 `_PRW` 也可能是 `0D` 或 `6D`。为防止这种错误，应提取 `System DSDT` 文件加以验证、核实。
### 方案2

- 通过预置变量法 (将 `\SS3` `\SS4_` 赋值为 Zero) 屏蔽所有 `GPRW` 调用者设备的唤醒能力

**补丁**：

```Swift
External (SS3_, IntObj)
External (SS4_, IntObj)

If (_OSI ("Darwin"))
{
    \SS3 = Zero
    \SS4 = Zero
}
        
```
**补丁原理**：

- 当为SS3 SS4赋值为 0 生效后从原始 `GPRW` 方法分析

```Swift
Name (SS1, Zero)
Name (SS2, Zero)
Name (SS3, One)  // 声明整数对象 SS3 为 1 后被\SS3 = Zero 赋值为 0
Name (SS4, One)  // 声明整数对象 SS4 为 1 后被\SS4 = Zero 赋值为 0

Name (PRWP, Package (0x02) 
{
    Zero, 
    Zero 
})

Method (GPRW, 2, NotSerialized)
{
    PRWP [Zero] = Arg0    // 调用者将 Arg0 (0x69 或 0x6D 或其它 GpeInfo ) 赋值给 PRWP [0]
    Local0 = (SS1 << One)    
    Local0 |= (SS2 << 0x02) 
    Local0 |= (SS3 << 0x03)  // Local0 = 0
    Local0 |= (SS4 << 0x04)  // Local0 = 0
    If (((One << Arg1) & Local0))    // Local0 = 0 时按位与结果为 0 则条件不成立
    {
        PRWP [One] = Arg1
    }
    Else
    {
        Local0 >>= One 
        
        FindSetLeftBit (Local0, PRWP [One])  // Local0 = 0 则 MSb 为 0
    }

    Return (PRWP)   // 返回结果 Package PRWP
}
```
**注意事项**：

- 此方法与`SSDT-GPRW.aml` 相比缺点为无法针对特定共享 GPE 的设备集的唤醒能力 (如GPE 0x6D, 0x0D, 0x69, 0x09 或其它GpeInfo)，补丁生效后所有GPRW方法的调用设备都会丧睡眠唤醒能力
但从实际应用角度 0D 6D 补丁的本质便是修复睡眠即醒问题正常情况共享 GPE L69 或 L09 的设备通常不会触发设备唤醒 使用上与`SSDT-GPRW.aml`也无本质区别，
### 注意事项

- 本文描述的方法适用于Hotpatch。
- 凡是用到了二进制更名，应提取 `System DSDT` 文件加以验证。
- 惠普机器`06/0D`补丁比较特殊，详见《12-2-惠普特殊的060D补丁》
